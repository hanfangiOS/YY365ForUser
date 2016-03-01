//
//  SNLoadMoreControl.m
//  refresh
//
//  Created by nova on 12-11-29.
//  Copyright (c) 2012年 SINA. All rights reserved.
//

#import "SNLoadMoreControl.h"
#import "UIColor+SNExtension.h"

#define kDarkGrayColor     UIColorFromHex(0x5d5d5d)
#define kCommonTitleFontSize      14
#define kTableViewGrayColor      [UIColor colorWithWhite:237.0/255.0 alpha:1.0f]

typedef enum {
    SNLoadMoreControlStatusNormal = 0,
    SNLoadMoreControlStatusLoading = 1,
    SNLoadMoreControlStatusPulling = 2,
} SNLoadMoreControlStatus;

typedef enum {
    SNLoadMoreControlPullingStatusNone = -1,
    SNLoadMoreControlPullingStatusUp = 0,
    SNLoadMoreControlPullingStatusRelease = 1,
} SNLoadMoreControlPullingStatus;

@interface SNLoadMoreControl ()
{
    SNLoadMoreControlStatus  _status;
    SNLoadMoreControlPullingStatus _pullingStatus;
    
    CGFloat _lastOffset;
    BOOL _isDragged;
}

- (void)setOffset:(CGFloat)offset isDragging:(BOOL)isDragging;
- (void)setStatus:(SNLoadMoreControlStatus)status withForce:(BOOL)force;

- (void)pullWithOffset:(CGFloat)offset triggerOffset:(CGFloat)triggerOffset pullingStatus:(SNLoadMoreControlPullingStatus)pullingStatus;

- (void)setPullingDownStatusWithOffset:(CGFloat)offset triggerOffset:(CGFloat)triggerOffset;
- (void)setPullingReleaseStatusWithOffset:(CGFloat)offset triggerOffset:(CGFloat)triggerOffset;
- (void)setPullingNoneStatusWithOffset:(CGFloat)offset triggerOffset:(CGFloat)triggerOffset;

@end

@implementation SNLoadMoreControl

@synthesize indicatorView = _indicatorView;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver];
    
    [_indicatorView release];
    
    [super dealloc];
}

- (void)removeObserver
{
    if (_tableView) {
        [_tableView removeObserver:self forKeyPath:@"contentOffset"];
        [_tableView release], _tableView = nil;
    }
}

- (id)initWithFrame:(CGRect)frame attachedView:(UITableView *)tableView
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = kTableViewGrayColor;
        
        _status = SNLoadMoreControlStatusNormal;
        _pullingStatus = SNLoadMoreControlPullingStatusNone;
        _lastOffset = 0.0;
        _isDragged = NO;
        self.originalBottomInset = tableView.contentInset.bottom;
        
        _tableView = [tableView retain];
        [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
        
        self.titleLabel.font = [UIFont systemFontOfSize:kCommonTitleFontSize];
        [self setTitle:NSLocalizedStringFromTable(@"Pull up to load...", @"SNLoadMoreControl", nil) forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
        _indicatorView.hidesWhenStopped = YES;
        [_indicatorView stopAnimating];
        _indicatorView.center = CGPointMake(100, CGRectGetMidY(self.bounds));
        [self addSubview:_indicatorView];
        
        [self reloadUIElements];
    }
    
    return self;
}

- (void)reloadUIElements
{
    [self setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
}

- (void)setActivityIndicatorViewXPosition:(CGFloat)xPos
{
    CGPoint center = _indicatorView.center;
    center.x = xPos;
    _indicatorView.center = center;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (controlEvents == UIControlEventValueChanged) {
        [super addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [super addTarget:target action:action forControlEvents:controlEvents];
    }
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if (event) {
        if (_status == SNLoadMoreControlStatusLoading) {
            return;
        }
        
        [self setStatus:SNLoadMoreControlStatusLoading withForce:YES];
        [super sendAction:action to:target forEvent:event];
    }
    else {
        [super sendAction:action to:target forEvent:event];
    }
}

- (void)beginLoading
{
    if (_status == SNLoadMoreControlStatusLoading) {
        return;
    }
    
    [self setStatus:SNLoadMoreControlStatusLoading withForce:YES];
}

- (void)endLoading
{
    if (_status == SNLoadMoreControlStatusNormal) {
        return;
    }
    
    [self setStatus:SNLoadMoreControlStatusNormal withForce:YES];
}

- (void)setOffset:(CGFloat)offset isDragging:(BOOL)isDragging
{
    CGFloat triggerOffset = kTriggerOffset;
    CGFloat adjustedOffset = offset - self.originalBottomInset;
    CGFloat lastAdjustOffset = _lastOffset - self.originalBottomInset;
    if (_tableView.contentSize.height > CGRectGetHeight(_tableView.bounds)) {
        adjustedOffset += CGRectGetHeight(_tableView.bounds);
        lastAdjustOffset += CGRectGetHeight(_tableView.bounds);
        triggerOffset += _tableView.contentSize.height;
    }
    
    if (adjustedOffset <= triggerOffset && lastAdjustOffset <= triggerOffset) {
        _isDragged = NO;
        _lastOffset = 0.0;
        
        [self setStatus:SNLoadMoreControlStatusNormal withForce:NO];
        return;
    }
    
    if (isDragging)
    {
        _lastOffset = offset;
        _isDragged = YES;
        [self setStatus:SNLoadMoreControlStatusPulling withForce:NO];
        
        if (adjustedOffset >= triggerOffset) {
            [self pullWithOffset:(adjustedOffset-triggerOffset+kTriggerOffset) triggerOffset:kTriggerOffset pullingStatus:SNLoadMoreControlPullingStatusRelease];
        }
        else {
            [self pullWithOffset:(adjustedOffset-triggerOffset+kTriggerOffset) triggerOffset:kTriggerOffset pullingStatus:SNLoadMoreControlPullingStatusUp];
        }
    }
    else if (_isDragged)
    {
        if (lastAdjustOffset > triggerOffset)
        {
            [self setStatus:SNLoadMoreControlStatusLoading withForce:NO];
        }
        else
        {
            [self setStatus:SNLoadMoreControlStatusNormal withForce:NO];
        }
        _lastOffset = 0.0;
        _isDragged = NO;
    }
    else {
        [self setStatus:SNLoadMoreControlStatusNormal withForce:NO];
    }
}

- (void)setStatus:(SNLoadMoreControlStatus)status withForce:(BOOL)force
{
    if ((_status == status || _status == SNLoadMoreControlStatusLoading) && !force) {
        return;
    }
    
    _status = status;
    switch (_status) {
        case SNLoadMoreControlStatusNormal:
        {
            [self setTitle:NSLocalizedStringFromTable(@"Pull up to load...", @"SNLoadMoreControl", nil) forState:UIControlStateNormal];
            [_indicatorView stopAnimating];
        }
            break;
            
        case SNLoadMoreControlStatusLoading:
        {
            [self setTitle:NSLocalizedStringFromTable(@"Loading...", @"SNLoadMoreControl", nil) forState:UIControlStateNormal];
            [_indicatorView startAnimating];
            
            if (!force) {
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)pullWithOffset:(CGFloat)offset triggerOffset:(CGFloat)triggerOffset pullingStatus:(SNLoadMoreControlPullingStatus)pullingStatus
{
    if (_status != SNLoadMoreControlStatusPulling) {
        return;
    }
    
    switch (pullingStatus) {
        case SNLoadMoreControlPullingStatusUp:
            [self setTitle:NSLocalizedStringFromTable(@"Pull up to load...", @"SNLoadMoreControl", nil) forState:UIControlStateNormal];
            [self setPullingDownStatusWithOffset:offset triggerOffset:triggerOffset];
            break;
            
        case SNLoadMoreControlPullingStatusRelease:
            [self setTitle:NSLocalizedStringFromTable(@"Release to load...", @"SNLoadMoreControl", nil) forState:UIControlStateNormal];
            [self setPullingReleaseStatusWithOffset:offset triggerOffset:triggerOffset];
            break;
            
        case SNLoadMoreControlPullingStatusNone:
            [self setTitle:NSLocalizedStringFromTable(@"Pull up to load...", @"SNLoadMoreControl", nil) forState:UIControlStateNormal];
            [self setPullingNoneStatusWithOffset:offset triggerOffset:triggerOffset];
            break;
            
        default:
            break;
    }
    
    _pullingStatus = pullingStatus;
}

- (void)setPullingDownStatusWithOffset:(CGFloat)offset triggerOffset:(CGFloat)triggerOffset
{
    
}

- (void)setPullingReleaseStatusWithOffset:(CGFloat)offset triggerOffset:(CGFloat)triggerOffset
{

}

- (void)setPullingNoneStatusWithOffset:(CGFloat)offset triggerOffset:(CGFloat)triggerOffset
{

}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"] && _status != SNLoadMoreControlStatusLoading && self.superview) {
        CGFloat newOffset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y;
        [self setOffset:newOffset isDragging:_tableView.isDragging];
    }
}

@end
