//
//  SNView.m
//  YiRen
//
//  Created by Nova on 13-8-12.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNView.h"

@implementation SNView

@synthesize delegate;
@synthesize suppressDelegate;

- (void)dealloc
{
    self.delegate = nil;
    
    [super dealloc];
}

- (void)suppressDelegateForAction:(void (^)(void))actionBlock
{
    BOOL oldStatus = self.suppressDelegate;
    self.suppressDelegate = YES;
    if (actionBlock != NULL) {
        actionBlock();
    }
    self.suppressDelegate = oldStatus;
}

- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    if (!self.suppressDelegate && [self.delegate respondsToSelector:@selector(viewDidAddSubview:)]) {
        [self.delegate viewDidAddSubview:subview];
    }
}

- (void)bringSubviewToFront:(UIView *)view
{
    [super bringSubviewToFront:view];
    if (!self.suppressDelegate && [self.delegate respondsToSelector:@selector(viewDidBringSubviewToFront:)]) {
        [self.delegate viewDidBringSubviewToFront:view];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

@end
