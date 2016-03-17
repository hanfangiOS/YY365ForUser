//
//  DoctorDetailController.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "DoctorDetailController.h"
#import "DoctorHeaderView.h"
#import "OrderCreateController.h"
#import "DoctorPraiseController.h"
#import "CUUserManager.h"
#import "CULoginViewController.h"
#import "DoctorAppointmentListView.h"
#import "CUDoctorManager.h"
#import "TipHandler+HUD.h"
#import "DoctorApoointmentForHourScrollView.h"

#import "TitleView.h"

#import "DoctorSelectOrderTimeController.h"

#import "DoctorFameListController.h"

#define commitViewHeight 50
@interface DoctorDetailController ()

@end

@implementation DoctorDetailController
{
    DoctorHeaderView *headerView;
    
    UIScrollView  *contentScrollView;
    UIView        *footerView;
    
    UIView      *blackView;
    UIDatePicker *dayTimePickerView;
    DoctorAppointmentListView *listView;
    
    DoctorApoointmentForHourScrollView *doctorApoointmentForHourScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPanValid = NO;
    self.title = [NSString stringWithFormat:@"%@ 医生", self.doctor.name];
    
    [self initSubviews];
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

- (void)initSubviews
{
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [[self contentView] frameWidth], [self.contentView frameHeight] - commitViewHeight)];
    [self.contentView addSubview:contentScrollView];
    
    [self loadCommitView];
 
    __weak typeof(self) weakSelf = self;

    headerView = [[DoctorHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), [DoctorHeaderView defaultHeight])];
    NSDateFormatter* formatter = [NSDateFormatter dateFormatterWithFormat:[NSDateFormatter dateFormatString]];
    headerView.dateLable.text = [formatter stringFromDate:[NSDate date]];
    headerView.data = self.doctor;
    headerView.commentBlock = ^{
        DoctorFameListModel * listModel = [[DoctorFameListModel alloc] init];
        listModel.filter.doctorID = weakSelf.doctor.doctorId;
        DoctorFameListController * vc = [[DoctorFameListController alloc] initWithPageName:@"DoctorFameListController" listModel:listModel];
        vc.doctor = weakSelf.doctor;
        [weakSelf.slideNavigationController pushViewController:vc animated:YES];
    };
    [contentScrollView addSubview:headerView];
    
    doctorApoointmentForHourScrollView = [[DoctorApoointmentForHourScrollView alloc] init];
    
    if (_doctor.appointmentList.count) {
        doctorApoointmentForHourScrollView = [[DoctorApoointmentForHourScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame), kScreenWidth ,165) data:_doctor];
    }
    else{
        doctorApoointmentForHourScrollView = [[DoctorApoointmentForHourScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame), kScreenWidth ,80)];
        TitleView *yueZhenTitle = [[TitleView alloc]initWithFrame:CGRectMake(0, 15 , kScreenWidth, 30) title:@"约诊"];
        [doctorApoointmentForHourScrollView addSubview:yueZhenTitle];
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, yueZhenTitle.frameHeight, doctorApoointmentForHourScrollView.frameWidth, doctorApoointmentForHourScrollView.frameHeight);
        label.text = @"暂无可用约诊";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromHex(Color_Hex_Text_gray);
        label.font = [UIFont systemFontOfSize:14];
        [doctorApoointmentForHourScrollView addSubview:label];
    }
    [contentScrollView addSubview:doctorApoointmentForHourScrollView];

    TitleView *introTitle = [[TitleView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(doctorApoointmentForHourScrollView.frame) + 15 , kScreenWidth, 30) title:@"介绍"];
    [contentScrollView addSubview:introTitle];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(introTitle.frame),kScreenWidth - 30, 0)];
    descLabel.numberOfLines = 0;
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.textColor = UIColorFromHex(Color_Hex_Text_Normal);
    [contentScrollView addSubview:descLabel];
    
    descLabel.text = self.doctor.detailIntro;
    [descLabel sizeToFit];

    if (CGRectGetMaxY(descLabel.frame) > contentScrollView.contentSize.height) {
        contentScrollView.contentSize = CGSizeMake(contentScrollView.contentSize.width, CGRectGetMaxY(descLabel.frame));
    }
}

- (void)loadCommitView{
    UIView *commitView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(contentScrollView.frame), kScreenWidth, commitViewHeight)];
    commitView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:commitView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    lineView.layer.backgroundColor = UIColorFromHex(0xc4c4c4).CGColor;
    [commitView addSubview:lineView];
    
    int commitButtonHeight = 35;
    UIButton *commitButton = [[UIButton alloc]initWithFrame:CGRectMake(15, (commitViewHeight - commitButtonHeight)/2, kScreenWidth - 30, commitButtonHeight)];
    commitButton.layer.backgroundColor = UIColorFromHex(Color_Hex_Text_Readed).CGColor;
    commitButton.layer.cornerRadius = commitButtonHeight/2.f;
    [commitButton setTitle:@"约      诊" forState:UIControlStateNormal];
    if (_doctor.appointmentList.count) {
        [commitButton addTarget:self action:@selector(commitButtonAction) forControlEvents:UIControlEventTouchUpInside];
        commitButton.layer.backgroundColor = UIColorFromHex(Color_Hex_NavBackground).CGColor;
    }

    [commitView addSubview:commitButton];
}

- (void)commitButtonAction{
    if (!_doctor.appointmentList.count) {
        return;
    }
    DoctorAppointmentListItem *appointmentSelected = [_doctor.appointmentList objectAtIndex:doctorApoointmentForHourScrollView.pageControl.currentPage];
    __weak __block DoctorDetailController *blockSelf = self;
    [[CUDoctorManager sharedInstance] getOrderTimeSegmentWithReleaseID:appointmentSelected.releaseID resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError) {
            NSInteger errorCode = [[result.responseObject valueForKey:@"errorCode"] integerValue];
            switch (errorCode) {
                case 0:
                {
                    DoctorSelectOrderTimeController *doctorSelectOrderTimeController = [[DoctorSelectOrderTimeController alloc]initWithPageName:@"DoctorDetailController"];
                    appointmentSelected.selectOrderTimeArray = result.parsedModelObject;
                    doctorSelectOrderTimeController.doctorAppointmentListItem = appointmentSelected;
                    blockSelf.doctor.address = [NSString stringWithFormat:@"%@(%@)",appointmentSelected.clinicName,appointmentSelected.clinicAddr];
                    doctorSelectOrderTimeController.doctor = blockSelf.doctor;
                    [blockSelf.slideNavigationController pushViewController:doctorSelectOrderTimeController animated:YES];
                }
                    break;
                default:
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[result.responseObject valueForKey:@"data"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }
                    break;
            }

        }
    } pageName:@"DoctorDetailController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createOrderActionWithData:(Doctor *)data
{
//    if (![[CUUserManager sharedInstance] isLogin]) {
//        [self loginAction];
//        return;
//    }
    
    OrderCreateController *createVC = [[OrderCreateController alloc] init];
    createVC.doctor = data;
    [self.slideNavigationController pushViewController:createVC animated:YES];
}

- (NSString *)dateFromatterWithDate:(NSDate *)date{
    NSDateFormatter* formatter = [NSDateFormatter dateFormatterWithFormat:[NSDateFormatter dateFormatString]];
    return [formatter stringFromDate:date];
}

//
//- (void)showPraiseAction
//{
//    DoctorPraiseController *doctorpraiseVC = [[DoctorPraiseController alloc] init];
//    doctorpraiseVC.doctor = self.doctor;
//    [self.slideNavigationController pushViewController:doctorpraiseVC animated:YES];
//}
//
- (void)loginAction
{
    CULoginViewController *loginVC = [[CULoginViewController alloc] init];
    [self.slideNavigationController pushViewController:loginVC animated:YES];
}

@end
