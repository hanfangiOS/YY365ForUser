//
//  CUPasswordView.m
//  FindDoctor
//
//  Created by Tom Zhang on 15/11/21.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CUPasswordView.h"
#import "CUUIContant.h"
#import "TipHandler.h"
#import "TipHandler+HUD.h"
#import "CUUserManager.h"
#import "MBProgressHUD.h"
#import "UIImage+Color.h"

#define kHeight_Field            35.0
#define kTextFieldTPadding      25.0

#define kPasswordCellHeight        (kHeight_Field + kTextFieldTPadding)

#define kLeftIconLeftMargin     3
#define kLeftIconTopMargin      (kHeight_Field - kLeftIconHeight)/2
#define kLeftIconBottomMargin   8
#define kLeftIconWidth          20
#define kLeftIconHeight         kLeftIconWidth

#define kFieldLeftMargin        8
#define kCodeButtonWith         80

@interface CUPasswordView()

@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation CUPasswordView
{
    UILabel *_codeLabel;
    int timerCount;
    
    UIButton *toggleOldPassButton;
    UIButton *toggleNewPassButton;
}

@synthesize newPassField = _newPassField;

- (UITextField *)newPassField
{
    return _newPassField;
}

- (void)setNewPassField:(UITextField *)newPassField
{
    _newPassField = newPassField;
}

- (instancetype)initWithFrame:(CGRect)frame hasOldPassword:(BOOL)hasOldPassword hasVerify:(BOOL)hasVerify attachedView:(UIView *)attachedView
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.hasOldPassword = hasOldPassword;
        self.hasVerify = hasVerify;
        self.attachedView = attachedView;
        
        CGRect frame1 = CGRectMake(0, 0, CGRectGetWidth(self.bounds), kPasswordCellHeight);
        
        // 原密码
        UIView *oldPassTextView = [[UIView alloc] initWithFrame:frame1];
        oldPassTextView.backgroundColor = self.backgroundColor;
        
//        CGFloat filedOriginX = kLeftIconLeftMargin + kLeftIconWidth + kFieldLeftMargin;
        
        CGRect oldPassFieldRect = CGRectMake(0, kTextFieldTPadding, CGRectGetWidth(self.frame) - kLeftIconWidth, kHeight_Field);
        _oldPassField = [[UITextField alloc] initWithFrame:oldPassFieldRect];
        _oldPassField.delegate = self;
        _oldPassField.returnKeyType = UIReturnKeyDone;
        _oldPassField.secureTextEntry = YES;
        _oldPassField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入原密码" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        _oldPassField.font = [UIFont systemFontOfSize:14];
        _oldPassField.textColor = [UIColor whiteColor];
        [oldPassTextView addSubview:_oldPassField];
        
//        toggleOldPassButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        toggleOldPassButton.frame = CGRectMake(CGRectGetMaxX(_oldPassField.frame), oldPassTextView.frameHeight - kLeftIconHeight - kLeftIconBottomMargin, kLeftIconWidth, kLeftIconHeight);
//        [toggleOldPassButton setImage:showIcon forState:UIControlStateNormal];
//        toggleOldPassButton.adjustsImageWhenHighlighted = NO;
//        [toggleOldPassButton addTarget:self action:@selector(toggleOldPassButtonAction) forControlEvents:UIControlEventTouchUpInside];
//        [oldPassTextView addSubview:toggleOldPassButton];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(oldPassTextView.frame) - kDefaultLineHeight,  CGRectGetWidth(self.bounds), kDefaultLineHeight)];
        lineView1.backgroundColor = [UIColor whiteColor];
        [oldPassTextView addSubview:lineView1];
        
        [self addSubview:oldPassTextView];
        
        // 新密码
        UIView *newPassTextView = [[UIView alloc] initWithFrame:frame1];
        
        if (hasOldPassword) {
            newPassTextView.frameY = CGRectGetMaxY(oldPassTextView.frame);
        }
        else {
            oldPassTextView.hidden = YES;
        }
        newPassTextView.backgroundColor = self.backgroundColor;
        
        CGRect newPassFieldRect = oldPassFieldRect;
        _newPassField = [[UITextField alloc] initWithFrame:newPassFieldRect];
        _newPassField.secureTextEntry = YES;
        _newPassField.delegate = self;
        _newPassField.returnKeyType = UIReturnKeyDone;
        _newPassField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入新密码" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        _newPassField.font = [UIFont systemFontOfSize:14];
        _newPassField.textColor = [UIColor whiteColor];
        [newPassTextView addSubview:_newPassField];
        
        toggleNewPassButton = [UIButton buttonWithType:UIButtonTypeCustom];
        toggleNewPassButton.frame = CGRectMake(CGRectGetMaxX(_newPassField.frame), newPassTextView.frameHeight - kLeftIconHeight - kLeftIconBottomMargin, kLeftIconWidth, kLeftIconHeight);
        [toggleNewPassButton setImage:[UIImage imageNamed:@"login_show_password"] forState:UIControlStateNormal];
        [toggleNewPassButton setImage:[UIImage imageNamed:@"login_hide_password"] forState:UIControlStateHighlighted];
        toggleNewPassButton.adjustsImageWhenHighlighted = NO;
        [toggleNewPassButton addTarget:self action:@selector(toggleNewPassButtonDownAction) forControlEvents:UIControlEventTouchDown];
        [toggleNewPassButton addTarget:self action:@selector(toggleNewPassButtonUpAction) forControlEvents:UIControlEventTouchUpInside];
        [newPassTextView addSubview:toggleNewPassButton];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(newPassTextView.frame) - kDefaultLineHeight,  CGRectGetWidth(self.frame), kDefaultLineHeight)];
        lineView2.backgroundColor = [UIColor whiteColor];
        [newPassTextView addSubview:lineView2];
        
        [self addSubview:newPassTextView];
        
        if (hasVerify)
        {
            if (!hasOldPassword) {
                oldPassTextView.hidden = YES;
            }
            
            //手机验证
            UIView *codeTextView = [[UIView alloc] initWithFrame:newPassTextView.frame];
            codeTextView.backgroundColor = self.backgroundColor;
            codeTextView.frameY = CGRectGetMaxY(newPassTextView.frame);
            
            CGRect codeFieldRect = CGRectMake(0, kTextFieldTPadding, CGRectGetWidth(self.frame) - kCodeButtonWith, kHeight_Field);
            _codeField = [[UITextField alloc] initWithFrame:codeFieldRect];
            _codeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机验证码" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            _codeField.returnKeyType = UIReturnKeyDone;
            _codeField.keyboardType  = UIKeyboardTypeNumberPad;
            _codeField.delegate = self;
            _codeField.textColor = [UIColor whiteColor];
            _codeField.font = [UIFont systemFontOfSize:14];
            [codeTextView addSubview:_codeField];
            
            _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _codeButton.frame = CGRectMake(CGRectGetMaxX(_codeField.frame), CGRectGetMinY(_codeField.frame), kCodeButtonWith, CGRectGetHeight(_codeField.frame));
            [_codeButton setBackgroundImage:[UIImage imageNamed:@"login_code_bg"] forState:UIControlStateNormal];
            [_codeButton setBackgroundImage:[UIImage imageNamed:@"login_code_bg"] forState:UIControlStateDisabled];
            _codeButton.adjustsImageWhenHighlighted = NO;
            [_codeButton addTarget:self action:@selector(codeLableAction) forControlEvents:UIControlEventTouchUpInside];
            [codeTextView addSubview:_codeButton];
            
            _codeLabel = [[UILabel alloc] initWithFrame:_codeButton.frame];
            _codeLabel.backgroundColor = [UIColor clearColor];
            _codeLabel.font = [UIFont systemFontOfSize:12];
            _codeLabel.textAlignment = NSTextAlignmentCenter;
            _codeLabel.textColor = [UIColor whiteColor];
            _codeLabel.text = @"获取验证码";
            [codeTextView addSubview:_codeLabel];
            
            UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(codeTextView.frame) - kDefaultLineHeight,  CGRectGetWidth(self.frame), kDefaultLineHeight)];
            lineView3.backgroundColor = [UIColor whiteColor];
            [codeTextView addSubview:lineView3];
            
            [self addSubview:codeTextView];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame hasOldPassword:(BOOL)hasOldPassword attachedView:(UIView *)attachedView
{
    return [self initWithFrame:frame hasOldPassword:hasOldPassword hasVerify:NO attachedView:attachedView];
}

- (instancetype)initWithFrame:(CGRect)frame hasVerify:(BOOL)hasVerify attachedView:(UIView *)attachedView
{
    return [self initWithFrame:frame hasOldPassword:NO hasVerify:hasVerify attachedView:attachedView];
}

- (float)fHeight
{
    float fHeight = kPasswordCellHeight;
    if (_hasOldPassword) {
        fHeight += kPasswordCellHeight;
    }
    if (_hasVerify) {
        fHeight += kPasswordCellHeight;
    }
    return fHeight;
}

- (void)toggleNewPassButtonDownAction
{
    _newPassField.secureTextEntry = NO;
}

- (void)toggleNewPassButtonUpAction
{
    _newPassField.secureTextEntry = YES;
}

- (void)codeLableAction
{
    [self endEditing:YES];
    [self showHUD];
    
    [self startTimer];
    _codeField.text = @"";
    
    [[CUUserManager sharedInstance] requireVerifyCodeWithCellPhone:[CUUserManager sharedInstance].user.cellPhone resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result)
     {
         [self hideHUD];
         
         if (!result.hasError) {
             if (![(NSNumber *)[result.responseObject valueForKey:@"err_code"] integerValue]) {
                 [CUUserManager sharedInstance].user.codetoken = [[result.responseObject valueForKey:@"data"] valueForKey:@"codetoken"];
                 [[CUUserManager sharedInstance] save];
             }
             else {
                 [TipHandler showTipOnlyTextWithNsstring:[result.responseObject valueForKey:@"data"]];
                 
                 [self stopTimer];
                 [self resetButton];
             }
         }
         else {
             //提示错误
             NSString *msg = [result.error.userInfo valueForKey:NSLocalizedDescriptionKey];
             NSLog(@"===ERROR===%@",msg);
             
             [TipHandler showTipOnlyTextWithNsstring:msg];
             
             [self stopTimer];
             [self resetButton];
         }
     } pageName:@"CUUserVerifyCode"];
    
}

- (void)stopTimer
{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)resetButton
{
    _codeLabel.text = @"获取验证码";
    _codeButton.enabled = YES;
    _codeField.text = @"";
}

- (void)startTimer {
    [self stopTimer];
    
    timerCount = 60;
    
    _codeButton.enabled = NO;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCode) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)updateCode
{
    if (timerCount < 0) {
        [self stopTimer];
        [self resetButton];
        return;
    }
    
    NSString *strTime = [NSString stringWithFormat:@"%.1d", timerCount];
    _codeLabel.text = [NSString stringWithFormat:@"%@s",strTime];
    
    timerCount--;
}

- (void)showHUD
{
    if (_hud == nil) {
        _hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        _hud.center = CGPointMake(CGRectGetWidth(self.attachedView.bounds)/2, CGRectGetHeight(self.attachedView.bounds)/2);
        [self.attachedView addSubview:_hud];
        [self.attachedView bringSubviewToFront:_hud];
    }
    
    [_hud show:YES];
}

- (void)hideHUD
{
    [_hud hide:NO];
}

- (NSString *)oldPassword
{
    return self.oldPassField.text;
}

- (NSString *)newPassword
{
    return self.newPassField.text;
}

- (NSString *)codeStr
{
    return self.codeField.text;
}

- (NSInteger)code
{
    return [self.codeField.text integerValue];
}

- (void)endEdit{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(passwordView:editingStateDidChanged:)]) {
        [self.delegate passwordView:self editingStateDidChanged:YES];
    }
}

- (void)textFieldResignFirstResponder
{
    [self.oldPassField resignFirstResponder];
    [self.newPassField resignFirstResponder];
    [self.codeField resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(passwordView:editingStateDidChanged:)]) {
        [self.delegate passwordView:self editingStateDidChanged:NO];
    }
}
@end
