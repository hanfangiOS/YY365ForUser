//
//  UIViewController+SNSlideStatus.m
//  SNSlideController
//
//  Created by Nova on 13-4-2.
//  Copyright (c) 2013年. All rights reserved.
//

#import "UIViewController+SNSlideStatus.h"

@implementation UIViewController (SNSlideStatus)

- (BOOL)isLeftStatus:(SNSlideStatus)status
{
    return (status == SNSlideStatusLeft || status == SNSlideStatusLeftOutOfScreen);
}

- (BOOL)isRightStatus:(SNSlideStatus)status
{
    return (status == SNSlideStatusRight || status == SNSlideStatusRightOutOfScreen);
}

- (BOOL)isStatus:(SNSlideStatus)statusOne onSameSideWithStatus:(SNSlideStatus)statusTwo
{
    return ([self isLeftStatus:statusOne] && [self isLeftStatus:statusTwo]) || ([self isRightStatus:statusOne] && [self isRightStatus:statusTwo]);
}

- (SNSlideStatus)statusForController:(UIViewController *)controller
{
    SNSlideStatus status = SNSlideStatusCenter;
    if (CGRectGetMinX(controller.view.frame) < 0) {
        if (CGRectGetMaxX(controller.view.frame) <= CGRectGetMinX(self.view.bounds)) {
            status = SNSlideStatusLeftOutOfScreen;
        }
        else {
            status = SNSlideStatusLeft;
        }
        
    }
    else if (CGRectGetMinX(controller.view.frame) > 0) {
        if (CGRectGetMinX(controller.view.frame) >= CGRectGetMaxX(self.view.bounds)) {
            status = SNSlideStatusRightOutOfScreen;
        }
        else {
            status = SNSlideStatusRight;
        }
    }
    else {
        status = SNSlideStatusCenter;
    }
    
    return status;
}

@end
