//
//  SNTableView.m
//  YiRen
//
//  Created by Nova on 13-4-8.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNTableView.h"
#import "SNSlideDefines.h"

@implementation SNTableView

- (void) reloadDataWithCompletion:( void (^) (void) )completionBlock
{
    [super reloadData];
    if(completionBlock)
    {
        completionBlock();
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL shouldBegin = YES;
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint translation = [panGestureRecognizer translationInView:self];
        CGFloat threshold = fabs(translation.y)/MAX(fabs(translation.x), 0.0001);
        if (threshold < kTriggerThreshold && threshold > 0.0001) {
            shouldBegin = NO;
        }
    }
    
    return shouldBegin;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
