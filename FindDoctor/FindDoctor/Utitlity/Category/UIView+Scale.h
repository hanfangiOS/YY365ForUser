//
//  UIView+Scale.h
//  EShiJia
//
//  Created by zhouzhenhua on 15/6/25.
//  Copyright (c) 2015年 li na. All rights reserved.
//
// 屏幕自适应，自动适配6和6 plus

#import <UIKit/UIKit.h>

@interface UIView (Scale)

- (void)scaleSubviews; // include self
- (void)scale;

@end
