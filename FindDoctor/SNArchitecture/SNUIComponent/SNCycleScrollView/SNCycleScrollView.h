//
//  SNCycleScrollView.h
//  LeHe
//
//  Created by yutao on 14-6-11.
//  Copyright (c) 2014年 lehe. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDPageControl.h"

@protocol SNCycleScrollViewDelegate;
@protocol SNCycleScrollViewDatasource;

@interface SNCycleScrollView : UIView <UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    NSInteger _totalPages;
    NSInteger _curPage;
    
    NSMutableArray *_curViews;
}

@property (nonatomic,strong)DDPageControl *pageControl;
@property (nonatomic,strong)UILabel       *titleLable;
@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,weak,setter = setDataource:) id<SNCycleScrollViewDatasource> datasource;
@property (nonatomic,weak,setter = setDelegate:) id<SNCycleScrollViewDelegate> delegate;

- (void)reloadData;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;

@end


@protocol SNCycleScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(SNCycleScrollView *)csView atIndex:(NSInteger)index;

@end

@protocol SNCycleScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;

@end
