//
//  SNRefreshControl.h
//  refresh
//
//  Created by nova on 12-11-19.
//  Copyright (c) 2012年 SINA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define SN_RELEASE_REFRESH_SAFELY(__POINTER) {if(__POINTER){[__POINTER removeObserver];[__POINTER release];__POINTER=nil;}}

#define kArrowImageName        @"common_refresh_arrow.png"
#define kRefreshImageName      @"refresh.png"
#define kTableViewGrayColor      [UIColor colorWithWhite:237.0/255.0 alpha:1.0f]
#define kCommonBackgroundColor    UIColorFromRGB(248,248,248)

typedef enum {
    SNRefreshControlStyleNormal = 0,
    SNRefreshControlStyleArrow = 1,
    SNRefreshControlStyleDrop = 2,
    SNRefreshControlStyleActivity = 3,
    SNRefreshControlStyleCustom = 4,
    
    // SNRefreshControlStyleBottomOffset和SNRefreshControlStyleArrow一样，区别底部增加40的间距
    SNRefreshControlStyleBottomOffset = 5,
} SNRefreshControlStyle;

@interface SNRefreshControl : UIControl
{
    UILabel      *_titleLabel;
    UILabel      *_timeLabel;
    UIView       *_backgroundView;
    UIView       *_bottomShadowView;
    
    UIScrollView *_scrollView;
    
    SNRefreshControlStyle     _style;
}

@property (nonatomic, retain)   UIView  *backgroundView;
@property (nonatomic, retain)   UIView  *bottomShadowView;

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *timeLabel;
@property (nonatomic, readonly) SNRefreshControlStyle style;

@property (nonatomic, retain)  NSDate * lastFreshDate;

+ (id)refreshControlWithAttachedView:(UIScrollView *)scrollView style:(SNRefreshControlStyle)style;
- (void)removeObserver;

- (void)beginRefreshing;
- (void)endRefreshing;

- (void)refreshLastUpdatedTime:(NSDate *)date;

/**
 * Only availiable for SNRefreshControlStyleArrow
 */
- (void)setArrowWithImageName:(NSString *)arrowImageName;

/**
 * Only availiable for SNRefreshControlStyleDrop
 */
- (void)setBorderColor:(UIColor *)color;
- (void)setBorderWidth:(CGFloat)width;
- (void)setTintColor:(UIColor *)color;

@end
