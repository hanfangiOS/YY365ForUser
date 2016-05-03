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
#import "CUOrderManager.h"


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
    
    
    self.timeView = [[TreatmentTimeView alloc] initWithFrame:CGRectMake(0, self.appointInfoView.maxY, kScreenWidth, [TreatmentTimeView defaultHeight])];
    [self.scrollView addSubview:self.timeView];
    self.timeView.backgroundColor = [UIColor whiteColor];
    
    self.paymentInfoView = [[DetailsPaymentInfoView alloc] initWithFrame:CGRectMake(0, self.timeView.maxY + 10, kScreenWidth, [DetailsPaymentInfoView defaultHeight])];
    [self.scrollView addSubview:self.paymentInfoView];
    self.paymentInfoView.backgroundColor = [UIColor whiteColor];
    
    self.orderInfoView = [[DetailsOrderInfoView alloc] initWithFrame:CGRectMake(0, self.paymentInfoView.maxY + 10, kScreenWidth, [DetailsOrderInfoView defaultHeight])];
    [self.scrollView addSubview:self.orderInfoView];
    self.orderInfoView.backgroundColor = [UIColor whiteColor];
    
    self.commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.orderInfoView.maxY + 10, kScreenWidth/2, 48)];
    self.commentBtn.backgroundColor = [UIColor orangeColor];
    [self.commentBtn setTitle:@"评价" forState:UIControlStateNormal];
    [self.commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    self.commentBtn.layer.cornerRadius = 5.0f;
    self.commentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.commentBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.commentBtn];
    
    UIImageView * commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.commentBtn.centerX - 40, (self.commentBtn.frameHeight - 25)/2, 25, 25)];
    commentIcon.image = [UIImage imageNamed:@""];
    commentIcon.backgroundColor = [UIColor redColor];
    [self.commentBtn addSubview:commentIcon];
    
    self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.commentBtn.maxX, self.commentBtn.frameY, kScreenWidth/2, 48)];
    self.deleteBtn.backgroundColor = [UIColor orangeColor];
    [self.deleteBtn setTitle:@"删除订单" forState:UIControlStateNormal];
    [self.deleteBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
    [self.deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.deleteBtn.layer.cornerRadius = 5.0f;
    self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.deleteBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.deleteBtn];
    
    UIImageView * deleteIcon = [[UIImageView alloc] initWithFrame:CGRectMake(commentIcon.frameX, (self.deleteBtn.frameHeight - 25)/2, 25, 25)];
    deleteIcon.image = [UIImage imageNamed:@""];
    deleteIcon.backgroundColor = [UIColor grayColor];
    [self.deleteBtn addSubview:deleteIcon];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.deleteBtn.maxY + 20);
    
}

- (void)resetData{
    
}

- (void)payAction{

}

- (void)cancelAction{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"确认要删除订单吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.delegate = self;
    [alert show];
}

#pragma mark UIAlertDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
}

#pragma mark postRequest

//已付款已看病详情
- (void)postRequestGetOrderHasPayHasMeetDetail{
    OrderFilter * filter = [[OrderFilter alloc] init];
    filter.diagnosisID = self.order.diagnosisID;
    
    [[CUOrderManager sharedInstance] getOrderHasPayHasMeetDetailWithFilter:filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                
                self.order = result.parsedModelObject;
                [self resetData];
            }
        }
        
    } pageName:@"TreatmentDetailsController"];
}

@end
