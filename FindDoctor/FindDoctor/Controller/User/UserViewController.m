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

#import "MyAccountMainViewController.h"

#import "MyCommentViewController.h"
#import "MyCommentListModel.h"

@interface UserViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    UserHeaderView *userHeaderView;
    UITableView * _contentTableView;
    NSArray *contentTableViewCellIcon;
    NSArray *contentTableViewCellText;
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
    [self initData];
    
    _contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.contentView.frame.size.height-49) style:UITableViewStylePlain];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    _contentTableView.separatorInset = UIEdgeInsetsMake(0, -80, 0, 0);
    _contentTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _contentTableView.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
    [self.contentView  addSubview:_contentTableView];
}

- (void)initData{
    contentTableViewCellIcon = @[@"button_myDoctor",@"button_myClinic.png",@"button_myRecord.png",@"button_myAccount.png",@"button_myComment.png",@"button_myScore.png"];
    contentTableViewCellText = @[@"我的医生",@"我的诊所",@"我的订单",@"我的账户",@"我的点评",@"退出登录"];
}


#pragma mark - TableView代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return contentTableViewCellText.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 116;
    }
    if(indexPath.row == contentTableViewCellText.count){
        return 63+24;
    }
    return 63;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
        
        UserHeaderView *userHeaderView = [[UserHeaderView alloc]initWithFrame:CGRectMake(0, 9, kScreenWidth, 95)];
        [cell addSubview:userHeaderView];
        
        return cell;
    }
    
    if(indexPath.row == contentTableViewCellText.count){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
        
        UIButton *resignButton = [[UIButton alloc]initWithFrame:CGRectMake(26, 24, kScreenWidth-52, 40)];
        resignButton.layer.cornerRadius = 20;
        resignButton.clipsToBounds = YES;
        resignButton.layer.backgroundColor = UIColorFromHex(0xe15f31).CGColor;
        [resignButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
        [resignButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [resignButton addTarget:self action:@selector(resignAction) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:resignButton];
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.imageView.image = [UIImage imageNamed:[contentTableViewCellIcon objectAtIndex:(indexPath.row -1)]];
    cell.textLabel.text = [contentTableViewCellText objectAtIndex:(indexPath.row - 1)];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, 62.5, kScreenWidth-20, 0.5)];
    lineView.backgroundColor = UIColorFromHex(0xcccccc);
    [cell.contentView addSubview:lineView];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
            //我的医生
        case 1:{
            MyDoctorListModel *listModel = [[MyDoctorListModel alloc]initWithSortType:1];
            MyDoctorListViewController *myDoctorVC = [[MyDoctorListViewController alloc]initWithPageName:@"UserViewController" listModel:listModel];
            [self.slideNavigationController  pushViewController:myDoctorVC animated:YES];
            break;
        }
            //我的诊所
        case 2:{
            MyClinicListModel *listModel = [[MyClinicListModel alloc]initWithSortType:1];
            MyClinicListViewController *myClinicVC = [[MyClinicListViewController alloc]initWithPageName:@"UserViewController" listModel:listModel];
            [self.slideNavigationController  pushViewController:myClinicVC animated:YES];
            break;
        }
            //就诊记录
        case 3:{
            MyDiagnosisRecordsListModel *listModel = [[MyDiagnosisRecordsListModel alloc]initWithSortType:1];
            MyDiagnosisRecordsViewController *myDiagnosisRecordsVC = [[MyDiagnosisRecordsViewController alloc]initWithPageName:@"UserViewController" listModel:listModel];
            [self.slideNavigationController  pushViewController:myDiagnosisRecordsVC animated:YES];
            break;
        }
            //我的账户
        case 4:{
            MyAccountMainViewController   *myAccountVC = [[MyAccountMainViewController alloc]initWithPageName:@"MyAccountMainViewController"];
            [self.slideNavigationController pushViewController:myAccountVC animated:YES];
            break;
        }
            //我的点评
        case 5 :
        {
            MyCommentListModel * listModel = [[MyCommentListModel alloc] init];
            listModel.filter.lastID = 0;
            MyCommentViewController * VC = [[MyCommentViewController alloc]initWithPageName:@"UserViewController" listModel:listModel];
            [self.slideNavigationController  pushViewController:VC animated:YES];
            break;
        }
            //我的积分
        case 6:{
            break;
        }
        default:{
            NSLog(@"参数错误");

            break;
        }
    }
    
    
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
