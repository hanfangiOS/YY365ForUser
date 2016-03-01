//
//  CUOrderParser.h
//  CollegeUnion
//
//  Created by li na on 15/2/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUServerAPIDataBaseParser.h"
#import "CUOrder.h"

@interface CUOrderParser : CUServerAPIDataBaseParser


- (CUOrder *)parseSubmitOrderWithDict:(NSDictionary *)dict;
- (id)parseCancelOrderWithDict:(NSDictionary *)dict;
- (id)parseUpdateOrderWithDict:(NSDictionary *)dict;
- (SNBaseListModel *)parseGetOrderListWithDict:(NSDictionary *)dict;
- (CUOrder *)parseGetOrderDetailWithDict:(NSDictionary *)dict;

@end
