//
//  ChangePasswordViewController.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/20.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "CUUserManager.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showProgressView];
    __weak __block ChangePasswordViewController *blockSelf = self;
    [[CUUserManager sharedInstance] checkIfHasOldPasswordWithResultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        [blockSelf hideProgressView];
        if (!result.hasError)
        {
            if (!result.hasError && ![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]){
                NSInteger isExistNum = [[result.responseObject dictionaryForKeySafely:@"data"] integerForKeySafely:@"isExist"];
                if (isExistNum) {
                    NSLog(@"存在旧密码， 启用旧密码+新密码形式改密码");
                }
                else{
                    NSLog(@"不存在旧密码， 直接设置新密码");
                }
            }
        }
    } pageName:@"ChangePasswordViewController"];

}

- (void)loadContentView{
    
}

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
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
