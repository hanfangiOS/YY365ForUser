//
//  CUOrderManager.h
//  CollegeUnion
//
//  Created by li na on 15/2/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNBusinessMananger.h"
#import "SNServerAPIDefine.h"
#import "CUUser.h"
#import "CUOrder.h"

@interface CUOrderManager : SNBusinessMananger

SINGLETON_DECLARE(CUOrderManager);

@end

@interface CUOrderManager (Network)

//提交订单前获取成员列表
- (void)getMemberListWithDiagnosisID:(long long)diagnosisID releaseID:(long long)releaseID orderID:(NSInteger)orderID resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//返回时间列表
- (void)ReturnSelectOrderTimeWithDiagnosisID:(long long)diagnosisID resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 提交订单
- (void)submitOrder:(CUOrder *)order user:(CUUser *)user resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 更新订单状态
- (void)updateOrder:(CUOrder *)order status:(OrderStatus)status user:(CUUser *)user resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 取消订单
- (void)cancelOrder:(CUOrder *)order user:(CUUser *)user resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 获取订单列表
- (void)getOrderListWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize user:(CUUser *)user searchedWithOrderStatus:(OrderStatus)orderStatus resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 获取订单详情
- (void)getOrderDetailWithOrderId:(long long *)orderId user:(CUUser *)user resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//首页推送
- (void)getHomeTipListWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 用户端——13103接口-用户空间-我的记录
- (void)getMyDiagnosisRecordsWithUser:(MyDiagnosisRecordsFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 用户端 - 用户空间 - 我的账户
- (void)getMyAccountWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;


// 取消订单
- (void)CancelOrderWithDiagnosisID:(long long)diagnosisID resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//检测订单是否被支付
- (void)CheckOrderHasPaidWithDiagnosisID:(long long)diagnosisID resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//成功支付后获取订单状态
- (void)getOrderStateWithDiagnosisID:(long long)diagnosisID andChargeid:(NSString *)chargeid andDynamicno:(long long)dynamicno resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//没付款记录
- (void)getOrderNotPayListWithFilter:(OrderFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//付款没看病记录
- (void)getOrderHasPayNotMeetListWithFilter:(OrderFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//看病了的记录
- (void)getOrderHasPayHasMeetListWithFilter:(OrderFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//没付钱订单详情
- (void)getOrderNotPayDetailWithFilter:(OrderFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//付钱还没看病订单详情
- (void)getOrderHasPayNotMeetDetailWithFilter:(OrderFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//付钱看病了订单详情
- (void)getOrderHasPayHasMeetDetailWithFilter:(OrderFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;


@end