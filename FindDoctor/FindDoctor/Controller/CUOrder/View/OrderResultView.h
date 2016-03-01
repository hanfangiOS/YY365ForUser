//
//  OrderResultView.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUOrder.h"

@interface OrderResultView : UIView

@property (nonatomic, strong) CUOrder *order;

- (void)update;

@end
