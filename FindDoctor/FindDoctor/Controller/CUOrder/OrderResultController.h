//
//  OrderResultController.h
//  CommentTest
//
//  Created by zhouzhenhua on 14-9-11.
//  Copyright (c) 2014年 zhouzhenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUOrder.h"
#import "CUViewController.h"

typedef enum : NSUInteger {
    OrderResultSuccess,
    OrderResultFailed,
} OrderResult;

@interface OrderResultController : CUViewController

@property (nonatomic, strong) CUOrder *order;
@property OrderResult orderResult;

@end
