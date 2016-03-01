//
//  LoginViewController.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/1/4.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginTextFeildView.h"

#import "CUUserManager.h"
#import "MBProgressHUD.h"
#import "TipHandler+HUD.h"

#define kCodeButtonWith         80

@interface LoginViewController (){
    UIButton *_codeButton;
    UILabel *_codeLabel;
    
    LoginTextFeildView *userTextFeildView;
    LoginTextFeildView *passwordTextFeildView;
    NSString *codetoken;
    int timerCount;
}

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    self.title = @"登陆";
    [super viewDidLoad];
    [self loadContentScrollView];
    [self loadContens];
    
    // Do any additional setup after loading the view.
}

- (void)loadContentScrollView{
    _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [self.view frameWidth], [self.view frameHeight])];
    [self.view addSubview:_contentScrollView];
    
    self.contentView.frame = _contentScrollView.frame;
    self.contentView.layer.contents = (id)[UIImage imageNamed:@"login_bg"].CGImage;
    [_contentScrollView addSubview:self.contentView];
}

- (void)loadContens{
    int intervalY = 30;
    int textFeildWidth = 280 , textFeildHeight = 30;
    
    UIImage *logoImage = [UIImage imageNamed:@"login_header_image"];
    UIView *logoImageView = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth - logoImage.size.width)/2, 1.2*intervalY , logoImage.size.width, logoImage.size.height)];
    logoImageView.layer.contents = (id)logoImage.CGImage;
    [self.contentView addSubview:logoImageView];
    
    userTextFeildView = [[LoginTextFeildView alloc]initWithFrame:CGRectMake((kScreenWidth - textFeildWidth)/2, CGRectGetMaxY(logoImageView.frame) + intervalY, textFeildWidth, textFeildHeight) image:[UIImage imageNamed:@"login_icon_phone"]];
    userTextFeildView.contentTextFeild.placeholder = @"请输入手机号";
    [self.contentView addSubview:userTextFeildView];
    
    _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _codeButton.frame = CGRectMake(CGRectGetMaxX(userTextFeildView.frame) - kCodeButtonWith, CGRectGetMinY(userTextFeildView.frame), kCodeButtonWith, CGRectGetHeight(userTextFeildView.frame));
    [_codeButton setBackgroundImage:[UIImage imageNamed:@"login_code_bg"] forState:UIControlStateNormal];
    [_codeButton setBackgroundImage:[UIImage imageNamed:@"login_code_bg"] forState:UIControlStateDisabled];
    _codeButton.adjustsImageWhenHighlighted = NO;
    [_codeButton addTarget:self action:@selector(codeLableAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentScrollView addSubview:_codeButton];
    
    _codeLabel = [[UILabel alloc] initWithFrame:_codeButton.frame];
    _codeLabel.backgroundColor = [UIColor clearColor];
    _codeLabel.font = [UIFont systemFontOfSize:12];
    _codeLabel.textAlignment = NSTextAlignmentCenter;
    _codeLabel.textColor = [UIColor whiteColor];
    _codeLabel.text = @"获取验证码";
    [_contentScrollView addSubview:_codeLabel];
   
    passwordTextFeildView = [[LoginTextFeildView alloc]initWithFrame:CGRectMake((kScreenWidth - textFeildWidth)/2, CGRectGetMaxY(userTextFeildView.frame) + intervalY, textFeildWidth, textFeildHeight) image:[UIImage imageNamed:@"login_icon_code"]];
    passwordTextFeildView.contentTextFeild.placeholder = @"请输入验证码";
    [self.contentView addSubview:passwordTextFeildView];
    
    UIButton *loginButton = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth - textFeildWidth)/2, CGRectGetMaxY(passwordTextFeildView.frame) + intervalY, textFeildWidth, 42)];
    loginButton.layer.backgroundColor = [UIColor clearColor].CGColor;
    loginButton.layer.cornerRadius = 21.f;
    loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    loginButton.layer.borderWidth = 1.f;
    [loginButton setTitle:@"登           陆" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:loginButton];
}

- (void)codeLableAction
{
    [self endEdit];
    if ([userTextFeildView.contentTextFeild.text isEmpty])
    {
        [TipHandler showTipOnlyTextWithNsstring:@"请输入手机号"];
        return;
    }
    else{
        if (userTextFeildView.contentTextFeild.text.length != 11) {
            [TipHandler showTipOnlyTextWithNsstring:@"请输入正确的手机号"];
            return;
        }
        else{
            [self showHUD];
            
            [self startTimer];
            //    _codeField.text = @"";
            
            [[CUUserManager sharedInstance] requireVerifyCodeWithCellPhone:userTextFeildView.contentTextFeild.text resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result)
             {
                 [self hideHUD];
                 
                 if (!result.hasError) {
                     NSInteger errCode = [[result.responseObject valueForKey:@"errCode"] integerValue];
                     if(errCode == 0){
                         codetoken = [[result.responseObject valueForKey:@"data"] valueForKey:@"token"];
                     }
                     else{
                         [TipHandler showHUDText:[result.responseObject valueForKey:@"data"] inView:self.view];
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
    //    _codeField.text = @"";
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
        _hud.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)/2);
        [self.view addSubview:_hud];
        [self.view bringSubviewToFront:_hud];
    }
    
    [_hud show:YES];
}

- (void)hideHUD
{
    [_hud hide:NO];
}
- (void)loginButtonAction{
    if ([passwordTextFeildView.contentTextFeild.text isEmpty]) {
        [TipHandler showTipOnlyTextWithNsstring:@"请输入验证码"];
        return;
    }
    else {
        [self showHUD];
        [[CUUserManager sharedInstance] loginWithCellPhone:userTextFeildView.contentTextFeild.text code:passwordTextFeildView.contentTextFeild.text codetoken:codetoken resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
            [self hideHUD];
            if (!result.hasError) {
                
            }
        } pageName:@"LoginViewController"];
    }
}

- (void)endEdit{
    [userTextFeildView.contentTextFeild resignFirstResponder];
    [passwordTextFeildView.contentTextFeild resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
