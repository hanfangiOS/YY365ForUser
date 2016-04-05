//
//  HFBanner.h
//  HFBanner
//
//  Created by 晓炜 郭 on 16/3/31.
//  Copyright © 2016年 晓炜 郭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFPageControl.h"
#import "HFBannerViewCell.h"

@class HFBannerView;

@protocol HFBannerViewDataSource <NSObject>
@required
- (NSInteger)numberOfCellInView:(HFBannerView *)view;
- (HFBannerViewCell *)HFBannerView:(HFBannerView *)view cellForIndex:(NSInteger)index;
@end

@protocol HFBannerViewDelegate <NSObject>
@optional
- (void)HFBannerView:(HFBannerView *)view didSelectAtIndex:(NSInteger)index;

@end


@interface HFBannerView : UIView <UIScrollViewDelegate>

@property (nonatomic, retain) id <HFBannerViewDataSource> dataSource;
@property (nonatomic, retain) id <HFBannerViewDelegate> delegate;

@property (strong,nonatomic) HFPageControl      *pageControl;  //pageControl，可自定义小圆点样式
@property NSInteger                             currentPage;
@property BOOL                                  hasPageControl;  //是否需要小圆点，默认YES
@property BOOL                                  autoScroll;  //是否要自动播放，默认YES
@property (assign,nonatomic) float              scrollTime;           //滚动间隔，默认5
@property (assign,nonatomic) float              switchTimeInterval;   //滚动动画时间，默认0.75

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)reloadData;

@end



