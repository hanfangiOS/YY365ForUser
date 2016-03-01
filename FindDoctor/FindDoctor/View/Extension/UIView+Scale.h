//
//  UIView+Scale.h
//  BaiduFinance
//
//  Created by zhouzhenhua on 15/6/25.
//  Copyright (c) 2015年 zhouzhenhua. All rights reserved.
//
// 屏幕自适应，自动适配6和6 plus

#import <UIKit/UIKit.h>

#define kScale_Ratio    ([UIScreen mainScreen].bounds.size.width / 320.0)
#define kScaledValue(x) (ceilf((x) * kScale_Ratio))

#define kScaledRoundValue(x) (round((x) * kScale_Ratio))  // 用于字号取整，round四舍五入

@interface UIView (Scale)

- (void)scaleSubviews; // not include self
- (void)scale;

- (void)scaleSubviewsWidth; // only scale size.width, not include self

- (void)scaleOriginX;
- (void)scaleOriginY;
- (void)scaleWidth;
- (void)scaleHeight;

@end

CG_INLINE CGRect
CGRectScale(CGRect aRect, CGFloat scale)
{
    CGRect rect;
    rect.origin.x = ceilf(aRect.origin.x * scale);
    rect.origin.y = ceilf(aRect.origin.y * scale);
    rect.size.width = ceilf(aRect.size.width * scale);
    rect.size.height = ceilf(aRect.size.height * scale);
    return rect;
}

CG_INLINE CGRect
CGRectAutoScale(CGRect aRect)
{
    return CGRectScale(aRect, kScale_Ratio);
}

@interface UILabel (Scale)

- (void)scale;

@end

@interface UIButton (Scale)

- (void)scale;

@end

@interface UITextField (Scale)

- (void)scale;

@end

@interface UITextView (Scale)

- (void)scale;

@end
