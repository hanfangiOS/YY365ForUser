//
//  CUVerifyCodeController.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/30.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUVerifyCodeController.h"
#import "CUUserManager.h"
#import "TipHandler+HUD.h"
#import "CUPasswordViewController.h"

@interface CUVerifyCodeController ()

@end

@implementation CUVerifyCodeController

- (id)init
{
    self = [super init];
    
    if (self) {
        self.verifyCode = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"忘记密码";
}

//- (void)loadHeaderImage
//{
//    CGFloat headerHeight = 105.0;
//    CGFloat headerImageHeight = 67.0;
//    
//    headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, headerHeight - headerImageHeight, self.contentView.frameWidth, headerImageHeight)];
//    headerImage.image = [UIImage imageNamed:@"login_header_circle_green"];
//    headerImage.contentMode = UIViewContentModeScaleAspectFit;
//    [self.contentView addSubview:headerImage];
//}

- (void)confirmButtonAction
{
    [self endEditing];
    [self showProgressView];
    
    __weak typeof(self) blockSelf = self;
    SNServerAPIResultBlock handler = ^(SNHTTPRequestOperation *request, SNServerAPIResultData *result)
    {
        [blockSelf hideProgressView];
        
        if (!result.hasError)
        {
            if (![(NSNumber *)[result.responseObject valueForKey:@"err_code"] integerValue]) {
                
                [blockSelf resetPasswordAction];
            }
            else {
                [TipHandler showHUDText:[result.responseObject valueForKey:@"data"] inView:blockSelf.contentView];
            }
        }
        else
        {
            [TipHandler showHUDText:[result.error.userInfo valueForKey:NSLocalizedDescriptionKey] inView:blockSelf.contentView];
        }
    };
    
    // TODO:手机登陆 + 用户名登录
    if (self.verifyCode) {
//        [[CUUserManager sharedInstance] loginWithCellPhone:[self.loginView userName] verifyCode:[self.loginView code] resultBlock:handler pageName:@"CUVerifyCodeController"];
    }
    else {
        
    }
}

- (void)resetPasswordAction
{
    CUPasswordViewController *passVC = [[CUPasswordViewController alloc] init];
    passVC.hasOldPassword = YES;
    passVC.hasVerify = YES;
    [self.slideNavigationController pushViewController:passVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginAction
{
    
}

@end
