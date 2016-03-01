//
//  UserViewController.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/1/4.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "UserViewController.h"
#import "UserHeaderView.h"
#import "BigButtonsInUser.h"

#import "AppDelegate.h"
#import "CUUserManager.h"

#import "LoginViewController.h"

#import "MyDiagnosisRecordsListModel.h"
#import "MyDiagnosisRecordsViewController.h"

#import "MyDoctorListModel.h"
#import "MyDoctorListViewController.h"

#import "MyClinicListViewController.h"
#import "MyClinicListModel.h"

@interface UserViewController ()<UIAlertViewDelegate>{
    UserHeaderView *userHeaderView;
}

@property (nonatomic, strong) LoginViewController *loginVC;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[CUUserManager sharedInstance].user addObserver:self forKeyPath:@"token" options:NSKeyValueObservingOptionNew context:NULL];
    [self initSubView];
}

- (void)viewWillAppear:(BOOL)animated
{
    _loginVC.slideNavigationController = self.slideNavigationController;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    if ([[CUUserManager sharedInstance] isLogin]) {
    }
    else{
        [self loginAction];
    }
    [userHeaderView resetUserInfo];
    [super viewDidAppear:animated];
}


- (void)initSubView{
    _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, [self.contentView frameHeight] - 49)];
    _contentScrollView.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
    [self.contentView addSubview:_contentScrollView];
    
    userHeaderView = [[UserHeaderView alloc]initWithFrame:CGRectMake(0, 9, kScreenWidth, 95)];
    [_contentScrollView addSubview:userHeaderView];
    
    BigButtonsInUser *myDoctorButton = [[BigButtonsInUser alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(userHeaderView.frame) + 23, kScreenWidth/2 - 0.5, kScreenWidth/2 - 0.5)  image:[UIImage imageNamed:@"myDoctorBigButtonImage"] title:@"我的医生"];
    [myDoctorButton addTarget:self action:@selector(myDoctorAction) forControlEvents:UIControlEventTouchUpInside  ];
    
    BigButtonsInUser *myCollectionButton = [[BigButtonsInUser alloc]initWithFrame:CGRectMake(kScreenWidth/2+0.5, CGRectGetMaxY(userHeaderView.frame) + 23, kScreenWidth/2 - 0.5, kScreenWidth /2- 0.5)  image:[UIImage imageNamed:@"myCollectionBigButtonImage"] title:@"我的诊所"];
    [myCollectionButton addTarget:self action:@selector(myCollectionAction) forControlEvents:UIControlEventTouchUpInside  ];
    
    BigButtonsInUser *zhenLiaoButton = [[BigButtonsInUser alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(myDoctorButton.frame) + 1, kScreenWidth/2 - 0.5, kScreenWidth/2 - 0.5)  image:[UIImage imageNamed:@"myRecordBigButtonImage"] title:@"就诊记录"];
    [zhenLiaoButton addTarget:self action:@selector(zhenLiaoRecordAction) forControlEvents:UIControlEventTouchUpInside  ];
    
    BigButtonsInUser *myAccoutButton = [[BigButtonsInUser alloc]initWithFrame:CGRectMake(kScreenWidth/2+0.5, CGRectGetMaxY(myDoctorButton.frame) + 1, kScreenWidth/2 - 0.5, kScreenWidth/2 - 0.5)  image:[UIImage imageNamed:@"myAccountBigButtonImage"] title:@"我的账户"];
    [myAccoutButton addTarget:self action:@selector(myAccountAction) forControlEvents:UIControlEventTouchUpInside  ];
    
    [_contentScrollView addSubview:myDoctorButton];
    [_contentScrollView addSubview:myCollectionButton];
    [_contentScrollView addSubview:zhenLiaoButton];
    [_contentScrollView addSubview:myAccoutButton];
    
    
    
    UIButton *resignButton = [[UIButton alloc]initWithFrame:CGRectMake(26, CGRectGetMaxY(myAccoutButton.frame)+24, kScreenWidth-52, 40)];
    resignButton.layer.cornerRadius = 20;
    resignButton.clipsToBounds = YES;
    resignButton.layer.backgroundColor = UIColorFromHex(0xe15f31).CGColor;
    [resignButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [resignButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resignButton addTarget:self action:@selector(resignAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentScrollView addSubview:resignButton];
    [_contentScrollView setContentSize:CGSizeMake(kScreenWidth,CGRectGetMaxY(resignButton.frame) + 15)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"token"]) {
        if ([[CUUserManager sharedInstance] isLogin]) {
            [self.loginVC.view removeFromSuperview];
            [self.loginVC removeFromParentViewController];
            self.loginVC = nil;
            self.hasNavigationBar = YES;
            self.title = @"我的空间";
//            [self loadNavigationBar];
            [userHeaderView resetUserInfo];
        }
        else {
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
}

- (void)dealloc {
    [[CUUserManager sharedInstance].user removeObserver:self forKeyPath:@"token"];
}

- (void)myDoctorAction{
    MyDoctorListModel *listModel = [[MyDoctorListModel alloc]initWithSortType:1];
    MyDoctorListViewController *myDoctorVC = [[MyDoctorListViewController alloc]initWithPageName:@"UserViewController" listModel:listModel];
    [self.slideNavigationController  pushViewController:myDoctorVC animated:YES];
}

- (void)myCollectionAction{
    MyClinicListModel *listModel = [[MyClinicListModel alloc]initWithSortType:1];
    MyClinicListViewController *myClinicVC = [[MyClinicListViewController alloc]initWithPageName:@"UserViewController" listModel:listModel];
    [self.slideNavigationController  pushViewController:myClinicVC animated:YES];
}

- (void)zhenLiaoRecordAction{
    MyDiagnosisRecordsListModel *listModel = [[MyDiagnosisRecordsListModel alloc]initWithSortType:1];
    MyDiagnosisRecordsViewController *myDiagnosisRecordsVC = [[MyDiagnosisRecordsViewController alloc]initWithPageName:@"UserViewController" listModel:listModel];
    [self.slideNavigationController  pushViewController:myDiagnosisRecordsVC animated:YES];
}

- (void)myAccountAction{

    
}

- (void)loginAction
{
    if (!self.loginVC) {
        self.loginVC = [[LoginViewController alloc] init];
    }
    self.loginVC.hasNavigationBar = NO;
//    self.loginVC.verifyCode = YES;
//    self.loginVC.intervalY = kTabBarHeight + kNavigationHeight;
    self.loginVC.slideNavigationController = self.slideNavigationController;
    self.loginVC.view.userInteractionEnabled = YES;
    
    self.hasNavigationBar = NO;
    self.title = @"汉方就医登录";
    
    [self addChildViewController:self.loginVC];
    [self.view addSubview:self.loginVC.view];
    
    //    [self.slideNavigationController pushViewController:loginVC animated:NO];
}

- (void)resignAction{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确认退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = 1;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1){
        if (buttonIndex == 0) {
            return;
        }
        if (buttonIndex == 1) {
            [[CUUserManager sharedInstance] clear];
            [self loginAction];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
