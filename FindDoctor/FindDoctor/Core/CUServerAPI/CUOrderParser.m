//
//  CUOrderParser.m
//  CollegeUnion
//
//  Created by li na on 15/2/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUOrderParser.h"
#import "CUServerAPIConstant.h"

@implementation CUOrderParser

- (CUOrder *)parseOrderWithDict:(NSDictionary *)data
{
    CUOrder * order = [[CUOrder alloc] init];
    order.diagnosisID = [[data objectForKeySafely:@"id"] longLongValue];
    order.orderNumber = [data objectForKeySafely:@"sn"];
    order.createTimeStamp = [[data objectForKeySafely:@"createdDate"] integerValue];
    order.finishedTimeStamp = [[data objectForKeySafely:@"completeDate"] integerValue];
    order.orderStatus = [[data objectForKeySafely:@"status"] integerValue];
    order.dealPrice = [[data objectForKeySafely:@"price"] floatValue];
    
    return order;
}

- (CUOrder *)parseSubmitOrderWithDict:(NSDictionary *)dict
{
    CUOrder * order = nil;
    NSDictionary * data = [self parseBaseDataWithDict:dict];
    if (!self.hasError)
    {
        order = [self parseOrderWithDict:data];
    }
    return order;
}

- (id)parseUpdateOrderWithDict:(NSDictionary *)dict
{
    [self parseBaseDataWithDict:dict];
    return nil;
}

- (id)parseCancelOrderWithDict:(NSDictionary *)dict
{
    [self parseBaseDataWithDict:dict];
    return nil;
}
- (SNBaseListModel *)parseGetOrderListWithDict:(NSDictionary *)dict
{
    SNBaseListModel * lists = nil;
    NSDictionary * data = [self parseBaseDataWithDict:dict];
    if (!self.hasError)
    {
        lists = [[SNBaseListModel alloc] init];
        lists.pageInfo = [self parsePageInfoWithDict:data];
        [[data objectForKeySafely:@"list"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            
            [lists.items addObjectSafely:[self parseOrderWithDict:obj]];
            
        }];
    }
    return lists;
}
- (CUOrder *)parseGetOrderDetailWithDict:(NSDictionary *)dict
{
    CUOrder * order = nil;
    NSDictionary * data = [self parseBaseDataWithDict:dict];
    if (!self.hasError)
    {
        order = [self parseOrderWithDict:data];
    }
    return order;
}

@end
