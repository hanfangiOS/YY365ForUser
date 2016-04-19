//
//  AppointmentDetailsController.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/18.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "AppointmentDetailsController.h"
#import "DetailsHeaderView.h"
#import "DetailsAppointInfoView.h"
#import "DetailsPaymentInfoView.h"
#import "DetailsOrderInfoView.h"

@interface AppointmentDetailsController ()<UIAlertViewDelegate>

@property (strong,nonatomic)UIScrollView            * scrollView;
@property (strong,nonatomic)DetailsHeaderView       * headerView;
@property (strong,nonatomic)DetailsAppointInfoView  * appointInfoView;
@property (strong,nonatomic)DetailsPaymentInfoView  * paymentInfoView;
@property (strong,nonatomic)DetailsOrderInfoView    * orderInfoView;

@property (strong,nonatomic)UIButton                * payBtn;
@property (strong,nonatomic)UIButton                * cancelBtn;

@end

@implementation AppointmentDetailsController

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"约诊详情";
    
    [self initsubViews];
}

- (void)initsubViews{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    self.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.scrollView.scrollEnabled = YES;
    [self.contentView addSubview: self.scrollView];
    
    
    self.headerView = [[DetailsHeaderView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, [DetailsHeaderView defaultHeight])];
    [self.scrollView addSubview:self.headerView];
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    self.appointInfoView = [[DetailsAppointInfoView alloc] initWithFrame:CGRectMake(0, self.headerView.maxY + 10, kScreenWidth, [DetailsAppointInfoView defaultHeight])];
    [self.scrollView addSubview:self.appointInfoView];
    self.appointInfoView.backgroundColor = [UIColor whiteColor];
    
    self.paymentInfoView = [[DetailsPaymentInfoView alloc] initWithFrame:CGRectMake(0, self.appointInfoView.maxY + 10, kScreenWidth, [DetailsPaymentInfoView defaultHeight])];
    [self.scrollView addSubview:self.paymentInfoView];
    self.paymentInfoView.backgroundColor = [UIColor whiteColor];
    
    self.orderInfoView = [[DetailsOrderInfoView alloc] initWithFrame:CGRectMake(0, self.paymentInfoView.maxY + 10, kScreenWidth, [DetailsOrderInfoView defaultHeight])];
    [self.scrollView addSubview:self.orderInfoView];
    self.orderInfoView.backgroundColor = [UIColor whiteColor];
    
    self.payBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, self.orderInfoView.maxY + 18, kScreenWidth - 25 * 2, 40)];
    self.payBtn.backgroundColor = [UIColor orangeColor];
    [self.payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [self.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.payBtn.layer.cornerRadius = 5.0f;
    [self.payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.payBtn];
    
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, self.payBtn.maxY + 10, kScreenWidth - 25 * 2, 40)];
    self.cancelBtn.backgroundColor = [UIColor orangeColor];
    [self.cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cancelBtn.layer.cornerRadius = 5.0f;
    [self.cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.cancelBtn];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.cancelBtn.maxY + 20);
    
}

- (void)resetData{
    
}

- (void)payAction{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"确认付款吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = 10000;
    alert.delegate = self;
    [alert show];
}

- (void)cancelAction{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"确认要取消订单吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = 20000;
    alert.delegate = self;
    [alert show];
}

#pragma mark UIAlertDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 10000) {
//        [self postRequest1];
    }
    
    if (alertView.tag == 20000) {
        if (buttonIndex == 1) {
//            [self postRequest2];
            [self.slideNavigationController popViewControllerAnimated:YES];
        }
    }
    
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
