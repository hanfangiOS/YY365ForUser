//
//  CUPasswordViewController.m
//  FindDoctor
//
//  Created by Tom Zhang on 15/11/21.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CUPasswordViewController.h"
#import "CUPasswordView.h"
#import "CUWebController.h"
#import "CUServerAPIConstant.h"
#import "CUUIContant.h"
#import "CUUserManager.h"
#import "MBProgressHUD.h"
#import "TipHandler+HUD.h"
#import "UIImage+Color.h"
#import "UIConstants.h"
#import "CUEmailViewController.h"

#define kButtonLeftMargin_Password      40.0
#define kButtonTopMargin_Password       30.0
#define kButtonHeight_Password          40.0

#define kPasswordTextColor     UIColorFromRGB(38, 98, 101)

@interface CUPasswordViewController ()

@property (nonatomic,strong) UIView *contentView1;
@property (nonatomic,strong) UIButton *confirmButton;

@end

@implementation CUPasswordViewController

SINGLETON_IMPLENTATION(CUPasswordViewController);

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.pageName = @"CUPasswordViewController";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.navTitle == nil) {
        self.title = @"设置密码";
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self endEditing];
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

- (void)loadContentView
{
    CGFloat leftPadding = kButtonLeftMargin_Password;
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.clipsToBounds = YES;
    
    self.contentView1 = [[UIView alloc] initWithFrame:self.contentView.bounds];
    self.contentView1.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.contentView1];
    
//    [self loadHeaderImage];
    
//    CGFloat headerHeight = CGRectGetMaxY(headerImage.frame);
    CGFloat headerHeight = 144.0;
    
    self.passwordView = [[CUPasswordView alloc] initWithFrame:CGRectMake(leftPadding, headerHeight - 20, CGRectGetWidth(self.contentView.bounds) - leftPadding * 2, 0) hasOldPassword:self.hasOldPassword hasVerify:self.hasVerify attachedView:self.contentView];
    self.passwordView.delegate = (id)self;
    self.passwordView.frameHeight = [self.passwordView fHeight];
    [self.contentView1 addSubview:self.passwordView];
    
    self.passwordView.backgroundColor = [UIColor clearColor];
    self.passwordView.oldPassField.textColor = [UIColor whiteColor];
    self.passwordView.newPassField.textColor = [UIColor whiteColor];
    self.passwordView.codeField.textColor = [UIColor whiteColor];
    
    //
    self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(kButtonLeftMargin_Password, CGRectGetMaxY(self.passwordView.frame) + kButtonTopMargin_Password, self.contentView.frameWidth - kButtonLeftMargin_Password *2, kButtonHeight_Password)];
    [self.confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.confirmButton setBackgroundImage:[UIImage createImageWithColor:kGreenColor] forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.contentView1 addSubview:self.confirmButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Action

- (void)endEditing
{
    [self.passwordView textFieldResignFirstResponder];
}

- (void)backAction
{
    [self endEditing];
    
    [super backAction];
}

//- (void)backToRoot
//{
//    [self endEditing];
//    
//    [self.slideNavigationController popToRootViewControllerAnimated:YES];
//}

- (void)closeAction
{
    [self endEditing];
    
    [self.slideNavigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmButtonAction
{
    [self endEditing];
    [self showProgressView];
    
    __block __weak CUPasswordViewController * blockSelf = self;
    SNServerAPIResultBlock handler = ^(SNHTTPRequestOperation *request, SNServerAPIResultData *result)
    {
        [blockSelf hideProgressView];
        
        if (!result.hasError)//连接正常
        {
            //服务器内部正常
            if (![(NSNumber *)[result.responseObject valueForKey:@"err_code"] integerValue]) {
                [TipHandler showHUDText:@"密码设置成功" inView:blockSelf.contentView];
                [blockSelf resetEmailAction];
            }
            else {
                [TipHandler showHUDText:[result.responseObject valueForKey:@"data"] inView:blockSelf.contentView];
//                [[CUUserManager sharedInstance] clear];
            }
        }
        else {
            [TipHandler showHUDText:[result.error.userInfo valueForKey:NSLocalizedDescriptionKey] inView:blockSelf.contentView];
        }
    };
    
    if (self.hasOldPassword) {
        [[CUUserManager sharedInstance] updateUser:[CUUserManager sharedInstance].user oldPassword:[[[self.passwordView oldPassword] MD5] uppercaseString] newPassword:[[[self.passwordView newPassword] MD5] uppercaseString]resultBlock:handler pageName:@"CUPasswordViewController"];
    }
    else if (self.hasVerify){
        [[CUUserManager sharedInstance] updateUser:[CUUserManager sharedInstance].user password:[[[self.passwordView newPassword] MD5] uppercaseString] verifyCode:[self.passwordView codeStr] resultBlock:handler pageName:@"CUPasswordViewController"];
    }
    else {
        [[CUUserManager sharedInstance] updateUser:[CUUserManager sharedInstance].user password:[[[self.passwordView newPassword] MD5] uppercaseString] resultBlock:handler pageName:@"CUPasswordViewController"];
    }

}

- (void)passwordView:(CUPasswordView *)PasswordView editingStateDidChanged:(BOOL)isEditing
{
    if (Is_Phone4 || (Is_Phone5 && self.hasVerify && self.hasOldPassword)) {
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

- (void)resetEmailAction
{
    CUEmailViewController *emailVC = [[CUEmailViewController alloc] init];
    [self.slideNavigationController pushViewController:emailVC animated:YES];
}
@end
