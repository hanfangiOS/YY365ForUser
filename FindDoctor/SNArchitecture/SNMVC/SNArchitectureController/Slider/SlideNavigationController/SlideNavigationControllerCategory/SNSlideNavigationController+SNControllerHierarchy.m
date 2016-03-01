//
//  SNSlideNavigationController+SNControllerHierarchy.m
//  SNSlideController
//
//  Created by Nova on 13-4-2.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNSlideNavigationController+SNControllerHierarchy.h"
#import "UIViewController+SNAppearance.h"
#import "SNSlideNavigationController+SNSlideStatus.h"
#import "NSMutableArray+SNSlideStack.h"
#import "SNSlideNavigationController+SNSlideStack.h"
#import "SNSlideNavigationControllerPan.h"
#import "SNViewController.h"

@implementation SNSlideNavigationController (SNControllerHierarchy)

- (SNViewController *)controllerBelowController:(SNViewController *)viewController
{
    SNViewController *belowController = nil;
    if ([[self currentViewController] isEqual:viewController]) {
        belowController = [self belowViewController];
    }
    else {
        belowController = [self currentViewController];
    }
    
    return belowController;
}

- (void)layoutControllers
{
    for (int i = 0; i < self.viewControllers.count; i++) {
        SNViewController *controller = [self.viewControllers objectAtIndex:i];
        controller.view.frame = self.view.bounds;
        if (i != 0) {
            [self addShadowForController:controller];
        }
        [self.view insertSubview:controller.view atIndex:i];
    }
}

- (void)layoutSelectedController:(SNViewController *)controller
                              andStatus:(SNSlideStatus)status
                            usingBounce:(BOOL)usingBounce
{
    SNViewController *currentViewController = [controller retain];
    SNViewController *belowViewController = [[self currentViewController] retain];
    
    if (status == SNSlideStatusCenter) {
        belowViewController.view.userInteractionEnabled = NO;
        [belowViewController viewWillDisappear:NO];
        [self setStatus:SNSlideStatusCenter forController:currentViewController animated:YES usingBounce:usingBounce onCompletion:^{
            [belowViewController viewDidDisappear:NO];
            controller.view.userInteractionEnabled = YES;
            [self addController:controller];
            
            if ([controller respondsToSelector:@selector(slideNavigationController:didPushViewController:)]) {
                [controller slideNavigationController:self didPushViewController:controller];
            }
            
            [currentViewController release];
            [belowViewController release];
        }];
    }
    else {
        if ([currentViewController respondsToSelector:@selector(slideNavigationController:willPopViewController:)]) {
            [currentViewController slideNavigationController:self willPopViewController:currentViewController];
            if (currentViewController.modalViewController) {
                [currentViewController dismissModalViewControllerAnimated:NO];
            }
        }
        
        currentViewController.view.userInteractionEnabled = NO;
//        // iOS < 5.0 viewWill/DidDisappear not call when addSubview
//        if (iOSVersionLessThan_5_0()) {
//            [currentViewController viewWillDisappear:NO];
//        }
        [self setStatus:SNSlideStatusRightOutOfScreen forController:currentViewController animated:YES usingBounce:usingBounce onCompletion:^{
            // iOS < 5.0 viewWill/DidDisappear not call when addSubview
//            if (iOSVersionLessThan_5_0()) {
//                [currentViewController viewDidDisappear:NO];
//            }
            [currentViewController.view removeFromSuperview];
            belowViewController.view.userInteractionEnabled = YES;
            
            if ([currentViewController respondsToSelector:@selector(slideNavigationController:didPopViewController:)]) {
                [currentViewController slideNavigationController:self didPopViewController:currentViewController];
            }
            
            currentViewController.slideNavigationController = nil;
            [currentViewController release];
            [belowViewController release];
        }];
    }
}

- (void)layoutCurrentSelectedController:(SNViewController *)controller
                                     andStatus:(SNSlideStatus)status
                                   usingBounce:(BOOL)usingBounce
{
    SNViewController *controllerToPop = [controller retain];
    SNViewController *currentViewController = [controller retain];
    SNViewController *belowViewController = [[self belowViewController] retain];
    
    if (status == SNSlideStatusRightOutOfScreen) {
        if ([currentViewController respondsToSelector:@selector(slideNavigationController:willPopViewController:)]) {
            [currentViewController slideNavigationController:self willPopViewController:currentViewController];
            if (currentViewController.modalViewController) {
                [currentViewController dismissModalViewControllerAnimated:NO];
            }
        }
        
        [self removeController:controllerToPop];
        
        currentViewController.view.userInteractionEnabled = NO;
        // iOS < 5.0 viewWill/DidDisappear not call when addSubview
//        if (iOSVersionLessThan_5_0()) {
//            [currentViewController viewWillDisappear:NO];
//        }
        [belowViewController viewWillAppear:NO];
        [self setStatus:SNSlideStatusRightOutOfScreen forController:currentViewController animated:YES usingBounce:usingBounce onCompletion:^{
            // iOS < 5.0 viewWill/DidDisappear not call when addSubview
//            if (iOSVersionLessThan_5_0()) {
//                [currentViewController viewDidDisappear:NO];
//            }
            [belowViewController viewDidAppear:NO];
            [currentViewController.view removeFromSuperview];
            belowViewController.view.userInteractionEnabled = YES;
            
            if ([currentViewController respondsToSelector:@selector(slideNavigationController:didPopViewController:)]) {
                [currentViewController slideNavigationController:self didPopViewController:currentViewController];
            }
            
//            [self removeController:controllerToPop];
            
            [controllerToPop release];
            [currentViewController release];
            [belowViewController release];
        }];
    }
    else {
        [self setStatus:SNSlideStatusCenter forController:currentViewController animated:YES usingBounce:usingBounce onCompletion:^{
            belowViewController.view.userInteractionEnabled = NO;
            currentViewController.view.userInteractionEnabled = YES;
            
            [controllerToPop release];
            [currentViewController release];
            [belowViewController release];
        }];
    }
}

- (void)layoutSelectedController:(SNViewController *)controller
                andPanGestureRecognizer:(UIPanGestureRecognizer *)gesture
{
    CGFloat offset = CGRectGetMidX(controller.view.frame)-CGRectGetMidX(self.view.bounds);
    CGPoint velocity = [gesture velocityInView:self.view];
    SNViewController *currentViewController = [self currentViewController];
    
    if (fabs(velocity.x) > kVelocityThreshold)
    {
        if (velocity.x > 0.0f)
        {
            if ([controller isEqual:currentViewController])
            {
                [self layoutCurrentSelectedController:controller andStatus:SNSlideStatusRightOutOfScreen usingBounce:NO];
            }
            else
            {
                // 取消移入栈
                [self layoutSelectedController:controller andStatus:SNSlideStatusRightOutOfScreen usingBounce:NO];
            }
        }
        else
        {
            if ([controller isEqual:currentViewController])
            {
                [self layoutCurrentSelectedController:controller andStatus:SNSlideStatusCenter usingBounce:YES];
            }
            else
            {
                // 移入栈
                if ([controller respondsToSelector:@selector(willPanToSlideNavigationController)])
                {
                    [(id<SNSlideNavigationControllerPan>)controller willPanToSlideNavigationController];
                }
                [self layoutSelectedController:controller andStatus:SNSlideStatusCenter usingBounce:YES];
            }
        }
    }
    else
    {
        if ([controller isEqual:currentViewController]) {
            if (offset > kXOffsetThreshold) {
                [self layoutCurrentSelectedController:controller andStatus:SNSlideStatusRightOutOfScreen usingBounce:NO];
            }
            else {
                [self layoutCurrentSelectedController:controller andStatus:SNSlideStatusCenter usingBounce:NO];
            }
        
        }
        else {
            CGFloat rOffset = (CGRectGetWidth(controller.view.frame)+CGRectGetWidth(self.view.bounds))*0.5-fabs(offset);
            if (rOffset < kXOffsetThreshold)
            {
                // 取消移入栈
                [self layoutSelectedController:controller andStatus:SNSlideStatusRightOutOfScreen usingBounce:NO];
            }
            else
            {
                // 移入栈
                if ([controller respondsToSelector:@selector(willPanToSlideNavigationController)])
                {
                    [(id<SNSlideNavigationControllerPan>)controller willPanToSlideNavigationController];
                }
                [self layoutSelectedController:controller andStatus:SNSlideStatusCenter usingBounce:NO];
            }
        }
    }
}

@end
