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
#import "AppDelegate.h"
#import "UserViewController.h"

#define codeLoginTag 10
#define passwordLoginTag 20

#define kCodeButtonWith         80

@interface LoginViewController (){
    UIButton *_codeButton;
    UILabel *_codeLabel;
    
    LoginTextFeildView *userTextFeildView;
    LoginTextFeildView *passwordTextFeildView;
    NSString *codetoken;
    int timerCount;
    UIButton * _loginStyleBtn;
}

@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation LoginViewController
- (instancetype)initWithPageName:(NSString *)pageName{
    self = [super initWithPageName:pageName];
    if (self) {
        self.hasNavigationBar = NO;
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    self.title = @"登陆";
    [super viewDidLoad];
    [self loadContentScrollView];
    [self loadContens];
    
    // Do any additional setup after loading the view.
}

- (void)loadContentScrollView{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kDefaultNavigationBarHeight)];
    navView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    [self.contentView addSubview:navView];
    
    UIButton * cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
    cancelBtn.contentMode = UIViewContentModeScaleAspectFit;
    [cancelBtn addTarget:self action:@selector(cancelLogin) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:cancelBtn];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((cancelBtn.frameWidth - 20)/2,(cancelBtn.frameHeight - 20)/2 , 20, 20)];
    imageView.image = [UIImage imageNamed:@"login_icon_close"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cancelBtn addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, navView.frameHeight - 42 , kScreenWidth, 40)];
    label.text = @"登陆";
    label.textColor = UIColorFromHex(0xffffff);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    [navView addSubview:label];

    self.contentView.frame = CGRectMake(0, 0, [self.view frameWidth], [self.view frameHeight]);
    self.contentView.layer.contents = (id)[UIImage imageNamed:@"login_bg"].CGImage;
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)endEdit{
    [self.contentView endEditing:YES];
}

- (void)loadContens{
    int intervalY = 30;
    int textFeildWidth = 280 , textFeildHeight = 30;
    
    UIImage *logoImage = [UIImage imageNamed:@"login_header_image"];
    UIView *logoImageView = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth - logoImage.size.width)/2,kDefaultNavigationBarHeight+ 1.2*intervalY , logoImage.size.width, logoImage.size.height)];
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
    [self.contentView addSubview:_codeButton];
    
    _codeLabel = [[UILabel alloc] initWithFrame:_codeButton.frame];
    _codeLabel.backgroundColor = [UIColor clearColor];
    _codeLabel.font = [UIFont systemFontOfSize:12];
    _codeLabel.textAlignment = NSTextAlignmentCenter;
    _codeLabel.textColor = [UIColor whiteColor];
    _codeLabel.text = @"获取验证码";
    [self.contentView addSubview:_codeLabel];
    
    passwordTextFeildView = [[LoginTextFeildView alloc]initWithFrame:CGRectMake((kScreenWidth - textFeildWidth)/2, CGRectGetMaxY(userTextFeildView.frame) + intervalY, textFeildWidth, textFeildHeight) image:[UIImage imageNamed:@"login_icon_code"]];
    passwordTextFeildView.contentTextFeild.placeholder = @"请输入验证码";
    passwordTextFeildView.contentTextFeild.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:passwordTextFeildView];
    
    UIButton *loginButton = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth - textFeildWidth)/2, CGRectGetMaxY(passwordTextFeildView.frame) + intervalY, textFeildWidth, 42)];
    loginButton.layer.backgroundColor = [UIColor clearColor].CGColor;
    loginButton.layer.cornerRadius = 21.f;
    loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    loginButton.layer.borderWidth = 1.f;
    [loginButton setTitle:@"登           陆" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:loginButton];
    
    _loginStyleBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - ((kScreenWidth - textFeildWidth)/2 + 80 - 10), loginButton.maxY + 24, 80, 20)];
    [_loginStyleBtn setTitle:@"密码登陆" forState:UIControlStateNormal];
    _loginStyleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_loginStyleBtn addTarget:self action:@selector(switchLoginStyleAction) forControlEvents:UIControlEventTouchUpInside];
    _loginStyleBtn.tag = passwordLoginTag;
    _loginStyleBtn.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_loginStyleBtn];

    
}

- (void)cancelLogin{
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma Action

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
                     NSInteger errCode = [[result.responseObject valueForKey:@"errorCode"] integerValue];
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
    if (_loginStyleBtn.tag == passwordLoginTag) {
        if ([passwordTextFeildView.contentTextFeild.text isEmpty]) {
            [TipHandler showTipOnlyTextWithNsstring:@"请输入验证码"];
            return;
        }
        else {
            [self requestWithCode];
            
        }
    }else if (_loginStyleBtn.tag == codeLoginTag){
        if ([passwordTextFeildView.contentTextFeild.text isEmpty]) {
            [TipHandler showTipOnlyTextWithNsstring:@"请输入密码"];
            return;
        }
        else {
            [self requestWithPassword];
            
        }
    }

}

//切换登陆方式
- (void)switchLoginStyleAction{
    if (_loginStyleBtn.tag == codeLoginTag) {
        //切换为验证码登陆
        _codeButton.hidden = NO;
        _codeLabel.hidden = NO;
        passwordTextFeildView.contentTextFeild.text = nil;
        passwordTextFeildView.contentTextFeild.placeholder = @"请输入验证码";
        passwordTextFeildView.contentTextFeild.secureTextEntry = NO;
        passwordTextFeildView.contentTextFeild.keyboardType = UIKeyboardTypeNumberPad;
        [_loginStyleBtn setTitle:@"密码登陆" forState:UIControlStateNormal];
        _loginStyleBtn.tag = passwordLoginTag;
        
    }else{
        //切换为密码登陆
        _codeButton.hidden = YES;
        _codeLabel.hidden = YES;
        passwordTextFeildView.contentTextFeild.placeholder = @"请输入密码";
        passwordTextFeildView.contentTextFeild.text = nil;
        passwordTextFeildView.contentTextFeild.secureTextEntry = YES;
        passwordTextFeildView.contentTextFeild.keyboardType = UIKeyboardTypeDefault;
        [_loginStyleBtn setTitle:@"验证码登陆" forState:UIControlStateNormal];
        _loginStyleBtn.tag = codeLoginTag;

    }
    
}

#pragma request

//验证码登陆
- (void)requestWithCode{
    [self showHUD];
    __weak __block typeof(self)weakSelf = self;
    [[CUUserManager sharedInstance] loginWithCellPhone:userTextFeildView.contentTextFeild.text code:passwordTextFeildView.contentTextFeild.text codetoken:codetoken resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        [weakSelf hideHUD];
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject objectForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
            
        }
        
    } pageName:@"LoginViewController"];
}

//密码登陆
- (void)requestWithPassword{
    [self showHUD];
    __weak __block typeof(self)weakSelf = self;
    
    [[CUUserManager sharedInstance] loginWithCellPhone:userTextFeildView.contentTextFeild.text password:passwordTextFeildView.contentTextFeild.text resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        [weakSelf hideHUD];
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject objectForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
            
        }
    } pageName:@"LoginViewController"];

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
