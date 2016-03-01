//
//  UserCenterController.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/19.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "UserCenterController.h"
#import "ConsultationListController.h"
#import "TipHandler+HUD.h"
#import "MyDoctorListView.h"
#import "CUDoctorManager.h"
#import "UserCenterHeaderView.h"
#import "UserCenterFooterView.h"
#import "CULoginViewController.h"
#import "CUOrderListContainerController.h"
#import "UserDetailController.h"
#import "UIBarButtonItem+CommenButton.h"
#import "CUUserManager.h"

@interface UserCenterController ()

@property (nonatomic, strong) CULoginViewController *loginVC;

@property (nonatomic, strong) UserCenterHeaderView *header;

@property (nonatomic, strong) NSMutableArray *doctorArray;

@property (nonatomic, strong) MyDoctorListView *doctorListView;

@end

@implementation UserCenterController

- (id)initWithPageName:(NSString *)pageName
{
    self = [super initWithPageName:pageName];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的空间";
    
    [self initHeader];
    [self initMyDoctorListView];
    [self initFooter];
    
    [[CUUserManager sharedInstance].user addObserver:self forKeyPath:@"token" options:NSKeyValueObservingOptionNew context:NULL];
    //[self initMemberListView];
    //[self initAddressListView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"token"]) {
        if ([[CUUserManager sharedInstance] isLogin]) {
            [self.loginVC.view removeFromSuperview];
            [self.loginVC removeFromParentViewController];
            self.loginVC = nil;
            
            
            self.title = @"我的空间";
            [self loadNavigationBar];
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

- (void)viewWillAppear:(BOOL)animated
{
    _loginVC.slideNavigationController = self.slideNavigationController;

    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self reloadView];
}

- (BOOL)hasTab
{
    return YES;
}

- (void)loadNavigationBar
{
    if ([[CUUserManager sharedInstance] isLogin]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem rightItemWithTitle:@"设置" target:self action:@selector(enterUserDetail)];
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem leftItemWithTitle:@"退出账户" target:self action:@selector(quitUserDetail)];
    }
}


- (void)initHeader
{
    self.header = [[UserCenterHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frameWidth, [UserCenterHeaderView defaultHeight])];
    [self.contentView addSubview:self.header];
}

- (void)initMyDoctorListView
{
    self.doctorArray = [NSMutableArray array];
    [self.doctorArray addObjectsFromArray:[[CUDoctorManager sharedInstance] fakeDoctorList]];
    
    self.doctorListView = [[MyDoctorListView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.header.frame), self.contentView.frameWidth, [MyDoctorListView defaultHeight])];
    [self.contentView addSubview:self.doctorListView];
    
    [self.doctorListView reloadData:self.doctorArray];
    
    __weak typeof(self) weakSelf = self;
    
    self.doctorListView.clickBlock = ^{
        
    };
}

- (void)initFooter
{
    UserCenterFooterView *footer = [[UserCenterFooterView alloc] initWithFrame:CGRectMake(0, self.contentView.frameHeight - [UserCenterFooterView defaultHeight], self.contentView.frameWidth, [UserCenterFooterView defaultHeight])];
    [self.contentView addSubview:footer];
    
    __weak typeof(self) weakSelf = self;
    footer.clickAction = ^(NSInteger index) {
        [weakSelf didClickFooter:index];
    };
}

- (void)reloadView
{
    if ([[CUUserManager sharedInstance] isLogin]) {
        CUUser *user = [[CUUser alloc] init];
        
        user.nickName = @"我叫MT";
        user.userId = 123;
        user.name = @"测试";
        user.profile = @"http://cdn.duitang.com/uploads/item/201504/21/20150421H4327_3eRXN.thumb.224_0.jpeg";
        user.accountNum = @"13001963945";
        
        self.header.user = user;
    }
    else {
        [self loginAction];
        self.header.user = nil;
    }
}

- (void)didLingin {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Action

- (void)loginAction
{
    if (!self.loginVC) {
        self.loginVC = [[CULoginViewController alloc] init];
    }
    self.loginVC.hasNavigationBar = NO;
    self.loginVC.verifyCode = YES;
    self.loginVC.intervalY = kTabBarHeight + kNavigationHeight;
    self.loginVC.slideNavigationController = self.slideNavigationController;
    self.loginVC.view.userInteractionEnabled = YES;

    
    self.title = @"汉方就医登录";
    
    [self addChildViewController:self.loginVC];
    [self.contentView addSubview:self.loginVC.view];
    
//    [self.slideNavigationController pushViewController:loginVC animated:NO];
}

- (void)didClickFooter:(NSInteger)index
{
    if (![[CUUserManager sharedInstance] isLogin]) {
        [self loginAction];
        return;
    }
    
    switch (index) {
        case 0:
            [self enterFavList];
            break;
        case 1:
            [self enterRecordList];
            break;
        case 2:
            [self enterConsultList];
            break;
        case 3:
            [self enterMyAccount];
            break;
            
        default:
            break;
    }
}

- (void)enterFavList
{
    
}

- (void)enterRecordList
{
    CUOrderListContainerController *orderListVC = [[CUOrderListContainerController alloc] initWithHeight:kTopTabBarHeight];
    [self.slideNavigationController pushViewController:orderListVC animated:YES];
}

- (void)enterConsultList
{
    ConsultationListController *consultationLC = [[ConsultationListController alloc] init];
    [self.slideNavigationController pushViewController:consultationLC animated:YES];
}

- (void)enterMyAccount
{
    
}

- (void)enterUserDetail
{
    CUUser *user = [[CUUser alloc] init];
    
    user.nickName = @"我叫MT";
    user.userId = 123;
    user.name = @"测试";
    user.profile = @"http://cdn.duitang.com/uploads/item/201504/21/20150421H4327_3eRXN.thumb.224_0.jpeg";
    user.accountNum = @"13001963945";
    
    UserDetailController *detailVC = [[UserDetailController alloc] initWithPageName:@"UserDetailController"];
    detailVC.user = user;
    [self.slideNavigationController pushViewController:detailVC animated:YES];
}

- (void)quitUserDetail
{
    [[CUUserManager sharedInstance] clear];
    [self loginAction];
}

@end

