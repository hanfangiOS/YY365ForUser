//
//  ChangePasswordViewController.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/20.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "CUUserManager.h"
#import "SettingTextFeildView.h"

@interface ChangePasswordViewController ()

@property (strong,nonatomic)UIScrollView            * scrollViiew;

@property (strong,nonatomic)UIView                  * beforePwdBackgroundView;
@property (strong,nonatomic)SettingTextFeildView    * beforePwdView;

@property (strong,nonatomic)UIView                  * nowPwdBackgroundView;
@property (strong,nonatomic)SettingTextFeildView    * nowPwdView;
@property (strong,nonatomic)SettingTextFeildView    * confirmPwdView;


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
                    [self.scrollViiew addSubview:self.beforePwdBackgroundView];
                    [self.scrollViiew addSubview:self.nowPwdBackgroundView];
                }
                else{
                    self.nowPwdBackgroundView.frameY = 10;
                    [self.scrollViiew addSubview:self.nowPwdBackgroundView];
                    NSLog(@"不存在旧密码， 直接设置新密码");
                }
            }
        }
    } pageName:@"ChangePasswordViewController"];

}

- (void)loadContentView{
    self.scrollViiew = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    self.scrollViiew.scrollEnabled = YES;
    self.scrollViiew.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:self.scrollViiew];
    
    //第一块view
    self.beforePwdBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 90)];
    self.beforePwdBackgroundView.backgroundColor = [UIColor whiteColor];
    
    //旧密码
    self.beforePwdView = [[SettingTextFeildView alloc] initWithFrame:CGRectMake(22, (90 - [SettingTextFeildView defaultHeight]/2), kScreenWidth - 22 * 2 , [SettingTextFeildView defaultHeight]) Title:@"旧密码"];
    [self.beforePwdBackgroundView addSubview:self.beforePwdView];
    //第二块View
    self.nowPwdBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,self.beforePwdBackgroundView.maxY + 10, kScreenWidth, 150)];
    self.nowPwdBackgroundView.backgroundColor = [UIColor whiteColor];
    
    //新密码
    self.nowPwdView = [[SettingTextFeildView alloc] initWithFrame:CGRectMake(22, 25, kScreenWidth - 22 * 2 , [SettingTextFeildView defaultHeight]) Title:@"新密码"];
    [self.nowPwdBackgroundView addSubview:self.nowPwdView];
    //确认密码
    self.confirmPwdView = [[SettingTextFeildView alloc] initWithFrame:CGRectMake(22,self.nowPwdView.maxY + 25, kScreenWidth - 22 * 2 , [SettingTextFeildView defaultHeight]) Title:@"确认密码"];
    [self.nowPwdBackgroundView addSubview:self.confirmPwdView];
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
