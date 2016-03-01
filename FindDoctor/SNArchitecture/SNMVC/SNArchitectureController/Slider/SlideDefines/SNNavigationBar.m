//
//  SNNavigationBar.m
//  TestNavigation
//
//  Created by nova  on 12-12-28.
//  Copyright (c) 2012年. All rights reserved.
//

#import "SNNavigationBar.h"
#import "UIImage+Stretch.h"
#import "SNSlideDefines.h"
#import "UINavigationBar+Background.h"
#import "SNUISystemConstant.h"

#define kNavigationShadowHeight    3

@implementation SNNavigationBar

- (void)dealloc
{
    [_shadowImageView release], _shadowImageView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        touchBounds = self.bounds;
        
        if ([self respondsToSelector:@selector(setShadowImage:)]) {
            [self setShadowImage:[[[UIImage alloc] init] autorelease]];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIView *subview = [self viewWithTag:kNavigationItemAlignment_HL_VC];
    if (subview) {
        CGRect frame = subview.frame;
        frame.origin.x = 0;
        frame.origin.y = (CGRectGetHeight(self.bounds)-CGRectGetHeight(frame))*0.5 + kDefaultNavigationDelY;
        subview.frame = frame;
    }
    
    subview = [self viewWithTag:kNavigationItemAlignment_HR_VC];
    if (subview) {
        CGRect frame = subview.frame;
        frame.origin.x = CGRectGetWidth(self.bounds)-CGRectGetWidth(frame);
        frame.origin.y = (CGRectGetHeight(self.bounds)-CGRectGetHeight(frame))*0.5 + kDefaultNavigationDelY;
        subview.frame = frame;
    }
    
    subview = [self viewWithTag:kNavigationItemAlignment_HC_VC];
    if (subview) {
        CGRect frame = subview.frame;
        frame.origin.x = (CGRectGetWidth(self.bounds)-CGRectGetWidth(frame))*0.5;
        frame.origin.y = (CGRectGetHeight(self.bounds)-CGRectGetHeight(frame))*0.5 + kDefaultNavigationDelY;
        subview.frame = frame;
    }
    
    if (_shadowImageView && _shadowImageView.superview) {
        _shadowImageView.frame = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), kNavigationShadowHeight);
    }
}

- (void)setCustomShadowImage:(UIImage *)shadowImage
{
    if (_shadowImageView == nil) {
        _shadowImageView = [[UIImageView alloc] initWithImage:[shadowImage stretchableImageByWidthCenter]];
    }
    else {
        _shadowImageView.image = [shadowImage stretchableImageByWidthCenter];
    }
    
    _shadowImageView.frame = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), kNavigationShadowHeight);
    
    if (_shadowImageView.superview == nil) {
        _shadowImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:_shadowImageView];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
}
*/

/* 注释掉
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    if (inside) {
        if (!CGRectContainsPoint(touchBounds, point)) {
            inside = NO;
        }
    }
    
    return inside;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self pointInside:point withEvent:event]) {
        self.userInteractionEnabled = YES;
    }
    else {
        self.userInteractionEnabled = NO;
    }
    
    return [super hitTest:point withEvent:event];
}
*/

@end
