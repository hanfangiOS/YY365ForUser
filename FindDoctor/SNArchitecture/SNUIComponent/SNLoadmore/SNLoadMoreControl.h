//
//  SNLoadMoreControl.h
//  refresh
//
//  Created by nova on 12-11-29.
//  Copyright (c) 2012年 SINA. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SN_RELEASE_LOADMORE_SAFELY(__POINTER) {if(__POINTER){[__POINTER removeObserver];[__POINTER release];__POINTER=nil;}}

#define kTriggerOffset   20.0

@interface SNLoadMoreControl : UIButton
{
    UIActivityIndicatorView *_indicatorView;
    
    UITableView *_tableView;
}

@property (nonatomic, retain) UIActivityIndicatorView *indicatorView;
@property (nonatomic, assign) CGFloat originalBottomInset;

- (id)initWithFrame:(CGRect)frame attachedView:(UITableView *)tableView;
- (void)removeObserver;

- (void)setActivityIndicatorViewXPosition:(CGFloat)xPos;

- (void)beginLoading;
- (void)endLoading;

@end
