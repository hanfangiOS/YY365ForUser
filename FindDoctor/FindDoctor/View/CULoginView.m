//
//  CULoginView.m
//  CollegeUnion
//
//  Created by li na on 15/3/13.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CULoginView.h"
#import "CUUIContant.h"
#import "TipHandler.h"
#import "TipHandler+HUD.h"
#import "CUUserManager.h"
#import "MBProgressHUD.h"
#import "UIImage+Color.h"

#define Height_Field            35.0
#define kTextFieldTPadding      25.0

#define kLoginCellHeight        (Height_Field + kTextFieldTPadding)

#define kLeftIconLeftMargin     3
#define kLeftIconTopMargin      (Height_Field - kLeftIconHeight)/2
#define kLeftIconBottomMargin   8
#define kLeftIconWidth          20
#define kLeftIconHeight         kLeftIconWidth

#define kFieldLeftMargin        8

//#define kButtonLeftMargin       10
//#define kButtonTopMargin        20
//#define kButtonHeight           50

#define kCodeButtonWith         80

//#define UIColorFromHex(Color_Hex_Tableview_Separator) [UIColor colorWithWhite:230.0/255.0 alpha:1.0f]

//#define vMargin_UITextField 10

@interface CULoginView ()

@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation CULoginView
{
    NSString *_codetoken;
    UILabel *_codeLabel;
    int timerCount;
    
    UIButton *togglePassButton;
    
    UIImageView *leftUserIcon;
    UIImageView *leftPassIcon;
    UIImageView *leftCodeIcon;
}

- (instancetype)initWithFrame:(CGRect)frame hasVerify:(BOOL)hasVerify attachedView:(UIView *)attachedView
{
    return [self initWithFrame:frame hasVerify:hasVerify hasPassword:NO attachedView:attachedView];
}

- (instancetype)initWithFrame:(CGRect)frame hasVerify:(BOOL)hasVerify hasPassword:(BOOL)hasPassword attachedView:(UIView *)attachedView
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.hasVerify = hasVerify;
        self.attachedView = attachedView;
        self.hasPassword = hasPassword;
        
        //手机号
        UIView *userPhoneTextView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), kLoginCellHeight)];
        userPhoneTextView.backgroundColor = self.backgroundColor;
        
        leftUserIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kLeftIconLeftMargin, userPhoneTextView.frameHeight - kLeftIconHeight - kLeftIconBottomMargin, kLeftIconWidth , kLeftIconHeight)];
//        [leftUserIcon setImage:[UIImage imageNamed:@"login_icon_user"]];
        [leftUserIcon setImage:[UIImage imageNamed:@"login_icon_phone"]];
        leftUserIcon.contentMode = UIViewContentModeScaleAspectFit;
        [userPhoneTextView addSubview:leftUserIcon];
        
        CGFloat filedOriginX = kLeftIconLeftMargin + kLeftIconWidth + kFieldLeftMargin;
        
        CGRect userFieldRect = CGRectMake(filedOriginX, kTextFieldTPadding, CGRectGetWidth(self.frame) - filedOriginX , Height_Field);
        _userField = [[UITextField alloc] initWithFrame:userFieldRect];
        [_userField addTarget:self action:@selector(checkShuldLogin) forControlEvents:UIControlEventEditingChanged];
        _userField.delegate = self;
//        _userField.text = self.userPhone;
        _userField.returnKeyType = UIReturnKeyDone;
        _userField.keyboardType = UIKeyboardTypeNumberPad;
        //_userField.placeholder = @"请输入手机号/邮箱";
//        _userField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号/邮箱" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        _userField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        _userField.font = [UIFont systemFontOfSize:14];
        _userField.textColor = [UIColor whiteColor];
        [userPhoneTextView addSubview:_userField];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(userPhoneTextView.frame) - kDefaultLineHeight,  CGRectGetWidth(self.bounds), kDefaultLineHeight)];
        lineView1.backgroundColor = [UIColor whiteColor];
        [userPhoneTextView addSubview:lineView1];
        
        [self addSubview:userPhoneTextView];
        
//        if (hasVerify) {
//            [leftUserIcon setImage:[UIImage imageNamed:@"login_icon_phone"]];
//            _userField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//        }
        
        //密码
        UIView *userPassTextView = [[UIView alloc] initWithFrame:userPhoneTextView.frame];
        userPassTextView.frameY = CGRectGetMaxY(userPhoneTextView.frame);
        userPassTextView.backgroundColor = self.backgroundColor;
        
        leftPassIcon = [[UIImageView alloc] initWithFrame:leftUserIcon.frame];
        [leftPassIcon setImage:[UIImage imageNamed:@"login_icon_lock"]];
        leftPassIcon.contentMode = UIViewContentModeScaleAspectFit;
        [userPassTextView addSubview:leftPassIcon];
        
        CGRect passFieldRect = userFieldRect;
        _passField = [[UITextField alloc] initWithFrame:passFieldRect];
        [_passField addTarget:self action:@selector(checkShuldLogin) forControlEvents:UIControlEventEditingChanged];
//        _passField.text = self.userPass;
        _passField.secureTextEntry = YES;
        _passField.delegate = self;
        _passField.returnKeyType = UIReturnKeyDone;
        //_passField.placeholder = @"请输密码";
        _passField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        _passField.font = [UIFont systemFontOfSize:14];
        _passField.textColor = [UIColor whiteColor];
        [userPassTextView addSubview:_passField];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(userPassTextView.frame) - kDefaultLineHeight,  CGRectGetWidth(self.frame), kDefaultLineHeight)];
        lineView2.backgroundColor = [UIColor whiteColor];
        [userPassTextView addSubview:lineView2];
        
        togglePassButton = [UIButton buttonWithType:UIButtonTypeCustom];
        togglePassButton.frame = CGRectMake(CGRectGetMaxX(_passField.frame) - kLeftIconWidth, userPassTextView.frameHeight - kLeftIconHeight - kLeftIconBottomMargin, kLeftIconWidth, kLeftIconHeight);
        [togglePassButton setImage:[UIImage imageNamed:@"login_show_password"] forState:UIControlStateNormal];
        [togglePassButton setImage:[UIImage imageNamed:@"login_hide_password"] forState:UIControlStateHighlighted];
        togglePassButton.adjustsImageWhenHighlighted = NO;
        [togglePassButton addTarget:self action:@selector(togglePassButtonTouchDownAction) forControlEvents:UIControlEventTouchDown];
        [togglePassButton addTarget:self action:@selector(togglePassButtonTouchUpAction) forControlEvents:UIControlEventTouchUpInside];
        [userPassTextView addSubview:togglePassButton ];
        
        [self addSubview:userPassTextView];
        
        if (hasVerify)
        {
            if (!hasPassword) {
                userPassTextView.hidden = YES;
            }
            
            //手机验证
            UIView *codeTextView = [[UIView alloc] initWithFrame:userPhoneTextView.frame];
            codeTextView.backgroundColor = self.backgroundColor;
            codeTextView.frameY = CGRectGetMaxY(userPhoneTextView.frame);
            
            if (hasPassword) {
                codeTextView.frameY = CGRectGetMaxY(userPassTextView.frame) + 1;
            }
            
            leftCodeIcon = [[UIImageView alloc] initWithFrame:leftUserIcon.frame];
            [leftCodeIcon setImage:[UIImage imageNamed:@"login_icon_code"]];
            leftCodeIcon.contentMode = UIViewContentModeScaleAspectFit;
            [codeTextView addSubview:leftCodeIcon];
            
            CGRect codeFieldRect = userFieldRect;
            _codeField = [[UITextField alloc] initWithFrame:codeFieldRect];
            //_codeField.placeholder = @"手机验证码";
            _codeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机验证码" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            _codeField.returnKeyType = UIReturnKeyDone;
            _codeField.keyboardType  = UIKeyboardTypeNumberPad;
            _codeField.delegate = self;
            _codeField.textColor = [UIColor whiteColor];
            [_codeField addTarget:self action:@selector(checkShuldLogin) forControlEvents:UIControlEventEditingChanged];
            _codeField.font = [UIFont systemFontOfSize:14];
            [codeTextView addSubview:_codeField];
            
            _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _codeButton.frame = CGRectMake(CGRectGetMaxX(_codeField.frame) - kCodeButtonWith, CGRectGetMinY(_codeField.frame), kCodeButtonWith, CGRectGetHeight(_codeField.frame));
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
            
            [self addSubview:codeTextView];
            
            UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(codeTextView.frame) - kDefaultLineHeight,  CGRectGetWidth(self.frame), kDefaultLineHeight)];
            lineView3.backgroundColor = [UIColor whiteColor];
            [codeTextView addSubview:lineView3];
        }
    }
    return self;
}

- (float)fHeight
{
    float fHeight = 0.0;
    if (self.hasVerify && self.hasPassword)
    {
        fHeight = kLoginCellHeight * 3;
    }
    else
    {
        fHeight = kLoginCellHeight * 2;
    }
    return fHeight;

}

- (void)togglePassButtonTouchDownAction
{
    _passField.secureTextEntry = NO;
}

- (void)togglePassButtonTouchUpAction
{
    _passField.secureTextEntry = YES;
}

- (void)codeLableAction
{
    [self endEdit];
    if ([_userField.text isEmpty])
    {
        [TipHandler showTipOnlyTextWithNsstring:@"请输入手机号"];
        return;
    }
    
    [self showHUD];
    
    [self startTimer];
    _codeField.text = @"";
    
    [[CUUserManager sharedInstance] requireVerifyCodeWithCellPhone:[self userName] resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result)
    {
        [self hideHUD];

        if (!result.hasError) {
            [CUUserManager sharedInstance].user.codetoken = [[result.responseObject valueForKey:@"data"] valueForKey:@"codetoken"];
            _codetoken =[[result.responseObject valueForKey:@"data"] valueForKey:@"codetoken"];
            [[CUUserManager sharedInstance] save];
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

- (void)endEdit{
    
}

- (void)checkShuldLogin
{
    if ([self.delegate respondsToSelector:@selector(loginView:editingChanged:)]) {
        [self.delegate loginView:self editingChanged:YES];
    }
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

- (NSString *)userName
{
    return self.userField.text;
}

- (NSString *)password
{
    return self.passField.text;
}

- (NSString *)code
{
    return self.codeField.text;
}

- (NSString *)codetoken
{
    return _codetoken;
}

- (NSString *)codeStr
{
    return self.codeField.text;
}

- (void)setUserImage:(UIImage *)userImage
{
    leftUserIcon.image = userImage;
}

- (void)setCodeImage:(UIImage *)codeImage
{
    leftCodeIcon.image = codeImage;
}

- (void)setPassImage:(UIImage *)passImage
{
    leftPassIcon.image = passImage;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(loginView:editingStateDidChanged:)]) {
        [self.delegate loginView:self editingStateDidChanged:YES];
    }
}

- (void)textFieldResignFirstResponder
{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [self.userField resignFirstResponder];
    [_passField resignFirstResponder];
    [_codeField resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(loginView:editingStateDidChanged:)]) {
        [self.delegate loginView:self editingStateDidChanged:NO];
    }
}

@end
