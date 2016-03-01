//
//  OrderDetailView.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/29.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUOrder.h"

@interface OrderDetailView : UIView

@property (nonatomic, strong) CUOrder *order;

- (CGFloat)calculateViewHeight;

@end
