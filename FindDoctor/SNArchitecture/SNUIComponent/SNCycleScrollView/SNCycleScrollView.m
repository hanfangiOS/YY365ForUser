//
//  LHTableHeaderView.m
//  LeHe
//
//  Created by yutao on 14-6-11.
//  Copyright (c) 2014年 lehe. All rights reserved.
//

#import "SNCycleScrollView.h"
#import "UIConstants.h"

#import "SNFocusImageView.h"
#import "SNFocusImageItem.h"

#define kBaseTag    100


@implementation SNCycleScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];
        
        UIView *bottmoView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 30, frame.size.width, 30)];
        bottmoView.backgroundColor = [UIColor clearColor];
        [self addSubview:bottmoView];

        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, frame.size.width - 80, 30)];
        _titleLable.textColor = [UIColor whiteColor];
        _titleLable.font = [UIFont systemFontOfSize:13];
        _titleLable.text = @"";
        _titleLable.backgroundColor = [UIColor clearColor];
        //[bottmoView addSubview:_titleLable];
        
        //CGRect rect = CGRectMake(CGRectGetMaxX(_titleLable.frame)+20, 0, frame.size.width - CGRectGetMaxX(_titleLable.frame) - 30, 30);
        self.pageControl = [[DDPageControl alloc] init];
        [_pageControl setCenter: CGPointMake(CGRectGetMidX(bottmoView.bounds), CGRectGetMidY(bottmoView.bounds))] ;
        [_pageControl setNumberOfPages: 0] ;
        [_pageControl setCurrentPage: 0] ;
        [_pageControl setHidesForSinglePage:YES];
        [_pageControl setDefersCurrentPageDisplay: YES] ;
        [_pageControl setType: DDPageControlTypeOnFullOffFull] ;
//        [_pageControl setOnColor:  kDarkBlueColor] ;
//        [_pageControl setOffColor: kLightGrayColor] ;
        [_pageControl setIndicatorDiameter: 3.0f] ;
        [_pageControl setIndicatorSpace: 6.0f] ;
        
        [bottmoView addSubview:_pageControl];
        
        _curPage = 0;
    }
    return self;
}

- (void)setDataource:(id<SNCycleScrollViewDatasource>)datasource
{
    _datasource = datasource;
    [self reloadData];
    
}

- (void)reloadData
{
    SNFocusImageView *imageView = (SNFocusImageView *)[_datasource pageAtIndex:_curPage];
    SNFocusImageItem *item = imageView.imageItem;
    _titleLable.text = item.title;
    
    _totalPages = [_datasource numberOfPages];
    if (_totalPages == 0) {
        _scrollView.scrollEnabled = NO;
        return;
    }
    
    _scrollView.scrollEnabled = YES;
    _pageControl.numberOfPages = _totalPages;
    [self loadData];
}

- (void)loadData
{
    
    _pageControl.currentPage = _curPage;
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [_scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:_curPage];
    
    for (int i = 0; i < 3; i++) {
        UIView *v = [_curViews objectAtIndex:i];
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [v addGestureRecognizer:singleTap];
        v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
        [_scrollView addSubview:v];
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

- (void)getDisplayImagesWithCurpage:(int)page {
    
    int pre = [self validPageValue:_curPage-1];
    int last = [self validPageValue:_curPage+1];
    
    if (!_curViews) {
        _curViews = [[NSMutableArray alloc] init];
    }
    
    [_curViews removeAllObjects];
    
    [_curViews addObject:[_datasource pageAtIndex:pre]];
    [_curViews addObject:[_datasource pageAtIndex:page]];
    [_curViews addObject:[_datasource pageAtIndex:last]];
}

- (int)validPageValue:(NSInteger)value {
    
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    
    return value;
    
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [_delegate didClickPage:self atIndex:_curPage];
    }
    
}

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
{
    if (index == _curPage) {
        [_curViews replaceObjectAtIndex:1 withObject:view];
        for (int i = 0; i < 3; i++) {
            UIView *v = [_curViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTap:)];
            [v addGestureRecognizer:singleTap];
            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
            [_scrollView addSubview:v];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        _curPage = [self validPageValue:_curPage+1];
        [self loadData];
    }
    
    //往上翻
    if(x <= 0) {
        _curPage = [self validPageValue:_curPage-1];
        [self loadData];
    }
    
    _pageControl.currentPage = _curPage ;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
    [_pageControl updateCurrentPageDisplay] ;
    
    SNFocusImageView *imageView = (SNFocusImageView *)[_datasource pageAtIndex:_curPage];
    SNFocusImageItem *item = imageView.imageItem;
    _titleLable.text = item.title;
    
}

@end
