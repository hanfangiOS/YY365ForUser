//
//  CUOrder.h
//  CollegeUnion
//
//  Created by li na on 15/2/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CUService.h"

typedef enum OrderStatus: NSInteger
{
    ORDERSTATUS_UNPAID   = 0, // 未支付
    ORDERSTATUS_PAID     = 1, // 已支付,没看病
    ORDERSTATUS_FINISHED = 2, // 已诊疗
    ORDERSTATUS_COMMENT  = 3, // 已评论
//    ORDERSTATUS_REFUNDED = 5, // 已
}OrderStatus;

typedef enum OrderPayment : NSInteger
{
    ORDERPAYMENT_ZhiFuBao = 1,  // 支付宝
    ORDERPAYMENT_WeiXin   = 2,  // 微信
    ORDERPAYMENT_YinLian  = 3   // 银联
}OrderPayment;

@interface CUOrder : NSObject

@property long long diagnosisID;

@property (nonatomic,strong) NSString *orderId;
@property (nonatomic,strong) NSString *orderNumber; //预约号
@property (nonatomic,assign) OrderStatus orderStatus;
@property (nonatomic,assign) OrderPayment payment;
//@property (nonatomic,strong) NSString * showDealPrice;// 价格展示使用
@property long long dealPrice;//最后交易的价格（考虑了诊金券等）
@property long long coupon;//诊金券
@property (nonatomic,strong) CUService *service;
//@property (nonatomic,strong) NSString * remark;//备注
//@property (nonatomic,assign) NSInteger serviceCount;
@property (nonatomic,assign) BOOL isComment;

@property NSTimeInterval createTimeStamp;
@property (nonatomic,strong)NSString * createTimeStampStr;
@property (nonatomic,strong) NSString *diagnosisTime;  //就诊时间区间，支付成功回调用到,createTimeStamp转换为字符串
@property NSTimeInterval finishedTimeStamp;
@property NSTimeInterval submitTime;  //提交时间的时间戳
@property (nonatomic,strong)NSString * submitTimeStr;
@property (nonatomic,strong) NSString *submitTimeString;   //提交时间的时间戳转换为的字符串

@property NSInteger obtainScore; //获得积分
@property NSInteger obtainCouponMoney; //获得诊金券金额
@property (nonatomic,strong) NSString * lefttime;//订单倒计时


@property NSInteger state;

- (NSString *)orderStatusStr;
- (NSString *)orderPaymentStr;
- (BOOL)shouldRequireDetail;
- (BOOL)hasDiseaseImage;

- (NSString *)userDesc;
- (NSString *)doctorDesc;
- (NSString *)queueNumberDesc;
- (NSString *)dealPriceDesc;

- (NSString *)createTime;
- (NSString *)finishedTime;

@end

@interface OrderFilter : HFFilter

@property (strong,nonatomic)CUUser          * user;
@property (assign,nonatomic)OrderStatus       orderStatus;
@property (assign,nonatomic)NSInteger         pageNum;
@property long long diagnosisID;

@end
