//
//  UIViewController+SNAppearance.m
//  SNSlideController
//
//  Created by Nova on 13-4-2.
//  Copyright (c) 2013年. All rights reserved.
//

#import "UIViewController+SNAppearance.h"
#import "SNSlideDefines.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIViewController (SNAppearance)

- (void)addShadowForController:(UIViewController *)controller
{
    CALayer *layer = [controller.view layer];
    layer.shadowPath = [UIBezierPath bezierPathWithRect:controller.view.bounds].CGPath;
    layer.masksToBounds = NO;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, 0);
    layer.shadowOpacity = kShadowOpacity;
    layer.shadowRadius = kShadowRaidus;
}

@end
