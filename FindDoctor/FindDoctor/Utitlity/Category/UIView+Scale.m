//
//  UIView+Scale.m
//  EShiJia
//
//  Created by zhouzhenhua on 15/6/25.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "UIView+Scale.h"
#import "UIConstants.h"

@implementation UIView (Scale)

CG_INLINE CGRect
CGRectScale(CGRect aRect, CGFloat scale)
{
    CGRect rect;
    rect.origin.x = aRect.origin.x * scale; rect.origin.y = aRect.origin.y * scale;
    rect.size.width = aRect.size.width * scale; rect.size.height = aRect.size.height * scale;
    return rect;
}

- (void)scaleSubviews
{
    for (UIView *v in self.subviews) {
        [v scale];
    }
}

- (void)scale
{
    self.frame = CGRectScale(self.frame, kScreenRatio);
}

@end
