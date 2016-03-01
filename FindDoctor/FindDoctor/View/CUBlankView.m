//
//  CUBlankView.m
//  EShiJia
//
//  Created by zhouzhenhua on 15/6/26.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUBlankView.h"
#import "UIConstants.h"

@implementation CUBlankView
{
    UIView      *backgroundView;
    UILabel     *loadingLabel;
}

- (void)dealloc
{
    [self unregisterFromKVO];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self registerForKVO];
        [self initSubviews];
    }
    return self;
}

- (id)initWithView:(UIView *)view {
    return [self initWithFrame:view.bounds];
}

- (id)initWithWindow:(UIWindow *)window {
    return [self initWithView:window];
}

- (void)initSubviews
{
    backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.frame = self.bounds;
    [self addSubview:backgroundView];
    
    CGFloat labelWidth = 236.0;
    CGFloat labelHeight = 30.0;
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(backgroundView.bounds) - labelWidth) / 2, (CGRectGetHeight(backgroundView.bounds) - labelHeight ) / 2, labelWidth, labelHeight)];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.font = [UIFont systemFontOfSize:18];
    loadingLabel.textColor = kDarkGrayColor;
    [backgroundView addSubview:loadingLabel];
}

+ (CUBlankView *)showBlankViewAddedTo:(UIView *)view
{
    return [self showBlankViewAddedTo:view text:@"暂无数据"];
}

+ (CUBlankView *)showBlankViewAddedTo:(UIView *)view text:(NSString *)text
{
    if (view == nil) {
        return nil;
    }
    
    // 确保只有一个
    [self hideAllBlankViewForView:view];
    
    CUBlankView *blankView = [[CUBlankView alloc] initWithView:view];
    [view addSubview:blankView];
    
    blankView.labelText = text;
    return blankView;
}

+ (BOOL)hideAllBlankViewForView:(UIView *)view
{
    NSArray *views = [self allBlankViewsForView:view];
    for (UIView *v in views) {
        [v removeFromSuperview];
    }
    
    return [views count];
}

+ (NSArray *)allBlankViewsForView:(UIView *)view {
    NSMutableArray *huds = [NSMutableArray array];
    NSArray *subviews = view.subviews;
    Class hudClass = [CUBlankView class];
    for (UIView *view in subviews) {
        if ([view isKindOfClass:hudClass]) {
            [huds addObject:view];
        }
    }
    return [NSArray arrayWithArray:huds];
}

#pragma mark - KVO

- (void)registerForKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)unregisterFromKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (NSArray *)observableKeypaths {
    return [NSArray arrayWithObjects:@"labelText", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
    } else {
        [self updateUIForKeypath:keyPath];
    }
}

- (void)updateUIForKeypath:(NSString *)keyPath {
    if ([keyPath isEqualToString:@"labelText"]) {
        loadingLabel.text = self.labelText;
    }
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

@end
