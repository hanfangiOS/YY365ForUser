//
//  CUOrderDetailViewController.m
//  CollegeUnion
//
//  Created by li na on 15/3/5.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUOrderDetailViewController.h"
#import "CUUIContant.h"
#import "SNPhoneHelper.h"
#import "UIImageView+WebCache.h"
#import "CUOrderManager.h"
#import "CUUserManager.h"
#import "TipHandler+HUD.h"
#import "OrderManager+ThirdPay.h"
#import "CUOrderListViewController.h"
#import "SNTopTabViewController.h"
#import "UIConstants.h"
#import "OrderResultController.h"
#import "UIBarButtonItem+CommenButton.h"
#import "SNPhoneHelper.h"
#import "UIImage+Color.h"
#import "MobClickConstants.h"
#import "MobClick.h"
#import "OrderConfirmController.h"

#import "OrderDetailView.h"

@interface CUOrderDetailViewController ()

@property (nonatomic,strong)UIButton * payButton;

@end

@implementation CUOrderDetailViewController
{
    UIScrollView      *_detailContentView;
    
    OrderDetailView   *_orderInfoView;
    
    float              _contentViewMaxY;
}

- (void)requestDetailData
{
    [self showProgressView];
    
    __weak CUOrderDetailViewController * blockSelf = self;
    [[CUOrderManager sharedInstance] getOrderDetailWithOrderId:self.order.diagnosisID user:[CUUserManager sharedInstance].user resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result)
     {
         [blockSelf hideProgressView];
         if (!result.hasError)
         {
             blockSelf.order = (CUOrder *)result.parsedModelObject;
             
             [self loadNavigationBar];
             [self initSubviews];
         }
         else
         {
             [TipHandler showHUDText:[result.error.userInfo valueForKey:NSLocalizedDescriptionKey] state:TipStateFail inView:blockSelf.contentView];
         }
         
     } pageName:@"CUOrderDetailViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kLightBlueColor;
    self.contentView.backgroundColor = self.view.backgroundColor;
    self.title = @"约诊单";
    
    if ([self.order shouldRequireDetail])
    {
        // 不是从订单列表过来的
        [self requestDetailData];
    }
    else {
        [self initSubviews];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (instancetype)initWithPageName:(NSString *)pageName order:(CUOrder *)order
{
    if (self = [super initWithPageName:pageName])
    {
        self.order = order;
    }

    return self;
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
    
    if (self.order.orderStatus == ORDERSTATUS_PAID)
    {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem rightItemWithTitle:@"申请退款" target:self action:@selector(refund)];
    }
    else if (self.order.orderStatus == ORDERSTATUS_UNPAID)
    {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem rightItemWithTitle:@"取消订单" target:self action:@selector(cancelOrder)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)initSubviews
{
    _contentViewMaxY = 10;
    
    [self initContentView];
    [self initOrderInfoView];
    [self initOrderImageView];
    [self initFooterView];
    
    if (_contentViewMaxY > _detailContentView.contentSize.height) {
        _detailContentView.contentSize = CGSizeMake(_detailContentView.contentSize.width, _contentViewMaxY);
    }
}

- (void)initContentView
{
    _detailContentView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    _detailContentView.backgroundColor = [UIColor clearColor];
    _detailContentView.delegate = (id)self;
    _detailContentView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:_detailContentView];
    
    _detailContentView.contentSize = CGSizeMake(_detailContentView.bounds.size.width, _detailContentView.bounds.size.height + 1);
}

- (void)initOrderInfoView
{
    _orderInfoView = [[OrderDetailView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), _detailContentView.frameHeight)];
    _orderInfoView.backgroundColor = self.contentView.backgroundColor;
    _orderInfoView.order = self.order;
    [_detailContentView addSubview:_orderInfoView];
    
    _orderInfoView.frameHeight = [_orderInfoView calculateViewHeight];
    
    _contentViewMaxY = CGRectGetMaxY(_orderInfoView.frame);
}

- (void)initOrderImageView
{
    
}

- (void)initFooterView
{
    // 付款button
    if (self.order.orderStatus == ORDERSTATUS_UNPAID && _payButton==nil)
    {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setTitle:@"去支付" forState:UIControlStateNormal];
        _payButton.backgroundColor = kGreenColor;
        _payButton.frame = CGRectMake(0, self.contentView.frameHeight-44, self.contentView.boundsWidth, 44);
        [self.contentView addSubview:_payButton];
        [_payButton addTarget:self action:@selector(confirmOrder) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)refund
{
    
}

- (void)cancelOrder
{
    [self showProgressView];
    __weak CUOrderDetailViewController * blockSelf = self;
    [[CUOrderManager sharedInstance] updateOrder:self.order status:ORDERSTATUS_CANCELED user:[CUUserManager sharedInstance].user resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {

        [blockSelf hideProgressView];
        if (!result.hasError)
        {
            // 修改订单状态
            self.order.orderStatus = ORDERSTATUS_CANCELED;
            [self loadNavigationBar];
            
            [TipHandler showHUDText:@"取消成功" state:TipStateSuccess inView:blockSelf.contentView];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_OrderCancelSuccess object:self.order];
            [self performSelector:@selector(popControllerByCancelOrder) withObject:nil afterDelay:0.7];
        }
        else
        {
            [TipHandler showHUDText:[result.error.userInfo valueForKey:NSLocalizedDescriptionKey] state:TipStateFail inView:blockSelf.contentView];
        }
        
    } pageName:@"CUOrderDetailViewController"];
    
    [MobClick event:Event_Order_Cancel_Click];
}

- (void)confirmOrder
{
    OrderConfirmController *confirmVC = [[OrderConfirmController alloc] init];
    confirmVC.order = self.order;
    [self.slideNavigationController pushViewController:confirmVC animated:YES];
}

- (void)enterPaymentResult:(BOOL)success
{}

- (void)popControllerByCancelOrder
{
    SNSlideNavigationController *slide = self.slideNavigationController;
    UIViewController *vc = nil;
    
    for (UIViewController *controller in slide.viewControllers) {
        if ([controller isKindOfClass:[SNTopTabViewController class]] || [controller isKindOfClass:NSClassFromString(@"SNTabViewController")]) {
            vc = controller;
            break;
        }
    }
    
    if (vc)
    {
        [slide popToViewController:vc animated:YES];
    }
}

- (void)phoneCall
{
    [SNPhoneHelper call:@""];
}

@end
