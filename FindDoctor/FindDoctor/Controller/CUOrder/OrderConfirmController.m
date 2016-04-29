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
#import "AppointmentDetailsController.h"

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
}

@end

@implementation OrderConfirmController
{
    UITableView *orderTable;
}

#pragma mark - View

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
    
    CGFloat headerHeight = [OrderInfoView defaultHeight];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, headerHeight)];
    header.backgroundColor = self.view.backgroundColor;
    
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

#pragma mark - TableViewDelegate

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

#pragma mark - AlertDelegate

- (void)showAlertWithMessage:(NSString*)msg
{
    //    if ([msg isEqualToString:@"success"]){
    //        NSLog(@"支付成功， 跳转页面确认订单成功消息");
    //        return;
    //    }
    mAlert = [[UIAlertView alloc] initWithTitle:kNote message:msg delegate:nil cancelButtonTitle:kConfirm otherButtonTitles:nil, nil];
    [mAlert show];
}

#pragma mark - Post Request

////11601 获取订单状态 （支付前）
//- (void)postRequestCheckOrderStatusBefore{
//    [self showProgressView];
//    [[CUOrderManager sharedInstance]getOrderStateWithDiagnosisID:_order.diagnosisID resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
//        [self hideProgressView];
//        if (!result.hasError) {
//            if ([result.responseObject integerForKeySafely:@"errorCode"] == -1) {
//                [self postRequestGetCharge];
//            }else{
//                [self handleOrderResult];
//            }
//        }
//    } pageName:@"OrderConfirmController"];
//    
//}

//获取charge对象
- (void)postRequestGetCharge{
    NSURL* url = [NSURL URLWithString:kGetChargeUrl];
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
    [dataParam setObjectSafely:[NSString stringWithFormat:@"iOS端timestamp%ld",(long)[NSDate timeIntervalSince1970]] forKey:@"body"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
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
            [weakSelf hideProgressView];
            //            [weakSelf hideAlert];
            //NSURLConnection正确返回码200
            if (httpResponse.statusCode == 200) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSNumber * errorCode = [dic objectForKeySafely:@"errorCode"];
                
                if (![errorCode integerValue]) {
                    NSDictionary * dict1 = [dic dictionaryForKeySafely:@"data"];
                    NSDictionary * dic2 = [dict1 objectForKey:@"charge"];
                    NSString* charge = [dic2 JSONString];
                    NSLog(@"charge = %@", charge);
                    [weakSelf postRequestCreatePayMent:charge];
                }else{
                    [TipHandler showTipOnlyTextWithNsstring:[dic stringForKeySafely:@"message"]];
                }
            }else{
                NSLog(@"statusCode=%ld error = %@", (long)httpResponse.statusCode, connectionError);
                [weakSelf showAlertWithMessage:kErrorNet];
                return;
            }

        });
    }];
    
}

//11601 获取订单状态 （支付后）
- (void)postRequestCheckOrderStatusAfter{
    [[CUOrderManager sharedInstance]getOrderStateWithDiagnosisID:_order.diagnosisID resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError) {
            if ([result.responseObject integerForKeySafely:@"errorCode"] == -1) {
               [TipHandler showTipOnlyTextWithNsstring:[result.responseObject valueForKey:@"message"]];
            }else {
                self.order = result.parsedModelObject;
                [self handleOrderResult];
            }
        }
    } pageName:@"OrderConfirmController"];
    
}

//发送请求，调起支付控件
- (void)postRequestCreatePayMent:(NSString *)charge{
    __weak __block OrderConfirmController *blockSelf = self;
    [Pingpp createPayment:charge viewController:blockSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
        
        NSLog(@"completion block: %@", result);
        if (error == nil) {
            NSLog(@"PingppError is nil");
        } else {
            NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
        }
        [blockSelf postRequestCheckOrderStatusAfter];
    }];
}

#pragma mark - Action

- (void)payAction
{
    [self checkOrder];
}

#pragma mark - Private Methods

- (void)checkOrder{
    if (self.order.payment == ORDERPAYMENT_WeiXin) {
        self.channel = @"wx";
        
        if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]){
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先安装微信" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        [self postRequestGetCharge];
    }
    else if (self.order.payment == ORDERPAYMENT_ZhiFuBao) {
        self.channel = @"alipay";
        [self postRequestGetCharge];
    }
    else{
        return;
    }
    
}

//根据结果处理订单
- (void)handleOrderResult{
    
    AppointmentDetailsController * VC = [[AppointmentDetailsController alloc] initWithPageName:@"AppointmentDetailsController"];
    VC.order = self.order;
    VC.from = @"支付";
    
    [self.slideNavigationController pushViewController:VC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
