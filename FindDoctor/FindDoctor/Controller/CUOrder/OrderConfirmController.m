//
//  OrderConfirmController.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/24.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "OrderConfirmController.h"
#import "OrderInfoView.h"
#import "CUOrder.h"
#import "Doctor.h"
#import "CreateOrderButtonView.h"
#import "TipHandler+HUD.h"
#import "CUOrderManager.h"
#import "OrderResultController.h"
#import "OrderManager+ThirdPay.h"
#import "UserDropdownMenuView.h"
#import "WXApi.h"
#import "CUUserManager.h"
#import "JSONKit.h"
#import "CUServerAPIConstant.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "Pingpp.h"

#import "MyDiagnosisRecordsListModel.h"

#define KBtn_width        200
#define KBtn_height       40
#define KXOffSet          (self.view.frame.size.width - KBtn_width) / 2
#define KYOffSet          20

#define kWaiting          @"正在获取支付凭据,请稍后..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果：%@"

#define kPlaceHolder      @"支付金额"
#define kMaxAmount        9999999

#define kUrlScheme      @"wx584ad6cae2973f02" // 这个是你定义的 URL Scheme，支付宝、微信支付和测试模式需要。

@interface OrderConfirmController (){
    UIAlertView     * mAlert;
    NSString        * newCharge;//charge对象
}

@end

@implementation OrderConfirmController
{
    UITableView *orderTable;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"确认订单";
    self.view.backgroundColor = kLightBlueColor;
    
    self.contentView.backgroundColor = self.view.backgroundColor;
    
    self.order.payment = ORDERPAYMENT_ZhiFuBao;
    
    [self initSubviews];
}

- (void)initSubviews
{
    CGFloat footerHeight = [CreateOrderButtonView defaultHeight];
    orderTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.contentView.frameHeight - footerHeight)];
    orderTable.dataSource = (id)self;
    orderTable.delegate = (id)self;
    orderTable.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:orderTable];
    
    orderTable.tableHeaderView = [self tableHeaderView];
    orderTable.tableFooterView = [[UIView alloc] init];
    
    CreateOrderButtonView *_orderButtonView = [[CreateOrderButtonView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.contentView.bounds) - footerHeight, kScreenWidth, footerHeight)];
    _orderButtonView.showAmount = NO;
    _orderButtonView.amount = self.order.service.dealPrice;
    _orderButtonView.title = @"确认支付";
    _orderButtonView.amountTitle = @"需支付";
    _orderButtonView.amountFont = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_orderButtonView];
    
    __weak typeof(self) weakSelf = self;
    _orderButtonView.onClickAction = ^(void){
        [weakSelf payAction];
    };
}

- (UIView *)tableHeaderView
{
    CGFloat labelOriginY = 20.0;
    CGFloat labelHeight = 20.0;
    
    CGFloat headerHeight = [OrderInfoView defaultHeight];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, headerHeight)];
    header.backgroundColor = self.view.backgroundColor;
    
    /*
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, labelOriginY, header.frameWidth, labelHeight)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = kBlackColor;
    label.font = [UIFont systemFontOfSize:17];
    [header addSubview:label];
    
    label.text = [NSString stringWithFormat:@"约诊 %@医生", self.order.service.doctor.name];
    
    UserDropdownMenuView *menuView = [[UserDropdownMenuView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), kScreenWidth, [UserDropdownMenuView defaultHeight])];
    menuView.backgroundColor = header.backgroundColor;
    menuView.user = [[CUUser alloc] init];
    menuView.user.name = @"测试用户";
    [header addSubview:menuView];
    [menuView update];*/
    
    UserDropdownMenuView *menuView = nil;
    OrderInfoView *infoView = [[OrderInfoView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(menuView.frame), kScreenWidth, [OrderInfoView defaultHeight])];
    infoView.order = self.order;
    [header addSubview:infoView];
    [infoView update];
    
    return header;
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 2;
    
//    return ([WXApi isWXAppInstalled] ? 3 : 2);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    header.backgroundColor = [UIColor clearColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, header.frameHeight - kDefaultLineHeight, header.frameWidth, kDefaultLineHeight)];
    lineView.backgroundColor = kDarkLineColor;
    [header addSubview:lineView];
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ConfirmOderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = kBlackColor;
        
        cell.detailTextLabel.textColor = kYellowColor;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = nil;
    
    if (indexPath.section == 0) {
        cell.imageView.image = nil;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"可用诊金券";
            cell.detailTextLabel.text = @"0";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else {
            cell.textLabel.text = @"支付诊金";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.2f",self.order.dealPrice/100.f];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    else {
        NSArray *titleArr = @[@"支付宝", @"银联"];
        NSArray *iconArr = @[@"order_icon_zhifubao", @"order_icon_yinlian"];
//        if ([WXApi isWXAppInstalled]) {
//            titleArr = @[@"支付宝", @"微信", @"银联"];
//            iconArr = @[@"order_icon_zhifubao", @"order_icon_weixin", @"order_icon_yinlian"];
//        }
        titleArr = @[@"支付宝", @"微信", @"银联"];
        iconArr = @[@"order_icon_zhifubao", @"order_icon_weixin", @"order_icon_yinlian"];
        
        cell.imageView.image = [UIImage imageNamed:iconArr[indexPath.row]];
        cell.textLabel.text = titleArr[indexPath.row];
        cell.detailTextLabel.text = nil;
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        if (self.order.payment == indexPath.row + 1) {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_icon_check"]];
        }
        else {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_icon_uncheck"]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        
    }
    else if (indexPath.section == 1) {
        NSInteger newPayment = indexPath.row + 1;
        if (newPayment != self.order.payment) {
            NSIndexPath *oldPath = [NSIndexPath indexPathForRow:self.order.payment - 1 inSection:1];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:oldPath];
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_icon_uncheck"]];
            
            self.order.payment = newPayment;
            
            cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_icon_check"]];
        }
    }
}

#pragma mark - Private Action

- (void)payAction
{
//    [self test];
//    return;
//#warning 测试代码
//    self.order.diagnosisID = 131313131231;
//    self.order.service.queueNumber = 10;
//    self.order.service.queueCount = 100;
//    self.order.createTimeStamp = 1440780889;
//    self.order.orderStatus = ORDERSTATUS_PAID;
//    [self enterResult:OrderResultSuccess];
//    return;
    
//    if (self.order.payment == ORDERPAYMENT_ZhiFuBao) {
//        // 支付宝支付
//        [[CUOrderManager sharedInstance] payOrder:self.order tn:nil block:^(NSError *error, id responseObject) {
//            if (error == nil) {
//                [self enterResult:OrderResultSuccess];
//            }
//            else {
//                [TipHandler showSmallStringTipWithText:error.domain];
//            }
//        }];
//    }
//    else if (self.order.payment == ORDERPAYMENT_YinLian) {
//        __weak typeof(self) weakSelf = self;
//        [[CUOrderManager sharedInstance] getOrderTNWithOrderId:[NSString stringWithFormat:@"%lld",self.order.diagnosisID] block:^(SNHTTPRequestOperation * request,SNServerAPIResultData * result) {
//            NSString *tn = result.parsedModelObject;
//            if (!result.hasError && [tn isKindOfClass:[NSString class]]) {
//                [weakSelf payOrderWithTN:tn];
//            }
//            else {
//                [TipHandler showHUDText:@"银联调用失败" state:TipStateFail inView:self.view];
//            }
//        }];
//    }
    if (self.order.payment == ORDERPAYMENT_WeiXin) {
        self.channel = @"wx";
        [self CheckOrderHasPaid];
//        [self normalPayAction:nil];
    }
    else if (self.order.payment == ORDERPAYMENT_ZhiFuBao) {
        self.channel = @"alipay";
        [self CheckOrderHasPaid];
//        [self normalPayAction:nil];
    }
    else{
        return;
    }
}

//- (void)payOrderWithTN:(NSString *)tn
//{
//    [[CUOrderManager sharedInstance] payOrder:self.order tn:tn block:^(NSError *error, id responseObject) {
//        [self handlePayResult:responseObject error:error];
//    }];
//}


//- (void)handlePayResult:(id)responseObject error:(NSError *)error
//{
//    if (error == nil && responseObject) {
//        [self enterResult:OrderResultSuccess];
//    }
//    else {
//        [TipHandler showSmallStringTipWithText:error.domain];
//    }
//}


//11601 获取订单状态
- (void)postRequestCheckOrderStatus{
    
}

- (void)enterResult:(OrderResult)orderResult
{
    [self showProgressView];
    __weak __block OrderConfirmController *blockSelf = self;
    [[CUOrderManager sharedInstance]getOrderStateWithDiagnosisID:blockSelf.order.diagnosisID resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        [blockSelf hideProgressView];
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                SNSlideNavigationController *slide = blockSelf.slideNavigationController;
                UIViewController *vc = nil;
                for (UIViewController *controller in slide.viewControllers) {
                    if ([controller isKindOfClass:NSClassFromString(@"SNTabViewController")]) {
                        vc = controller;
                        break;
                    }
                }
                if (vc) {
                    [slide popToViewController:vc animated:NO];
                }
                
                OrderResultController *resultVC = [[OrderResultController alloc] init];
                resultVC.orderResult = OrderResultSuccess;
                resultVC.order = result.parsedModelObject;
                [slide pushViewController:resultVC animated:YES];
            }
            else{
                SNSlideNavigationController *slide = blockSelf.slideNavigationController;
                UIViewController *vc = nil;
                for (UIViewController *controller in slide.viewControllers) {
                    if ([controller isKindOfClass:NSClassFromString(@"SNTabViewController")]) {
                        vc = controller;
                        break;
                    }
                }
                if (vc) {
                    [slide popToViewController:vc animated:NO];
                }
                OrderResultController *resultVC = [[OrderResultController alloc] init];
                resultVC.orderResult = OrderResultFailed;
                resultVC.order = result.parsedModelObject;
                [slide pushViewController:resultVC animated:YES];
            }
        }
    } pageName:@"OrderConfirmController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark  -------- ping++ --------

- (void)showAlertWait
{
    mAlert = [[UIAlertView alloc] initWithTitle:kWaiting message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [mAlert show];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aiv.center = CGPointMake(mAlert.frame.size.width / 2.0f - 15, mAlert.frame.size.height / 2.0f + 10 );
    [aiv startAnimating];
    [mAlert addSubview:aiv];
}

- (void)showAlertMessage:(NSString*)msg
{
    if ([msg isEqualToString:@"success"] || [msg isEqualToString:@"fail"]){
        [self enterResult:OrderResultSuccess];
        return;
    }
    mAlert = [[UIAlertView alloc] initWithTitle:kNote message:msg delegate:nil cancelButtonTitle:kConfirm otherButtonTitles:nil, nil];
    [mAlert show];
}

- (void)hideAlert
{
    if (mAlert != nil)
    {
        [mAlert dismissWithClickedButtonIndex:0 animated:YES];
        mAlert = nil;
    }
}

- (void)normalPayAction:(id)sender
{
    NSURL* url = [NSURL URLWithString:@"http://www.uyi365.com/baseFrame/base/getCharge.jmt"];
    NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:url];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"PayDiagnosisOK" forKey:@"require"];
    [param setObjectSafely:@(11601) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:@(self.order.service.patience.userId) forKey:@"accID"];
    [dataParam setObjectSafely:@(self.order.diagnosisID) forKey:@"diagnosisID"];
    [dataParam setObjectSafely:@(0) forKey:@"couponID"];
    [dataParam setObjectSafely:@(0) forKey:@"couponMoney"];
    [dataParam setObjectSafely:@(self.order.diagnosisID) forKey:@"order_no"];

    [dataParam setObjectSafely:self.order.service.doctor.name forKey:@"doctorName"];
    [dataParam setObjectSafely:@([self.order.service.doctor.phoneNumber integerValue]) forKey:@"doctorPhone"];
    [dataParam setObjectSafely:self.order.service.patience.name forKey:@"user_name"];
    [dataParam setObjectSafely:self.order.service.patience.cellPhone forKey:@"user_phone"];
    [dataParam setObjectSafely:@(self.order.service.patience.gender) forKey:@"user_sex"];
    [dataParam setObjectSafely:@(self.order.service.patience.age) forKey:@"user_age"];
    [dataParam setObjectSafely:@(self.order.dealPrice) forKey:@"amount"];
    [dataParam setObjectSafely:self.channel forKey:@"chargetype"];
    [dataParam setObjectSafely:[NSString stringWithFormat:@"优医365订单 单号: %lld",self.order.diagnosisID] forKey:@"subject"];
    [dataParam setObjectSafely:[NSString stringWithFormat:@"iOS端timestamp%ld",(NSInteger)[NSDate timeIntervalSince1970]] forKey:@"body"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
//    NSDictionary* dict =
//    NSData* data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *bodyData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *bodyData = [param JSONString];
    
    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    OrderConfirmController * __weak weakSelf = self;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [self showAlertWait];
    [self showProgressView];
    [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
//            [weakSelf hideAlert];
            [weakSelf hideProgressView];
            if (httpResponse.statusCode != 200) {
                NSLog(@"statusCode=%ld error = %@", (long)httpResponse.statusCode, connectionError);
                [weakSelf showAlertMessage:kErrorNet];
                return;
            }
            if (connectionError != nil) {
                NSLog(@"error = %@", connectionError);
                [weakSelf showAlertMessage:kErrorNet];
                return;
            }
//            NSString* charge = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSData *jsonData = [charge JSONData];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSDictionary * dic2 = [dic objectForKey:@"charge"];
            NSString* charge = [dic2 JSONString];
            NSLog(@"charge = %@", charge);
            newCharge = charge;
            [Pingpp createPayment:charge appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
                NSLog(@"completion block: %@", result);
                if (error == nil) {
                    NSLog(@"PingppError is nil");
                } else {
                    NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
                }
                [weakSelf showAlertMessage:result];
            }];
        });
    }];
}

- (void)CheckOrderHasPaid{
    __weak __block OrderConfirmController *blockSelf = self;
    [[CUOrderManager sharedInstance]getOrderStateWithDiagnosisID:blockSelf.order.diagnosisID resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                //订单已经被支付了
            }
            else{
                [self normalPayAction:nil];
            }
        }
    } pageName:@"OrderConfirmController"];
}


@end
