//
//  UIView+Scale.m
//  BaiduFinance
//
//  Created by zhouzhenhua on 15/6/25.
//  Copyright (c) 2015年 zhouzhenhua. All rights reserved.
//

#import "UIView+Scale.h"
#import "UIConstants.h"

@implementation UIView (Scale)

- (void)scaleSubviews
{
    for (UIView *v in self.subviews) {
        [v scale];
    }
}

- (void)scale
{
    self.frame = CGRectScale(self.frame, kScale_Ratio);
}

- (void)scaleSubviewsWidth
{
    for (UIView *v in self.subviews) {
        [v scaleWidth];
    }
}

- (void)scaleOriginX
{
    CGRect frame = self.frame;
    frame.origin.x = kScaledValue(frame.origin.x);
    self.frame = frame;
}

- (void)scaleOriginY
{
    CGRect frame = self.frame;
    frame.origin.y = kScaledValue(frame.origin.y);
    self.frame = frame;
}

- (void)scaleWidth
{
    CGRect frame = self.frame;
    frame.size.width = kScaledValue(frame.size.width);
    self.frame = frame;
}

- (void)scaleHeight
{
    CGRect frame = self.frame;
    frame.size.height = kScaledValue(frame.size.height);
    self.frame = frame;
}

@end

@implementation UILabel (Scale)

- (void)scale
{
    [super scale];
    
    self.font = [UIFont systemFontOfSize:kScaledRoundValue(self.font.pointSize)];
}

@end

@implementation UIButton (Scale)

- (void)scale
{
    [super scale];
    
    self.titleLabel.font = [UIFont systemFontOfSize:kScaledRoundValue(self.titleLabel.font.pointSize)];
}

@end

@implementation UITextField (Scale)

- (void)scale
{
    [super scale];
    
    self.font = [UIFont systemFontOfSize:kScaledRoundValue(self.font.pointSize)];
}

@end

@implementation UITextView (Scale)

- (void)scale
{
    [super scale];
    
    self.font = [UIFont systemFontOfSize:kScaledRoundValue(self.font.pointSize)];
}

@end
