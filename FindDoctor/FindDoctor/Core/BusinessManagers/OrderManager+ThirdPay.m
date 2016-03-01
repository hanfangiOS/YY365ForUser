//
//  OrderManager+ThirdPay.m
//  CollegeUnion
//
//  Created by li na on 15/3/17.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "OrderManager+ThirdPay.h"
#import <objc/runtime.h>

//#import "CUOrder.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"

#import <AlipaySDK/AlipaySDK.h>
#import "JSONKit.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "UPPayPlugin.h"
#import "AppDelegate.h"
#import "AppCore.h"
#import "CUServerAPIConstant.h"

/*
 1.支付宝宏定义
 */
//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088711672674003"
//收款支付宝账号
#define SellerID  @"xlg@xlgvip.com"

////安全校验码（MD5）密钥，以数字和字母组成的32位字符
//#define MD5_KEY @"yj6gr7e94e19h1ciq3mrp1wnf7lc5nwl"

// 商户私钥，自助生成(pcks8格式，去掉换行符)
// http://help.alipay.com/support/help_detail.htm?help_id=397433&keyword=%C3%DC%D4%BF
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMcpocDDhaMouvn5F2EbNsszPninjGGmnP7LAIH4P2R8F3mNZV0UvK1j0EVFAEzrHSBBaJK8rjW+U23K5W31Sev8YpNCYEmoNJ9IaXzVsMo7n2lXysciv7MyRA8TFOAiiGP6siWYfEYCePmnJKgjE9M3h/iOo5dqeMOhZqHe0tJrAgMBAAECgYEAnF5MeGtKvkqZWvA+ceiLAclvEA4EgxrsgoPiFylQpFVlnPLuFcHVTZFjkS9WyA2E5bFVKHhpkxqmqDo4HjgK25FBICGK9gM2hp3QlBslFwCSuAFsB2+Oxh3Funm30L84lLQ/nhlM+31BebKxI9xsD7QTh+4FN50ey4oNwzWLcYkCQQDu1IaCNV4K7TqM+MeAyZhOHtAVrNoYpjv9h5Yk/yeRVMd+7f9AWoxA36H8v3CRhXnfE4xPuAtmhJ+537wTG7APAkEA1XsOtmkpn+m+6U5M0tMxpA88QXmUhbpKkhExtmVP7uIlucz20kSeLWrMqsOsgiNi17CeNY0QeBVPznca3/db5QJAGRgPggLlfLRsYH+LRsbnz92A86YTzF87Emp6piyBFc4YoAeVuEdLUU2uEYZz53Zk1cGSDpZB7GWm+rq9YiyYlQJALGbW7Yu7853Lbn0xr1vr5EKi9r9R6+qOXgkjfNtfn8D7tcRyxdMtzyZ6gT4HoF25zkDW9y5q8X8FRV0ygsjRHQJAdn9odI2NQ9FyR8lFGDM842VX1UG1eVBc8yU1npCK0YAwCbRni5wey70dwWaU2uUnsMRia+UE3QhUoNgqjtYNww=="

//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDHKaHAw4WjKLr5+RdhGzbLMz54p4xhppz+ywCB+D9kfBd5jWVdFLytY9BFRQBM6x0gQWiSvK41vlNtyuVt9Unr/GKTQmBJqDSfSGl81bDKO59pV8rHIr+zMkQPExTgIohj+rIlmHxGAnj5pySoIxPTN4f4jqOXanjDoWah3tLSawIDAQAB"

/* 支付宝回调 */
#define URL_OrderCallBack                @"http://www.xiaolianbang.com/apply/notify_url.php"

/*
 2.银联宏定义
 */

#ifdef CollegeUnion_Distribution

#define kMode             @"00"  // 00:正式环境  01:开发环境  02:测试环境

#else

#define kMode             @"01"  // 00:正式环境  01:开发环境  02:测试环境

#endif

@implementation CUOrderManager(AliPay)

- (void)payOrder:(CUOrder *)order tn:(NSString *)tn block:(OrderResultBlock)block
{
//    self.currentOrderId = order.diagnosisID;
    self.currentOrderBlock = block;
    
    if (order.payment == ORDERPAYMENT_ZhiFuBao) {
        NSString *appScheme = @"AlipayEShiJia";
        NSString* orderInfo = [self getOrderInfo:order];
        NSString* signedStr = [self doRsa:orderInfo];
        
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                 orderInfo, signedStr, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            [self handleAlixPayResult:resultDic];
        }];
    }
    else {
        [UPPayPlugin startPay:tn mode:kMode viewController:[[AppDelegate app] slideNaviController] delegate:(id)self];
    }
}

- (void)getOrderTNWithOrderId:(NSString *)orderId block:(SNServerAPIResultBlock)block
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:orderId forKey:@"id"];
    
    // TODO:
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:params callbackRunInGlobalQueue:YES parser:nil parseMethod:NULL resultBlock:block forKey:URL_AfterBase forPageNameGroup:@"getOrderTN"];
}

- (NSString *)currentOrderId
{
    return objc_getAssociatedObject(self, "CurrentOrderId");
}

- (void)setCurrentOrderId:(NSString *)orderId
{
    objc_setAssociatedObject(self, "CurrentOrderId", orderId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (OrderResultBlock)currentOrderBlock
{
    return objc_getAssociatedObject(self, "CurrentOrderBlock");
}

- (void)setCurrentOrderBlock:(OrderResultBlock)block
{
    objc_setAssociatedObject(self, "CurrentOrderBlock", block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

- (NSString*)getOrderInfo:(CUOrder *)order
{
    AlixPayOrder *payOrder = [[AlixPayOrder alloc] init];
    payOrder.partner = PartnerID;
    payOrder.seller = SellerID;
    payOrder.tradeNO = order.orderNumber;//[NSString stringWithFormat:@"%@",@(order.orderId)]; //订单ID（由商家自行制定）
    payOrder.productName = [NSString stringWithFormat:@"预约 %@医生", order.service.doctor.name]; //商品标题
    payOrder.productDescription = @" "; //商品描述
    payOrder.amount = [NSString stringWithFormat:@"%f",order.dealPrice];//order.showDealPrice;; //商品价格
    NSString *url =  URL_OrderCallBack;
    payOrder.notifyURL = [url URLEncoding]; //回调URL
    
    payOrder.service = @"mobile.securitypay.pay";
    payOrder.paymentType = @"1";
    payOrder.inputCharset = @"utf-8";
    payOrder.itBPay = @"30m";
    payOrder.showUrl = @"m.alipay.com";
    
    return [payOrder description];
}

- (void)handleAlixPayResult:(NSDictionary *)resultDic
{
    NSUInteger resultCode = 0;
    NSNumber *reponseNumber = nil;
    NSError *error = nil;
    
    if ([resultDic isKindOfClass:[NSDictionary class]]) {
        resultCode = [[resultDic valueForKey:@"ResultStatus"] integerValue];
    }
    
    if (resultCode == 9000) {
        reponseNumber = [NSNumber numberWithBool:YES];
    }
    else if (resultCode == 8000) {
        error = [NSError errorWithDomain:@"交易处理中" code:PayStatusCodeHandling userInfo:nil];
    }
    else if (resultCode == 6001) {
        error = [NSError errorWithDomain:@"用户中途取消" code:PayStatusCodeCancel userInfo:nil];
    }
    else {
        error = [NSError errorWithDomain:@"交易失败" code:PayStatusCodeFailed userInfo:nil];
    }
    
    if (self.currentOrderBlock) {
        self.currentOrderBlock(error, reponseNumber);
    }
    
    self.currentOrderId = nil;
    self.currentOrderBlock = nil;
}

- (void)handleAlixPayOpenURL:(NSURL *)url
{
    NSString *temp = [[url query] URLDecoding];
    NSDictionary *memoDic = [temp objectFromJSONString];
    NSDictionary *resultDic = nil;
    if ([memoDic isKindOfClass:[NSDictionary class]]) {
        resultDic = [memoDic valueForKey:@"memo"];
    }
    
    [self handleAlixPayResult:resultDic];
}

- (BOOL)isThirdPayURL:(NSURL *)url
{
    if ([url host] && [[url host] compare:@"safepay"] == 0) {
        return YES;
    }
    
    return NO;
}

- (void)handleThirdPayOpenURL:(NSURL *)url
{
    [self handleAlixPayOpenURL:url];
}

- (void)UPPayPluginResult:(NSString *)result
{
    NSError *error = nil;
    NSNumber *reponseNumber = nil;
    
    if ([result rangeOfString:@"success"].location != NSNotFound) {
        reponseNumber = [NSNumber numberWithBool:YES];
    }
    else if ([result rangeOfString:@"cancel"].location != NSNotFound) {
        error = [NSError errorWithDomain:result code:PayStatusCodeCancel userInfo:nil];
    }
    else {
        error = [NSError errorWithDomain:result code:PayStatusCodeFailed userInfo:nil];
    }
    
    if (self.currentOrderBlock) {
        self.currentOrderBlock(error, reponseNumber);
    }
    
    self.currentOrderId = nil;
    self.currentOrderBlock = nil;
}

@end
