//
//  SNSlideNavigationController+SNSlideStack.m
//  YiRen
//
//  Created by Nova on 13-5-20.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNSlideNavigationController+SNSlideStack.h"
#import "NSMutableArray+SNSlideStack.h"
#import "SNViewController.h"

@implementation SNSlideNavigationController (SNSlideStack)

#pragma mark - DataManagement

- (UIViewController *)currentViewController
{
    return [self.viewControllers currentControllerInStack];
}

- (UIViewController *)belowViewController
{
    return [self.viewControllers belowControllerInStack];
}

- (void)addController:(SNViewController *)controller
{
    if ([self.viewControllers pushController:controller]) {
        controller.slideNavigationController = self;
    }
}

- (void)removeController:(SNViewController *)controller
{
    [controller retain];
    if ([self.viewControllers popController:controller]) {
        controller.slideNavigationController = nil;
    }
    [controller release];
}

@end
