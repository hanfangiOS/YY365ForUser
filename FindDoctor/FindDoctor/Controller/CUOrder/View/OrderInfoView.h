//
//  OrderInfoView.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/24.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUOrder.h"

@interface OrderInfoView : UIView

@property (nonatomic, strong) CUOrder *order;

+ (CGFloat)defaultHeight;

- (void)update;

@end
