//
//  CURegisterController.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/30.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CURegisterController.h"
#import "CUUserManager.h"
#import "CUEmailViewController.h"
#import "CUPasswordViewController.h"
#import "TipHandler+HUD.h"

@interface CURegisterController ()

@end

@implementation CURegisterController

- (id)init
{
    self = [super init];
    
    if (self) {
        self.hasPassword = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)confirmButtonAction
{
    [self endEditing];
    [self showProgressView];
    
    __weak typeof(self) blockSelf = self;
    SNServerAPIResultBlock handler = ^(SNHTTPRequestOperation *request, SNServerAPIResultData *result)
    {
//        [blockSelf hideProgressView];
        
        if (!result.hasError)
        {
//            NSLog(@"err_code=%ld", [(NSNumber *)[result.responseObject valueForKey:@"err_code"] integerValue]);
            if (![(NSNumber *)[result.responseObject valueForKey:@"err_code"] integerValue]) {
                
                [[CUUserManager sharedInstance] updateUser:[CUUserManager sharedInstance].user password:[[[blockSelf.loginView password] MD5] uppercaseString] resultBlock:^(SNHTTPRequestOperation *request1, SNServerAPIResultData *result1) {
                    
                    [blockSelf hideProgressView];
                    if (!result1.hasError) {
                        if (![(NSNumber *)[result1.responseObject valueForKey:@"err_code"] integerValue]) {
                            [TipHandler showHUDText:@"注册成功" inView:blockSelf.contentView];
                            [blockSelf resetEmailAction];
                        }
                        else {
                            [TipHandler showHUDText:[result1.responseObject valueForKey:@"data"] inView:blockSelf.contentView];
                        }
                    }
                    else {
                        [TipHandler showHUDText:[result1.error.userInfo valueForKey:NSLocalizedDescriptionKey] inView:blockSelf.contentView];
                    }
                }pageName:@"CURegisterViewController"];
                
//                //调用userInfo
//                [[CUUserManager sharedInstance] getUserInfo:[CUUserManager sharedInstance].user.token resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
//                    
//                    [blockSelf hideProgressView];
//                    
//                    [TipHandler showHUDText:@"注册成功" inView:blockSelf.contentView];
//                    
//                    [blockSelf resetEmailAction];
//                }];
            }
            else if (12 == [(NSNumber *)[result.responseObject valueForKey:@"err_code"] integerValue]) {
                //手机号已注册，未设置密码
                CUPasswordViewController *passVC = [[CUPasswordViewController alloc] init];
                passVC.hasVerify = NO;
                passVC.hasOldPassword = NO;
                [self.slideNavigationController pushViewController:passVC animated:YES];
            }
            else if (13 == [(NSNumber *)[result.responseObject valueForKey:@"err_code"] integerValue]) {
                //手机号已注册，已设置密码，未设置邮箱
                [self resetEmailAction];
            }
            else {
                [blockSelf hideProgressView];
                [TipHandler showHUDText:[result.responseObject valueForKey:@"data"] inView:blockSelf.contentView];
            }
        }
        else
        {
            [blockSelf hideProgressView];
            [TipHandler showHUDText:[result.error.userInfo valueForKey:NSLocalizedDescriptionKey] inView:blockSelf.contentView];
        }
    };
    
    // TODO:注册接口
    if (self.verifyCode) {
        [[CUUserManager sharedInstance] registerWithCellPhone:[self.loginView userName] verifyCode:[self.loginView code] resultBlock:handler pageName:@"CURegisterViewController"];
    }
    else {
        
    }
}

- (void)resetEmailAction
{
    CUEmailViewController *emailVC = [[CUEmailViewController alloc] init];
    [self.slideNavigationController pushViewController:emailVC animated:YES];
}

@end
