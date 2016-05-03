//
//  OrderConfirmController.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/24.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUViewController.h"
#import "CUOrder.h"

@interface OrderConfirmController : CUViewController

@property (nonatomic, strong) CUOrder * order;

@property(nonatomic, retain)NSString *channel;

@end
