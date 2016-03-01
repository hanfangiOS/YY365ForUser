//
//  OrderCellContentView.h
//  EShiJia
//
//  Created by zhouzhenhua on 15-4-24.
//  Copyright (c) 2015年 zhouzhenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellContentView.h"
#import "CUOrder.h"
#import "CellDisplayInfo.h"

@class OrderDisplayInfo;

typedef void(^OrderCellContentViewAction)(void);

@interface OrderCellContentView : UIView

@property (nonatomic, strong) CUOrder *data;

@property (nonatomic, copy) OrderCellContentViewAction clickAction;

@end
