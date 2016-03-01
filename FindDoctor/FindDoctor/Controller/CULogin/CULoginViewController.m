//
//  LoginViewController.m
//  iCar
//
//  Created by yutao on 14-9-14.
//  Copyright (c) 2014年 yutao. All rights reserved.
//

#import "CULoginViewController.h"
#import "CUWebController.h"
#import "CUServerAPIConstant.h"
#import "CUUIContant.h"
#import "CUUserManager.h"
#import "CULoginView.h"
#import "MBProgressHUD.h"
#import "TipHandler+HUD.h"
#import "UIImage+Color.h"
#import "UIConstants.h"
#import "CUVerifyCodeController.h"
#import "CURegisterController.h"
#import "CUEmailViewController.h"

#define kButtonLeftMargin_Login      40.0
#define kButtonTopMargin_Login       30.0
#define kButtonHeight_Login          40.0

#define kLoginTextColor     UIColorFromRGB(38, 98, 101)

@interface CULoginViewController ()

@property (nonatomic,strong) UIView *contentView1;
@property (nonatomic,strong) UIButton *loginButton;

@end

@implementation CULoginViewController

SINGLETON_IMPLENTATION(CULoginViewController);

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.pageName = @"CULoginViewController";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.navTitle == nil) {
        self.title = @"汉方就医登录";
    }
    else {
        self.title = self.navTitle;
    }
    
    UITapGestureRecognizer *backTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    [self.contentView1 addGestureRecognizer:backTapGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // 顺序不能换，光标问题
    //[self.loginView.codeField setText:nil];
    //[self.loginView.userField setText:[CUUserManager sharedInstance].user.cellPhone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self endEditing];
}

//- (void)setShouldHaveTab
//{
//    self.hasTab = YES;
//}

- (void)loadNavigationBar
{
    [self.navigationBar performSelector:@selector(useTranslucentBackgroundImage) withObject:nil];

    if(_intervalY == kTabBarHeight+kNavigationHeight){
        return;
    } else{
        [self addLeftBackButtonItemWithImage];
    }

}

- (void)loadHeaderImage
{
    CGFloat headerHeight = 144.0;
    
    CGFloat headerImageHeight = headerHeight;
    headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, headerHeight - headerImageHeight, self.contentView.frameWidth, headerImageHeight)];
    headerImage.image = [UIImage imageNamed:@"login_header_image"];
    headerImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView1 addSubview:headerImage];
}

- (void)loadContentView
{
    CGFloat leftPadding = kButtonLeftMargin_Login;
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.clipsToBounds = YES;

    self.contentView1 = [[UIView alloc] initWithFrame:self.contentView.bounds];
    self.contentView1.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.contentView1];
    
    [self loadHeaderImage];
    
    CGFloat headerHeight = CGRectGetMaxY(headerImage.frame);
    
//    self.loginView = [[CULoginView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), 200)];
    self.loginView = [[CULoginView alloc] initWithFrame:CGRectMake(leftPadding, headerHeight - 20, CGRectGetWidth(self.contentView.bounds) - leftPadding * 2, 0) hasVerify:self.verifyCode hasPassword:self.hasPassword attachedView:self.contentView];
    self.loginView.delegate = (id)self;
    self.loginView.frameHeight = [self.loginView fHeight];
    [self.contentView1 addSubview:self.loginView];
    
    self.loginView.backgroundColor = [UIColor clearColor];
    self.loginView.userField.textColor = [UIColor whiteColor];
    self.loginView.passField.textColor = [UIColor whiteColor];
    self.loginView.codeField.textColor = [UIColor whiteColor];
    
    //
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(kButtonLeftMargin_Login, CGRectGetMaxY(self.loginView.frame) + kButtonTopMargin_Login, self.contentView.frameWidth - kButtonLeftMargin_Login *2, kButtonHeight_Login)];
    [self.loginButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.enabled = NO;
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    self.loginButton.backgroundColor = UIColor_NavbarItem;
    [self.loginButton setBackgroundImage:[UIImage createImageWithColor:kGreenColor] forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.contentView1 addSubview:self.loginButton];
    
    if (self.verifyCode) {
        [_loginButton setTitle:@"确定" forState:UIControlStateNormal];
        
        return;
    }
    
    UIButton *verifyButton = [[UIButton alloc] initWithFrame:CGRectMake(leftPadding, CGRectGetMaxY(_loginButton.frame) + 15, 130, 30)];
    [verifyButton setTitleColor:kLoginTextColor forState:UIControlStateNormal];
    verifyButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [verifyButton setTitle:@"验证手机，立即进入" forState:UIControlStateNormal];
    [verifyButton addTarget:self action:@selector(verifyLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView1 addSubview:verifyButton];
    
    UIButton *fogetButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_loginButton.frame) - 65, CGRectGetMaxY(_loginButton.frame) + 15, 65, 30)];
    [fogetButton setTitleColor:kLoginTextColor forState:UIControlStateNormal];
    fogetButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [fogetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [fogetButton addTarget:self action:@selector(resetPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView1 addSubview:fogetButton];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.loginButton.frame)+ 60, kScreenWidth, 30)];
    [self.contentView1 addSubview:headerView];
    
    UILabel *topLable = [[UILabel alloc] initWithFrame:CGRectMake(kButtonLeftMargin_Login, 5, 0, 0)];
    [topLable setText:@"登录即表示已阅读并同意"];
    [topLable setTextColor:kDarkGrayColor];
    topLable.font = [UIFont systemFontOfSize:12];
    [topLable setTextAlignment:NSTextAlignmentLeft];
    CGSize lablesize = [topLable.text sizeWithAttributes:@{NSFontAttributeName:topLable.font}];
    topLable.frameHeight = lablesize.height;
    topLable.frameWidth = lablesize.width;
    [headerView addSubview:topLable];
    
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(topLable.frame) + 1, 0.5, 50, 26)];
    [right addTarget:self action:@selector(agreementAction) forControlEvents:UIControlEventTouchUpInside];
    [right setTitleColor:kLoginTextColor forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:12];
    [right setTitle:@"隐私协议" forState:UIControlStateNormal];
    [headerView addSubview:right];
    
    UIButton *regButton = [[UIButton alloc] initWithFrame:CGRectMake((self.contentView.frameWidth - 90) / 2, self.contentView.frameHeight - 45- _intervalY, 90, 45)];
    [regButton addTarget:self action:@selector(regButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [regButton setTitleColor:kLoginTextColor forState:UIControlStateNormal];
    regButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [regButton setTitle:@"快速注册" forState:UIControlStateNormal];
    [self.contentView1 addSubview:regButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Action

- (void)endEditing
{
    [self.loginView textFieldResignFirstResponder];
}

- (void)backAction
{
    [self endEditing];
    
    [super backAction];
}

- (void)backToRoot
{
    [self endEditing];
    
    [self.slideNavigationController popToRootViewControllerAnimated:YES];
}

- (void)closeAction
{
    [self endEditing];
    
    [self.slideNavigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)agreementAction
{
    CUWebController *web = [[CUWebController alloc] init];
    web.title = @"隐私协议";
    web.urlString = URL_AfterBase;
    [self.slideNavigationController pushViewController:web animated:YES];
}

- (void)regButtonAction
{
    CURegisterController *regVC = [[CURegisterController alloc] init];
    [self.slideNavigationController pushViewController:regVC animated:YES];
}

- (void)verifyLoginAction
{
    CULoginViewController *loginVC = [[CULoginViewController alloc] init];
    loginVC.verifyCode = YES;
    loginVC.navTitle = @"手机快速登录";
    [self.slideNavigationController pushViewController:loginVC animated:YES];
}

- (void)resetPasswordAction
{
    CUVerifyCodeController *verifyVC = [[CUVerifyCodeController alloc] init];
    [self.slideNavigationController pushViewController:verifyVC animated:YES];
}

- (void)confirmButtonAction
{
    [self endEditing];
    [self showProgressView];
    
    __weak CULoginViewController * blockSelf = self;
    SNServerAPIResultBlock handler = ^(SNHTTPRequestOperation *request, SNServerAPIResultData *result)
    {
        if (!result.hasError)//连接正常
        {
            //服务器内部正常
            if (![(NSNumber *)[result.responseObject valueForKey:@"err_code"] integerValue]) {
                //调用userInfo
                [[CUUserManager sharedInstance] getUserInfo:[CUUserManager sharedInstance].user.token resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
                    
                    [blockSelf hideProgressView];
                    
                    [TipHandler showHUDText:@"登录成功" inView:blockSelf.contentView];
                    
//                    [blockSelf resetEmailAction];
                    
                    //退出当前页面
                    if (blockSelf.verifyCode) {
                        [blockSelf performSelector:@selector(backToRoot) withObject:nil afterDelay:0.5];
                    }
                    else {
                        [blockSelf performSelector:@selector(backAction) withObject:nil afterDelay:0.5];
                    }
                }];
            }
            else {
                [blockSelf hideProgressView];
                
                [TipHandler showHUDText:[result.responseObject valueForKey:@"data"] inView:blockSelf.contentView];
                
                [[CUUserManager sharedInstance] clear];
            }
        }
        else
        {
            [blockSelf hideProgressView];
            [TipHandler showHUDText:[result.error.userInfo valueForKey:NSLocalizedDescriptionKey] inView:blockSelf.contentView];
        }
    };
    
    if (self.verifyCode) {
        [[CUUserManager sharedInstance] loginWithCellPhone:[self.loginView userName] code:[self.loginView code] codetoken:[self.loginView codetoken] resultBlock:handler pageName:@"CULoginViewController"];
    }
    else {
//        NSString *password = [[self.loginView password] MD5];
        NSString *password = [[[self.loginView password] MD5] uppercaseString];
        [[CUUserManager sharedInstance] loginWithCellPhone:[self.loginView userName] password:password resultBlock:handler pageName:@"CULoginViewController"];
    }
}

- (void)loginView:(CULoginView *)loginView editingStateDidChanged:(BOOL)isEditing
{
    if (Is_Phone4 || (Is_Phone5 && self.verifyCode && self.hasPassword)) {
        if (isEditing) {
            if (self.contentView1.frameY == 0) {
                [UIView animateWithDuration:.3 animations:^{
                    self.contentView1.frameY = 0 - 100;
                }];
            }
        }
        else {
            if (self.contentView1.frameY < 0) {
                [UIView animateWithDuration:.3 animations:^{
                    self.contentView1.frameY = 0;
                }];
            }
        }
    }
}

- (void)loginView:(CULoginView *)loginView editingChanged:(BOOL)isChanged
{
//    if ([[self.loginView userName] isValidPhoneNumber]) {
//        [CUUserManager sharedInstance].user.cellPhone = [self.loginView userName];
//        
//        if (self.verifyCode) {
//            self.loginButton.enabled = ([self.loginView codeStr].length > 0) ? YES : NO;
//        }
//        else {
//            self.loginButton.enabled = ([self.loginView password].length >= 6) ? YES : NO;
//        }
//    }
//    else {
//        self.loginButton.enabled = NO;
//    }
    self.loginButton.enabled = YES;
}


- (void)resetEmailAction
{
    CUEmailViewController *emailVC = [[CUEmailViewController alloc] init];
    [self.slideNavigationController pushViewController:emailVC animated:YES];
}

@end
