//
//  CUJobListModel.h
//  CollegeUnion
//
//  Created by li na on 15/3/7.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "SNBaseListModel.h"
#import "CUOrder.h"

@interface CUOrderListModel : SNBaseListModel

@property (nonatomic,assign)OrderStatus status;
- (instancetype)initWithOrderStatus:(OrderStatus)status;
//- (BOOL)hasNext;

- (void)gotoFirstPage:(SNServerAPIResultBlock)resultBlock;
- (void)gotoNextPage:(SNServerAPIResultBlock)resultBlock;


@end
