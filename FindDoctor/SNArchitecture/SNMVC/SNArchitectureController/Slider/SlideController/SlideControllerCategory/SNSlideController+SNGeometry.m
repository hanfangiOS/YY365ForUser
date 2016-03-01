//
//  SNSlideController+SNGeometry.m
//  SNSlideController
//
//  Created by Nova on 13-4-2.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNSlideController+SNGeometry.h"

@implementation SNSlideController (SNGeometry)

CGFloat CGRectGetLeftMinX(CGRect rect)
{
    return CGRectGetMinX(rect)+kLeftReservedWidth;
}

CGFloat CGRectGetRightMaxX(CGRect rect)
{
    return CGRectGetMaxX(rect)-kRightReservedWidth;
}

- (SNViewController *)hitTest:(CGPoint)point
{
    SNViewController *hitController = nil;
    CGRect frame = CGRectInset(self.topController.view.frame, -kPanRecognizeExpandWidth, 0);
    if (CGRectContainsPoint(frame, point)) {
        hitController = self.topController;
    }
    else {
        switch (self.topControllerStatus) {
            case SNSlideStatusCenter:
                hitController = self.topController;
                break;
                
            case SNSlideStatusRight:
            case SNSlideStatusRightOutOfScreen:
                hitController = self.leftController;
                break;
                
            case SNSlideStatusLeft:
            case SNSlideStatusLeftOutOfScreen:
                hitController = self.rightController;
                break;
                
            default:
                break;
        }
    }
    
    return hitController;
}

- (CGFloat)scaleForController:(SNViewController *)controller withFrame:(CGRect)frame
{
    return 1;
    
    CGFloat factor = 0.0;
    
    if (frame.origin.x < 0) {
        if ([controller isEqual:self.rightController]) {
            factor = 0-frame.origin.x/(CGRectGetWidth(self.view.bounds)-kLeftReservedWidth);
        }
    }
    else if (frame.origin.x > 0) {
        if ([controller isEqual:self.leftController]) {
            factor = frame.origin.x/(CGRectGetWidth(self.view.bounds)-kRightReservedWidth);
        }
    }
    
    CGFloat scale = kSlideTransformStartValue+factor*(kTransformEndValue-kSlideTransformStartValue);
    if (scale > 1)
    {
        scale = 1;
    }
    return scale;
}

- (CGFloat)alphaForController:(SNViewController *)controller withFrame:(CGRect)frame
{
    return 0;
    
    CGFloat factor = 0.0;
    
    if (frame.origin.x < 0) {
        if ([controller isEqual:self.rightController]) {
            factor = 0-frame.origin.x/(CGRectGetWidth(self.view.bounds)-kLeftReservedWidth);
        }
    }
    else if (frame.origin.x > 0) {
        if ([controller isEqual:self.leftController]) {
            factor = frame.origin.x/(CGRectGetWidth(self.view.bounds)-kRightReservedWidth);
        }
    }
    
    CGFloat alpha = kAlphaStartValue-factor*(kAlphaStartValue-kAlphaEndValue);
    if (alpha < 0.0) {
        alpha = 0.0;
    }
    else if (alpha > 1.0) {
        alpha = 1.0;
    }
    
    return alpha;
}

@end
