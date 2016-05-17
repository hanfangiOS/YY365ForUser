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
#import "SettingViewController.h"

#import "CUOrder.h"
#import "MyTreatmentController.h"
#import "MyTreatmentListModel.h"

@interface UserViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIView *_navViewBG;
}

@property (nonatomic, strong) UserHeaderView    * headerView;
@property (nonatomic, strong) UITableView       * tableView;

@end

@implementation UserViewController

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
    
    self.navigationBar.hidden = YES;
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kDefaultNavigationBarHeight)];
    [self.view addSubview:navView];
    _navViewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kDefaultNavigationBarHeight)];
    _navViewBG.backgroundColor = UIColorFromHex(Color_Hex_NavBackground);
    _navViewBG.alpha = 0;
    [navView addSubview:_navViewBG];
    UIButton *btn = [self addRightButtonItemWithImage:[UIImage imageNamed:@"mySpace_msg"] action:@selector(messageAction)];
    btn.frame = CGRectMake(kScreenWidth - btn.frameWidth - 12, _navViewBG.frameHeight - btn.frameHeight, btn.frameWidth, btn.frameHeight);
    [navView addSubview:btn];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, _navViewBG.frameHeight - btn.frameHeight + 2, kScreenWidth, 40)];
    label.text = @"我的空间";
    label.textColor = UIColorFromHex(0xffffff);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    [navView addSubview:label];
    
    [self initSubView];
}

- (void)initSubView{
    self.contentView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.contentView.backgroundColor = kCommonBackgroundColor;
    self.view.backgroundColor = kCommonBackgroundColor;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kDefaultToolbarHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = kCommonBackgroundColor;
    self.tableView.separatorColor = kblueLineColor;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.contentView addSubview:self.tableView];
    
    self.headerView = [[UserHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 224)];
    
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                cell.imageView.image = [UIImage imageNamed:@"mySpace_icon_myAppointment@2x"];
                cell.textLabel.text = @"我的约诊";
            }
                break;
            case 1:{
                cell.imageView.image = [UIImage imageNamed:@"mySpace_icon_myTreatment@2x"];
                cell.textLabel.text = @"就诊记录";
            }
                break;
            case 2:{
                cell.imageView.image = [UIImage imageNamed:@"mySpace_icon_myAccount@2x"];
                cell.textLabel.text = @"消费记录";
            }
                break;
            default:
                break;
        }
    }
    if (indexPath.section == 1) {
        cell.imageView.image = [UIImage imageNamed:@"mySpace_icon_myMember@2x"];
        cell.textLabel.text = @"我的成员";
    }
    if (indexPath.section == 2) {
        cell.imageView.image = [UIImage imageNamed:@"mySpace_icon_setting@2x"];
        cell.textLabel.text = @"设置";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //我的约诊 ～消费记录
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            //我的约诊
            case 0:{
                
                if([CUUserManager sharedInstance].user.token != nil && ![[CUUserManager sharedInstance].user.token isEqualToString:@""]){
                    //已登录
                    OrderFilter * filter = [[OrderFilter alloc] init];
                    filter.user = [CUUserManager sharedInstance].user;
                    filter.orderStatus = ORDERSTATUS_UNPAID;
                    filter.total = 0;
                    filter.rows = 20;
                    MyAppointmentListModel * listModel = [[MyAppointmentListModel alloc] initWithFilter:filter];
                    MyAppointmentController * VC = [[MyAppointmentController alloc] initWithPageName:@"MyAppointmentController" listModel:listModel];
                    [self.slideNavigationController pushViewController:VC animated:YES];
                }else{
                    //未登录
                    LoginViewController * VC = [[LoginViewController alloc] initWithPageName:@"LoginViewController"];
                    [VC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                    [self.slideNavigationController presentViewController:VC animated:YES completion:nil];
                }
            }
                break;
            //就诊记录
            case 1:{
                
                if([CUUserManager sharedInstance].user.token != nil && ![[CUUserManager sharedInstance].user.token isEqualToString:@""]){
                    //已登录
                    OrderFilter * filter = [[OrderFilter alloc] init];
                    filter.user = [CUUserManager sharedInstance].user;
                    filter.orderStatus = ORDERSTATUS_FINISHED;
                    filter.total = 0;
                    filter.rows = 20;
                    MyTreatmentListModel * listModel = [[MyTreatmentListModel alloc]initWithFilter:filter];
                    MyTreatmentController * VC = [[MyTreatmentController alloc]initWithPageName:@"MyTreatmentController" listModel:listModel];
                    [self.slideNavigationController  pushViewController:VC animated:YES];
                }else{
                    //未登录
                    LoginViewController * VC = [[LoginViewController alloc] initWithPageName:@"LoginViewController"];
                    [VC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                    [self.slideNavigationController presentViewController:VC animated:YES completion:nil];
                }
            }
                break;
            //消费记录
            case 2:{
                
                
                if([CUUserManager sharedInstance].user.token != nil && ![[CUUserManager sharedInstance].user.token isEqualToString:@""]){
                    //已登录
                    MyAccountMainViewController * myAccountVC = [[MyAccountMainViewController alloc]initWithPageName:@"MyAccountMainViewController"];
                    [self.slideNavigationController pushViewController:myAccountVC animated:YES];
                }else{
                    //未登录
                    LoginViewController * VC = [[LoginViewController alloc] initWithPageName:@"LoginViewController"];
                    [VC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                    [self.slideNavigationController presentViewController:VC animated:YES completion:nil];
                }
                

            }
                break;
                
            default:
                break;
        }
    }
    //我的成员
    if (indexPath.section == 1) {
        
        if([CUUserManager sharedInstance].user.token != nil && ![[CUUserManager sharedInstance].user.token isEqualToString:@""]){
            //已登录
            UserFilter * filter = [[UserFilter alloc] init];
            filter.listType = @"all";
            
            MyMemberListModel * listModel = [[MyMemberListModel alloc] initWithFilter:filter];
            
            MyMemberViewController * VC = [[MyMemberViewController alloc] initWithPageName:@"MyMemberViewController" listModel:listModel];
            
            [self.slideNavigationController pushViewController:VC animated:YES];
        }else{
            //未登录
            LoginViewController * VC = [[LoginViewController alloc] initWithPageName:@"LoginViewController"];
            [VC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [self.slideNavigationController presentViewController:VC animated:YES completion:nil];
        }
        

    }
    //设置
    if (indexPath.section == 2) {
    
        SettingViewController *VC = [[SettingViewController alloc]initWithPageName:@"SettingViewController"];
        [self.slideNavigationController pushViewController:VC  animated:YES];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==2) {
        return 20;
    }
    return 0;
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offSetY = scrollView.contentOffset.y;

    if (offSetY < 45) {
        _navViewBG.alpha = offSetY/45.f;
    }
    else{
        _navViewBG.alpha = 1;
    }
    
}

#pragma mark Action
//我的医生
- (void)myDoctorAction{
    if([CUUserManager sharedInstance].user.token != nil && ![[CUUserManager sharedInstance].user.token isEqualToString:@""]){
        MyDoctorListModel *listModel = [[MyDoctorListModel alloc]initWithSortType:1];
        MyDoctorListViewController *myDoctorVC = [[MyDoctorListViewController alloc]initWithPageName:@"MyDoctorListViewController" listModel:listModel];
        [self.slideNavigationController  pushViewController:myDoctorVC animated:YES];
    }else{
        LoginViewController * VC = [[LoginViewController alloc] initWithPageName:@"LoginViewController"];
        [VC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self.slideNavigationController presentViewController:VC animated:YES completion:nil];
    }

}
//我的诊所
- (void)myClinicAction{
    
    if([CUUserManager sharedInstance].user.token != nil && ![[CUUserManager sharedInstance].user.token isEqualToString:@""]){
        MyClinicListModel * listModel = [[MyClinicListModel alloc]initWithSortType:1];
        MyClinicListViewController * myClinicVC = [[MyClinicListViewController alloc]initWithPageName:@"MyClinicListViewController" listModel:listModel];
        [self.slideNavigationController  pushViewController:myClinicVC animated:YES];
    }else{
        LoginViewController * VC = [[LoginViewController alloc] initWithPageName:@"LoginViewController"];
        [VC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self.slideNavigationController presentViewController:VC animated:YES completion:nil];
    }
}
//我的评价
- (void)myCommentAction{
    if([CUUserManager sharedInstance].user.token != nil && ![[CUUserManager sharedInstance].user.token isEqualToString:@""]){
        MyCommentListModel * listModel = [[MyCommentListModel alloc] init];
        listModel.filter.lastID = 0;
        MyCommentViewController * VC = [[MyCommentViewController alloc]initWithPageName:@"MyCommentViewController" listModel:listModel];
        [self.slideNavigationController  pushViewController:VC animated:YES];
    }else{
        LoginViewController * VC = [[LoginViewController alloc] initWithPageName:@"LoginViewController"];
        [VC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self.slideNavigationController presentViewController:VC animated:YES completion:nil];
    }
}

- (void)userInfoBackgroundAction{
    if([CUUserManager sharedInstance].isLogin){
        MyInfoViewController * VC = [[MyInfoViewController alloc] initWithPageName:@"MyInfoViewController"];
        [self.slideNavigationController pushViewController:VC animated:YES];
    }else{
        LoginViewController * VC = [[LoginViewController alloc] initWithPageName:@"LoginViewController"];
        [VC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self.slideNavigationController presentViewController:VC animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
