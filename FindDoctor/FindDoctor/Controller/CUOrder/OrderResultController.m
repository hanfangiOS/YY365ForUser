//
//  OrderResultController.m
//  CommentTest
//
//  Created by zhouzhenhua on 14-9-11.
//  Copyright (c) 2014年 zhouzhenhua. All rights reserved.
//

#import "OrderResultController.h"
#import "UIConstants.h"
#import "OrderTextLabel.h"

#import "OrderResultButtonView.h"
#import "CUOrderDetailViewController.h"

#import "UMSocial.h"
#import "CUShareConstant.h"
#import "TipHandler+HUD.h"
#import "OrderResultView.h"
#import "MyDiagnosisRecordsDetailViewController.h"
#import "OrderConfirmController.h"
#import "AppointmentDetailsController.h"
#import "CUOrderManager.h"

//#import "CUUserManager+Share.h"
//#import "PointRuleManager.h"

#define kHeaderHeight      36.0
#define kImageWidth        67.0

#define kViewWidth         CGRectGetWidth(self.view.bounds)

@interface OrderResultController ()

@end

@implementation OrderResultController
{
    float            _maxOriginY;
    UITableView     *_orderTable;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kLightBlueColor;
    self.contentView.backgroundColor = kLightBlueColor;
    
    self.title = (self.orderResult == OrderResultSuccess) ? @"约诊成功" : @"约诊失败";
    

    
    
//    if (self.orderResult == OrderResultSuccess) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_OrderSubmitSuccess object:self.order];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_OrderCountChange object:[NSNumber numberWithInt:1]];
//    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    for (CUViewController * vc in self.slideNavigationController.viewControllers) {
        if ([vc isKindOfClass:[OrderConfirmController class]]) {
            [vc.slideNavigationController popToRootViewControllerAnimated:YES];
        }
    }
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

- (void)loadContentView
{
    _orderTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frameWidth, self.contentView.frameHeight - [OrderResultButtonView defaultHeight])];
    _orderTable.backgroundColor = [UIColor clearColor];
    _orderTable.dataSource = (id)self;
    _orderTable.delegate = (id)self;
    [self.contentView addSubview:_orderTable];
    
    _orderTable.tableHeaderView = [self tableHeaderView];
    _orderTable.tableFooterView = [self tableFooterView];
    
    if (self.orderResult == OrderResultSuccess){
        [self initButtonView];
    }
}

- (UIView *)tableHeaderView
{
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frameWidth, 258)];
    headerView.userInteractionEnabled = YES;
    headerView.image = [UIImage imageNamed:@""];
    headerView.contentMode = UIViewContentModeScaleAspectFill;
    headerView.clipsToBounds = YES;
    
    CGFloat statusTextWidth = 120.0;
    
    CGFloat statusViewOriginY = 35.0;
    CGFloat statusViewWidth = kImageWidth + 20 + statusTextWidth;
    CGFloat statusViewHeight = kImageWidth;
    
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frameWidth - statusViewWidth) / 2, statusViewOriginY, statusViewWidth, statusViewHeight)];
    statusView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:statusView];
    
    UIImageView *statusImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kImageWidth, kImageWidth)];
    [statusView addSubview:statusImage];
    
    if (self.orderResult == OrderResultSuccess) {
        statusImage.image = [UIImage imageNamed:@"order_icon_success"];
    }
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(statusViewWidth - statusTextWidth, 0, statusTextWidth, statusViewHeight)];
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.font = [UIFont systemFontOfSize:30];
    [statusView addSubview:statusLabel];
    
    if (self.orderResult == OrderResultSuccess) {
        statusLabel.text =  @"支付成功";
        statusLabel.textColor = UIColorFromHex(Color_Hex_NavBackground);
    }
    
    if (self.orderResult == OrderResultFailed) {
        statusLabel.text =  @"支付失败";
        statusLabel.textColor = UIColorFromHex(Color_Hex_NavBackground);
    }
    
    OrderResultView *resultView = [[OrderResultView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(statusView.frame) + statusViewOriginY, self.view.frameWidth, 125)];
    resultView.backgroundColor = [UIColor clearColor];
    resultView.order = self.order;
    [headerView addSubview:resultView];
    [resultView update];
    
    if (self.orderResult == OrderResultFailed){
        resultView.hidden = YES;
    }
    
    return headerView;
}

- (void)initButtonView
{
    // TODO:失败时不显示？
    OrderResultButtonView *buttonView = [[OrderResultButtonView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.contentView.bounds) - [OrderResultButtonView defaultHeight], kScreenWidth, [OrderResultButtonView defaultHeight])];
    [self.contentView addSubview:buttonView];
    
    __weak typeof(self) weakSelf = self;
    buttonView.leftAction = ^{
        [weakSelf checkOrder];
    };
    
    buttonView.rightAction = ^{
        [weakSelf backAction];
    };
}

- (UIView *)tableFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frameWidth, 90)];
    footerView.backgroundColor = [UIColor clearColor];
    
    CGFloat tipPadding = 15.0;
    CGFloat tipHeight = 15.0 * 2;
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(tipPadding, (footerView.frameHeight - tipHeight) / 2, footerView.frameWidth - tipPadding * 2, tipHeight)];
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = kDarkGrayColor;
    tipLabel.numberOfLines = 0;
    [footerView addSubview:tipLabel];
    
    NSString *tipString = @"如在约诊时间前4小时内取消订单，将扣除诊金20%的违约金。";
    tipLabel.text = tipString;
    
    return footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"OrderResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = kBlackColor;
        
        cell.detailTextLabel.textColor = kYellowColor;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"获得积分";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",(long)self.order.obtainScore];
    }
    else {
        cell.textLabel.text = @"赠送诊金券";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f",self.order.obtainCouponMoney/100.f];;
    }
    
    return cell;
}

#pragma mark - Action

- (void)checkOrder
{
    [self postRequestGetOrderHasPayNotMeetDetailWithOrder:self.order];
}

- (void)shareAction
{
    NSString *shareTitle = nil;
    NSString *shareContent = nil;
    shareTitle = kChargeDriveShareTitle;
    shareContent = kChargeDriveShareContent;
    
    NSString *seriesName = @"";
    shareTitle = [shareTitle stringByReplacingOccurrencesOfString:@"XXX" withString:seriesName];
    
    [UMSocialData defaultData].extConfig.sinaData.shareText = shareTitle;
    [UMSocialData defaultData].extConfig.sinaData.shareImage = [UIImage imageNamed:@"share_icon"];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
    [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppkey
                                      shareText:shareContent
                                     shareImage:[UIImage imageNamed:@"share_icon"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQQ,nil]
                                       delegate:(id)self];
}

#pragma mark postRequest

//已付款未看病详情
- (void)postRequestGetOrderHasPayNotMeetDetailWithOrder:(CUOrder *)order{
    OrderFilter * filter = [[OrderFilter alloc] init];
    filter.diagnosisID = order.diagnosisID;
    
    [[CUOrderManager sharedInstance] getOrderHasPayNotMeetDetailWithFilter:filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                CUOrder * order1 = [[CUOrder alloc] init];
                order1 = result.parsedModelObject;
                order1.orderStatus = ORDERSTATUS_PAID;
                AppointmentDetailsController * VC = [[AppointmentDetailsController alloc] initWithPageName:@"AppointmentDetailsController"];
                VC.order = order1;
                [self.slideNavigationController pushViewController:VC animated:YES];
                
            }
        }
        
    } pageName:@"MyAppointmentController"];
}


- (void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
//    if (platformName == UMShareToSina) {
//        NSString *shareText = [UMSocialData defaultData].extConfig.sinaData.shareText;
//        shareText = [NSString stringWithFormat:@"%@ %@", shareText, kAppShareShortURL];
//        [UMSocialData defaultData].extConfig.sinaData.shareText = shareText;
//    }
}

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
