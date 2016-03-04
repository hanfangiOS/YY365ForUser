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
    ORDERSTATUS_NONE     = -1,
    ORDERSTATUS_ALL      = 0,
    ORDERSTATUS_UNPAID   = 1, // 未支付
    ORDERSTATUS_PAID     = 2, // 待服务、已支付
    ORDERSTATUS_FINISHED = 3, // 已完成
    ORDERSTATUS_CANCELED = 4, // 已取消
    ORDERSTATUS_REFUNDED = 5, // 已退款
}OrderStatus;

typedef enum OrderPayment : NSInteger
{
    ORDERPAYMENT_ZhiFuBao = 1,  // 支付宝
    ORDERPAYMENT_WeiXin   = 2,  // 微信
    ORDERPAYMENT_YinLian  = 3   // 银联
}OrderPayment;

@interface CUOrder : NSObject

@property long long diagnosisID;
@property (nonatomic,strong) NSString *diagnosisTime;  //就诊时间区间，支付成功回调用到
@property (nonatomic,strong) NSString *orderId;
@property (nonatomic,strong) NSString *orderNumber; //预约号
@property (nonatomic,assign) OrderStatus orderStatus;
@property (nonatomic,assign) OrderPayment payment;
//@property (nonatomic,strong) NSString * showDealPrice;// 价格展示使用
@property long long dealPrice;
@property (nonatomic,strong) CUService *service;
//@property (nonatomic,strong) NSString * remark;//备注
//@property (nonatomic,assign) NSInteger serviceCount;
@property (nonatomic,assign) BOOL isComment;

@property NSTimeInterval createTimeStamp;
@property NSTimeInterval finishedTimeStamp;
@property NSTimeInterval submitTime;

@property NSInteger obtainScore; //获得积分
@property NSInteger obtainCouponMoney; //获得诊金券金额

@property NSInteger state;

- (NSString *)orderStatusStr;
- (BOOL)shouldRequireDetail;
- (BOOL)hasDiseaseImage;

- (NSString *)userDesc;
- (NSString *)doctorDesc;
- (NSString *)queueNumberDesc;
- (NSString *)dealPriceDesc;

- (NSString *)createTime;
- (NSString *)finishedTime;

@end
