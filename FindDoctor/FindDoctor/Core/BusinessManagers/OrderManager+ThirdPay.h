//
//  OrderManager+ThirdPay.h
//  CollegeUnion
//
//  Created by li na on 15/3/17.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUOrderManager.h"

typedef enum : NSUInteger {
    PayStatusCodeSuccess,
    PayStatusCodeFailed,
    PayStatusCodeCancel,
    PayStatusCodeHandling
} PayStatusCode;

typedef void (^OrderResultBlock)(NSError *error, id responseObject);

@interface CUOrderManager (AliPay)

- (void)payOrder:(CUOrder *)order tn:(NSString *)tn block:(OrderResultBlock)block;

- (void)getOrderTNWithOrderId:(NSString *)orderId block:(SNServerAPIResultBlock)block;

- (BOOL)isThirdPayURL:(NSURL *)url;
- (void)handleThirdPayOpenURL:(NSURL *)url;

@end
