//
//  UserViewController.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/1/4.
//  Copyright © 2016年 li na. All rights reserved.
//


#import "UIImage+Color.h"

#import "AppDelegate.h"
#import "CUUserManager.h"
#import "CUOrder.h"

#import "UserViewController.h"
#import "UserHeaderView.h"

#import "LoginViewController.h"
#import "MyDoctorListModel.h"
#import "MyDoctorListViewController.h"
#import "MyClinicListViewController.h"
#import "MyClinicListModel.h"
#import "MyAccountMainViewController.h"
#import "MyCommentViewController.h"
#import "MyCommentListModel.h"
#import "NewsListModel.h"
#import "NewsListController.h"
#import "MyInfoViewController.h"
#import "MyMemberViewController.h"
#import "MyMemberListModel.h"
#import "MyAppointmentController.h"
#import "MyAppointmentListModel.h"
#import "MyTreatmentController.h"
#import "MyTreatmentListModel.h"

@interface UserViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UserHeaderView    * headerView;
@property (nonatomic, strong) UITableView       * tableView;

@end

@implementation UserViewController

- (void)loadNavigationBar{
    [self addRightButtonItemWithImage:[UIImage imageNamed:@"myDoctorBigButtonImage"] action:@selector(messageAction)];
    
}

- (void)messageAction{
    NewsListModel * listMiodel = [[NewsListModel alloc] init];
    NewsListController * VC = [[NewsListController alloc] initWithPageName:@"NewsListController" listModel:listMiodel];
    [self.slideNavigationController pushViewController:VC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.headerView resetUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的空间";
    [self setNavigationBarBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.01]]];
    [self.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor clearColor]]];
    
    [self initSubView];
}

- (void)initSubView{
    self.contentView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kDefaultToolbarHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    [self.contentView addSubview:self.tableView];
    
    self.headerView = [[UserHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 223)];
    self.headerView.layer.contents = [UIImage imageNamed:@""];
    self.headerView.backgroundColor = [UIColor blueColor];
    
    self.tableView.tableHeaderView = self.headerView;
    
    [self.headerView.myDoctorBtn addTarget:self action:@selector(myDoctorAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headerView.myClinicBtn addTarget:self action:@selector(myClinicAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headerView.myCommentBtn addTarget:self action:@selector(myCommentAction) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoBackgroundAction)];
    [self.headerView.userInfoBackgroundView addGestureRecognizer:tap];
}

#pragma mark - tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 3;
        }
            break;
        default:{
            return 1;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 52;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"defaultCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                cell.imageView.image = [UIImage imageNamed:@"myDoctorBigButtonImage"];
                cell.textLabel.text = @"我的约诊";
            }
                break;
            case 1:{
                cell.imageView.image = [UIImage imageNamed:@"myDoctorBigButtonImage"];
                cell.textLabel.text = @"就诊记录";
            }
                break;
            case 2:{
                cell.imageView.image = [UIImage imageNamed:@"myDoctorBigButtonImage"];
                cell.textLabel.text = @"消费记录";
            }
                break;
            default:
                break;
        }
    }
    if (indexPath.section == 1) {
        cell.imageView.image = [UIImage imageNamed:@"myDoctorBigButtonImage"];
        cell.textLabel.text = @"我的成员";
    }
    if (indexPath.section == 2) {
        cell.imageView.image = [UIImage imageNamed:@"myDoctorBigButtonImage"];
        cell.textLabel.text = @"设置";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                OrderFilter * filter = [[OrderFilter alloc] init];
                filter.user = [CUUserManager sharedInstance].user;
                filter.orderStatus = ORDERSTATUS_UNPAID;
                filter.pageNum = 0;
                MyAppointmentListModel * listModel = [[MyAppointmentListModel alloc] initWithFilter:filter];
                MyAppointmentController * VC = [[MyAppointmentController alloc] initWithPageName:@"MyAppointmentController" listModel:listModel];
                [self.slideNavigationController pushViewController:VC animated:YES];
            }
                break;
            case 1:{
                OrderFilter * filter = [[OrderFilter alloc] init];
                filter.user = [CUUserManager sharedInstance].user;
                filter.orderStatus = ORDERSTATUS_FINISHED;
                filter.pageNum = 0;
                
                MyTreatmentListModel * listModel = [[MyTreatmentListModel alloc]initWithFilter:filter];
                MyTreatmentController * VC = [[MyTreatmentController alloc]initWithPageName:@"MyTreatmentController" listModel:listModel];
                [self.slideNavigationController  pushViewController:VC animated:YES];
            }
                break;
            case 2:{
                MyAccountMainViewController * myAccountVC = [[MyAccountMainViewController alloc]initWithPageName:@"MyAccountMainViewController"];
                [self.slideNavigationController pushViewController:myAccountVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    
    if (indexPath.section == 1) {
        MyMemberListModel * listModel = [[MyMemberListModel alloc] init];
        
        MyMemberViewController * VC = [[MyMemberViewController alloc] initWithPageName:@"MyMemberViewController" listModel:listModel];
        
        [self.slideNavigationController pushViewController:VC animated:YES];
    }
    
    if (indexPath.section == 2) {
        ;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offSetY = scrollView.contentOffset.y;

    if (offSetY < 4) {
        [UIView animateWithDuration:0.3 animations:^{
            [self setNavigationBarBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.01]]];
            [self.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor clearColor]]];
        }];
    }
    
    if (offSetY > 4 && offSetY < self.headerView.frameHeight - 85) {
        [UIView animateWithDuration:0.3 animations:^{
            [self setNavigationBarBackgroundImage:[UIImage createImageWithColor:[UIColor darkGrayColor]]];
            [self.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor clearColor]]];
        }];
    }
    
    if (offSetY > self.headerView.frameHeight - 85) {
        [UIView animateWithDuration:0.3 animations:^{
            [self setNavigationBarBackgroundImage:[UIImage createImageWithColor:UIColorFromHex(Color_Hex_NavBackground)]];
            [self.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor clearColor]]];
        }];
    }
}

#pragma mark Action

- (void)myDoctorAction{
    MyDoctorListModel *listModel = [[MyDoctorListModel alloc]initWithSortType:1];
    MyDoctorListViewController *myDoctorVC = [[MyDoctorListViewController alloc]initWithPageName:@"UserViewController" listModel:listModel];
    [self.slideNavigationController  pushViewController:myDoctorVC animated:YES];
}

- (void)myClinicAction{
    MyClinicListModel * listModel = [[MyClinicListModel alloc]initWithSortType:1];
    MyClinicListViewController * myClinicVC = [[MyClinicListViewController alloc]initWithPageName:@"UserViewController" listModel:listModel];
    [self.slideNavigationController  pushViewController:myClinicVC animated:YES];
}

- (void)myCommentAction{
    MyCommentListModel * listModel = [[MyCommentListModel alloc] init];
    listModel.filter.lastID = 0;
    MyCommentViewController * VC = [[MyCommentViewController alloc]initWithPageName:@"UserViewController" listModel:listModel];
    [self.slideNavigationController  pushViewController:VC animated:YES];
}

- (void)userInfoBackgroundAction{
    if([CUUserManager sharedInstance].isLogin == YES){
        MyInfoViewController * VC = [[MyInfoViewController alloc] init];
        [self.slideNavigationController pushViewController:VC animated:YES];
    }else{
        LoginViewController * VC = [[LoginViewController alloc] initWithPageName:@"LoginViewController"];
        [[UIApplication sharedApplication] delegate].window.rootViewController = VC;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
