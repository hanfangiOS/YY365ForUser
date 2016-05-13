//
//  TreatmentDetailsController.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/19.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "TreatmentDetailsController.h"
#import "DetailsHeaderView.h"
#import "DetailsAppointInfoView.h"
#import "DetailsPaymentInfoView.h"
#import "DetailsOrderInfoView.h"
#import "TreatmentTimeView.h"
#import "DiagnosisRemarkController.h"
#import "CUOrderManager.h"
#import "TipHandler+HUD.h"


@interface TreatmentDetailsController ()<UIAlertViewDelegate>

@property (strong,nonatomic)UIScrollView            * scrollView;
@property (strong,nonatomic)DetailsHeaderView       * headerView;
@property (strong,nonatomic)DetailsAppointInfoView  * appointInfoView;
@property (strong,nonatomic)TreatmentTimeView       * timeView;
@property (strong,nonatomic)DetailsPaymentInfoView  * paymentInfoView;
@property (strong,nonatomic)DetailsOrderInfoView    * orderInfoView;

@property (strong,nonatomic)UIButton                * commentBtn;
@property (strong,nonatomic)UIButton                * deleteBtn;

@end

@implementation TreatmentDetailsController

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"就诊详情";
    
    [self initsubViews];
}

- (void)initsubViews{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    self.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.scrollView.scrollEnabled = YES;
    [self.contentView addSubview: self.scrollView];
    
    //headerView
    self.headerView = [[DetailsHeaderView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, [DetailsHeaderView defaultHeight])];
    [self.scrollView addSubview:self.headerView];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.headerView.data = self.order.service.doctor;
    //约诊信息
    self.appointInfoView = [[DetailsAppointInfoView alloc] initWithFrame:CGRectMake(0, self.headerView.maxY + 10, kScreenWidth, [DetailsAppointInfoView defaultHeight])];
    [self.scrollView addSubview:self.appointInfoView];
    self.appointInfoView.backgroundColor = [UIColor whiteColor];
     self.appointInfoView.data = self.order;
    
    //接诊时间 完诊时间
    self.timeView = [[TreatmentTimeView alloc] initWithFrame:CGRectMake(0, self.appointInfoView.maxY, kScreenWidth, [TreatmentTimeView defaultHeight])];
    [self.scrollView addSubview:self.timeView];
    self.timeView.backgroundColor = [UIColor whiteColor];
    self.timeView.data = self.order;
    //支付信息
    self.paymentInfoView = [[DetailsPaymentInfoView alloc] initWithFrame:CGRectMake(0, self.timeView.maxY + 10, kScreenWidth, [DetailsPaymentInfoView defaultHeight])];
    [self.scrollView addSubview:self.paymentInfoView];
    self.paymentInfoView.backgroundColor = [UIColor whiteColor];
    self.paymentInfoView.data = self.order;
    //订单信息
    self.orderInfoView = [[DetailsOrderInfoView alloc] initWithFrame:CGRectMake(0, self.paymentInfoView.maxY + 10, kScreenWidth, [DetailsOrderInfoView defaultHeight])];
    [self.scrollView addSubview:self.orderInfoView];
    self.orderInfoView.backgroundColor = [UIColor whiteColor];
    self.orderInfoView.data = self.order;
    
    //删除按钮
    self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.orderInfoView.maxY + 10, kScreenWidth/3, 40)];
    self.deleteBtn.backgroundColor = kBlueTextColor;
    [self.deleteBtn setTitle:@"删除订单" forState:UIControlStateNormal];
    [self.deleteBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
    [self.deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.deleteBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.deleteBtn];
    //删除按钮里的小图标
    UIImageView * deleteIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.deleteBtn.frameWidth/2 - 48, (self.deleteBtn.frameHeight - 16)/2, 14.5, 16)];
    deleteIcon.image = [UIImage imageNamed:@"common_icon_trash@2x"];
    [self.deleteBtn addSubview:deleteIcon];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.deleteBtn.maxY);
    
    //评价按钮
    self.commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.deleteBtn.maxX, self.deleteBtn.frameY, (kScreenWidth * 2)/3, 40)];
    self.commentBtn.backgroundColor = UIColorFromHex(0x5793e9);
    [self.commentBtn setTitle:@"评价" forState:UIControlStateNormal];
    [self.commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    self.commentBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.commentBtn addTarget:self action:@selector(CommentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.commentBtn];
    //评价按钮里的小图标
    UIImageView * commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.commentBtn.frameWidth/2 - 36, (self.commentBtn.frameHeight - 16)/2, 16, 16)];
    commentIcon.image = [UIImage imageNamed:@"comment_icon_comment@2x"];
    [self.commentBtn addSubview:commentIcon];

    
}

#pragma mark Action

- (void)CommentAction{
    DiagnosisRemarkController * vc = [[DiagnosisRemarkController alloc] initWithPageName:@"DiagnosisRemarkController"];
    
    Doctor * doctor = self.order.service.doctor;
    vc.data = doctor;
    [self.slideNavigationController pushViewController:vc animated:YES];
}

- (void)cancelAction{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"确认要取消订单吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.delegate = self;
    [alert show];
}

#pragma mark UIAlertDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        return;
    }
    if (buttonIndex == 1) {
        [self requestCancelOrder];
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



@end
