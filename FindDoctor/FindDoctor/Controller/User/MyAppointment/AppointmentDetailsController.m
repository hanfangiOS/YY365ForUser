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
#import "CUOrderManager.h"
#import "OrderConfirmController.h"
#import "TipHandler+HUD.h"

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self resetData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.from isEqualToString:@"支付"]) {
        
        for (CUViewController * vc in self.slideNavigationController.viewControllers) {
            if ([vc isKindOfClass:[OrderConfirmController class]]) {
                [vc.slideNavigationController popToRootViewControllerAnimated:YES];
            }
        }
    }
}

- (void)initsubViews{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    self.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.scrollView.scrollEnabled = YES;
    [self.contentView addSubview: self.scrollView];
    
    //headerView
    self.headerView = [[DetailsHeaderView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, [DetailsHeaderView defaultHeight])];
    self.headerView.data = self.order.service.doctor;
    [self.scrollView addSubview:self.headerView];
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    //约诊信息
    self.appointInfoView = [[DetailsAppointInfoView alloc] initWithFrame:CGRectMake(0, self.headerView.maxY + 10, kScreenWidth, [DetailsAppointInfoView defaultHeight])];
    self.appointInfoView.data = self.order;
    [self.scrollView addSubview:self.appointInfoView];
    self.appointInfoView.backgroundColor = [UIColor whiteColor];
    //支付信息
    self.paymentInfoView = [[DetailsPaymentInfoView alloc] initWithFrame:CGRectMake(0, self.appointInfoView.maxY + 10, kScreenWidth, [DetailsPaymentInfoView defaultHeight])];
    self.paymentInfoView.data = self.order;
    [self.scrollView addSubview:self.paymentInfoView];
    self.paymentInfoView.backgroundColor = [UIColor whiteColor];
    //订单信息
    self.orderInfoView = [[DetailsOrderInfoView alloc] initWithFrame:CGRectMake(0, self.paymentInfoView.maxY + 10, kScreenWidth, [DetailsOrderInfoView defaultHeight])];
    self.orderInfoView.data = self.order;
    [self.scrollView addSubview:self.orderInfoView];
    self.orderInfoView.backgroundColor = [UIColor whiteColor];
    
    //取消订单
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.orderInfoView.maxY + 10, kScreenWidth/3, 40)];
    self.cancelBtn.backgroundColor = kBlueTextColor;
    [self.cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.cancelBtn];

    
    //支付按钮
    self.payBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.cancelBtn.maxX, self.cancelBtn.frameY, (kScreenWidth * 2)/3, 40)];
    self.payBtn.backgroundColor = UIColorFromHex(0x5793e9);
    [self.payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [self.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.payBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.payBtn];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.cancelBtn.maxY);
    
}

- (void)resetData{
    switch (self.order.orderStatus) {
        case ORDERSTATUS_UNPAID:
        {
            
        }
            break;
        case ORDERSTATUS_PAID:
        {
            self.cancelBtn.frameWidth = kScreenWidth;
            self.payBtn.hidden = YES;
            [self.scrollView setNeedsLayout];
        }
            break;
        case ORDERSTATUS_FINISHED:
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark Action

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
        if (buttonIndex == 1) {
            OrderConfirmController * vc = [[OrderConfirmController alloc] initWithPageName:@"OrderConfirmController"];
            vc.order = self.order;
            [self.slideNavigationController pushViewController:vc animated:YES];
        }
    }
    
    if (alertView.tag == 20000) {
        if (buttonIndex == 1) {
            [self requestCancelOrder];
        }
    }
}

#pragma mark request

- (void)requestCancelOrder{
    [[CUOrderManager sharedInstance] cancelOrder:self.order user:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject stringForKeySafely:@"取消成功"]];
                [self.slideNavigationController popViewControllerAnimated:YES];
            }
            else {
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject stringForKeySafely:@"message"]];
            }
        }
        else {
            
            [TipHandler showTipOnlyTextWithNsstring:@"连接服务器失败，请检查网络"];
        }
    } pageName:self.pageName];
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
