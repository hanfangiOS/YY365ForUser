//
//  PasswordModifyController.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/20.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "PasswordModifyController.h"
#import "TipHandler+HUD.h"
#import "CUUserManager+Address.h"
#import "UIImageView+WebCache.h"

#define kHeadHeight     39.0
#define kRowNumber      3
#define kRowHeight      44.0

#define kTextTitleColor kDarkGrayColor
#define kTextColor      kBlackColor
#define kTextGrayColor  UIColorFromHex(0xc6c6c6)

#define kLineColor      UIColorFromRGB(200,200,200)

#define kTextFont       [UIFont systemFontOfSize:14]

#define kFooterHeight     64.0

@interface PasswordModifyController () <UITextFieldDelegate, UITextViewDelegate>

@end

@implementation PasswordModifyController
{
    UIScrollView      *_contentScrollView;
    
    UITextField       *_prePassField;
    UITextField       *_newPassField;
    UITextField       *_newPassField1;
    
    UIView            *_whiteView;
    
    float              _contentMaxY;
    
    UIButton          *_setDefaultButton;
    UIButton          *_confirmButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(243, 244, 245);
    self.title = @"新密码设置";
    
    [self initTempAddress];
    [self initSubviews];
    [self fillData];
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

- (void)initBottomView
{
    
}

- (void)initSubviews
{
    [self initNavigationBar];
    [self initContentView];
    [self initFooterView];
}

- (void)initContentView
{
    float originY = 40.0;
    float viewWidth = self.contentView.frameWidth;
    CGFloat viewHeight = self.contentView.frameHeight;
    CGFloat footerHeight = kFooterHeight;
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight - footerHeight)];
    _contentScrollView.backgroundColor = self.view.backgroundColor;
    [self.contentView addSubview:_contentScrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [_contentScrollView addGestureRecognizer:tap];
    
    _prePassField = [[UITextField alloc] init];
    _newPassField = [[UITextField alloc] init];
    _newPassField1 = [[UITextField alloc] init];
    
    NSArray *titleArray = @[@"原密码",@"新密码",@"再输入新密码"];
    NSArray *viewArray = @[_prePassField,_newPassField,_newPassField1];
    
    CGFloat padding = 20.0;
    CGFloat titleWidth = 110.0;
    CGFloat cellHeight = 34.0;
    for (int i = 0; i < titleArray.count; i ++) {
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(padding, originY, viewWidth - padding * 2, cellHeight)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.clipsToBounds = YES;
        [_contentScrollView addSubview:bgView];
        
        bgView.layer.cornerRadius = 3;
        bgView.layer.borderColor = kLightLineColor.CGColor;
        bgView.layer.borderWidth = kDefaultLineHeight;
        
        CGRect labelRect = CGRectMake(padding, originY, titleWidth, cellHeight);
        
        UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
        label.text = [titleArray objectAtIndex:i];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = kTextTitleColor;
        label.font = kTextFont;
        label.textAlignment = NSTextAlignmentCenter;
        [_contentScrollView addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 0, kDefaultLineHeight, 14)];
        lineView.centerY = label.centerY;
        lineView.backgroundColor = kTextTitleColor;
        [_contentScrollView addSubview:lineView];
        
        CGFloat fieldOriginX = CGRectGetMaxX(label.frame) + padding;
        UITextField *textField = [viewArray objectAtIndex:i];
        textField.frame = CGRectMake(fieldOriginX, originY, viewWidth - fieldOriginX - padding, cellHeight);
        textField.borderStyle = UITextBorderStyleNone;
        textField.textColor = kTextColor;
        textField.font = kTextFont;
        textField.delegate = self;
        textField.tag = i + 100;
        textField.returnKeyType = UIReturnKeyDone;
        textField.userInteractionEnabled = [self isTextfieldEditable];
        [_contentScrollView addSubview:textField];
        
        textField.secureTextEntry = YES;
        
        [textField addTarget:self action:@selector(textFieldEndEdit) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        originY += (cellHeight + padding);
    }
    
    _contentScrollView.contentSize = CGSizeMake(CGRectGetWidth(_contentScrollView.bounds), originY + 216);
    
    /*
     float whiteOriginY = kHeadHeight;
     CGRect whiteRect = CGRectMake(0, whiteOriginY, viewWidth, originY - whiteOriginY);
     _whiteView = [[UIView alloc] initWithFrame:whiteRect];
     _whiteView.backgroundColor = [UIColor whiteColor];
     [_contentScrollView insertSubview:_whiteView atIndex:0];*/
}

- (void)initNavigationBar
{
    
}

- (void)initFooterView
{
    float viewWidth = CGRectGetWidth(self.view.bounds);
    CGFloat footerHeight = kFooterHeight;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frameHeight - footerHeight, viewWidth, footerHeight)];
    footer.backgroundColor = self.contentView.backgroundColor;
    footer.clipsToBounds = YES;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, kDefaultLineHeight)];
    lineView.backgroundColor = kDarkLineColor;
    [footer addSubview:lineView];
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.frame = CGRectMake(20, 10, viewWidth - 20 * 2, 44);
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_confirmButton setBackgroundImage:[[UIImage imageNamed:kButtonGreenNor] stretchableImageByCenter] forState:UIControlStateNormal];
//    [_confirmButton setBackgroundImage:[[UIImage imageNamed:kButtonGreenSel] stretchableImageByCenter] forState:UIControlStateHighlighted];
    [_confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:_confirmButton];
    
    [self.contentView addSubview:footer];
    
    _confirmButton.backgroundColor = kGreenColor;
    _confirmButton.layer.cornerRadius = 3;
    _confirmButton.clipsToBounds = YES;
}

- (void)initTempAddress
{}

- (void)fillData
{}

- (BOOL)isInputValide
{
    BOOL isValide = YES;
    NSString *msg = nil;
    
    if (!isValide) {
        //[[[iToast makeText:msg] setGravity:iToastGravityCenter] show];
    }
    
    return isValide;
}

- (BOOL)isTextfieldEditable
{
    return YES;
}

#pragma mark - textFiled/textvView delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //[self beginEdit];
    //[self animateByView:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (void)textFieldEndEdit
{
    //[_phoneField becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = nil;
    if (range.length == 0) {
        newString = [textField.text stringByAppendingString:string];
    } else {
        NSString *headPart = [textField.text substringToIndex:range.location];
        NSString *tailPart = [textField.text substringFromIndex:range.location+range.length];
        newString = [NSString stringWithFormat:@"%@%@",headPart,tailPart];
        if (string.length) {
            newString = [newString stringByAppendingString:string];
        }
    }
    
    BOOL canInput = YES;
    
    [self textField:textField didChange:newString];
    
    return canInput;
}

- (void)textField:(UITextField *)textField didChange:(NSString *)newString
{
    if (textField == _prePassField) {
        
    }
    
    [self changeSaveButtonState];
}

#pragma mark - save button state

- (BOOL)saveButtonEnable
{
    return YES;
}

- (void)changeSaveButtonState
{
    BOOL enable = [self saveButtonEnable];
}

#pragma mark - animate edit view

- (void)animateByView:(UIView *)view
{
    CGRect visibleRect = CGRectMake(0, self.navigationBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(_contentScrollView.frame) - 216 - self.navigationBarHeight);
    CGRect viewFrameInSelf = [view.superview convertRect:view.frame toView:self.view];
    
    float delY = CGRectGetMidY(viewFrameInSelf) - CGRectGetMidY(visibleRect);
    if (delY > 0) {
        NSLog(@"移动 %f",delY);
        CGPoint point = _contentScrollView.contentOffset;
        point.y += delY;
        
        CGFloat maxY = _contentScrollView.contentSize.height - _contentScrollView.frameHeight;
        if (point.y > maxY) {
            point.y = maxY;
        }
        [_contentScrollView setContentOffset:point animated:YES];
    }
}

- (void)beginEdit
{
    
}

- (void)endEdit
{
    [self.view endEditing:YES];
}

#pragma mark - Private Action

- (void)confirmAction
{
    NSString *prePass = _prePassField.text;
    NSString *newPass = _newPassField.text;
    NSString *newPass1 = _newPassField1.text;
    
    NSString *msg = nil;
    if (prePass.length == 0) {
        msg = @"请输入原密码";
    }
    else if (newPass.length == 0) {
        msg = @"请输入新密码";
    }
    else if (newPass1.length == 0) {
        msg = @"请再输入新密码";
    }
    else if (![newPass isEqualToString:newPass1]) {
        msg = @"两次输入的密码不一致";
    }
    
    if (msg) {
        [TipHandler showTipOnlyTextWithNsstring:msg];
        return;
    }
    
    [self.view endEditing:YES];
    [self showProgressView];
    
    __weak typeof(self) weakSelf = self;
    
    [[CUUserManager sharedInstance] updateUser:[CUUserManager sharedInstance].user oldPassword:prePass newPassword:newPass resultBlock:^(SNHTTPRequestOperation * request,SNServerAPIResultData * result) {
        [weakSelf hideProgressView];
        
        if (!result.hasError)
        {
            [TipHandler showHUDText:@"修改成功" inView:weakSelf.contentView];
            
            [weakSelf performSelector:@selector(backAction) withObject:nil afterDelay:0.7];
        }
        else {
            [TipHandler showHUDText:@"修改失败" inView:weakSelf.contentView];
        }
    } pageName:@"updateUserPassword"];
}

@end