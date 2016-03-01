//
//  SNSlideController+SNControllerHierarchy.m
//  SNSlideController
//
//  Created by Nova on 13-4-2.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNSlideController+SNControllerHierarchy.h"
#import "UIViewController+SNSlideStatus.h"
#import "SNSlideController+SNSlideStatus.h"
#import "SNSlideController+SNSlideAttribute.h"
#import "SNSlideController+SNObserver.h"
#import "UIViewController+SNAppearance.h"
#import "NSMutableArray+SNSlideStack.h"

@implementation SNSlideController (SNControllerHierarchy)

- (void)resetOldTopController:(SNViewController *)oldCont withNewTopController:(SNViewController *)newCont
{
    if ([oldCont isEqual:newCont]) {
        return;
    }
    
    [oldCont retain];
    
    if ([self.selectedController isEqual:oldCont]) {
        self.selectedController = nil;
    }
    
    if ([oldCont respondsToSelector:@selector(slideControllerWillChangeTopViewController:)]) {
        [oldCont slideControllerWillChangeTopViewController:oldCont];
    }
    
    self.topController = newCont;
    newCont.slideController = oldCont.slideController;
    newCont.slideNavigationController = oldCont.slideNavigationController;
    
    newCont.view.transform = oldCont.view.transform;
    newCont.view.frame = oldCont.view.frame;
    [self addShadowForController:newCont];
    [self.view addSubview:newCont.view];
//    // iOS < 5.0 viewWill/DidAppear not call when addSubview
//    if (iOSVersionLessThan_5_0()) {
//        [newCont viewWillAppear:NO];
//        [newCont viewDidAppear:NO];
//    }
    [oldCont.view removeFromSuperview];
//    // iOS < 5.0 viewWill/DidDisappear not call when removeFromSuperview
//    if (iOSVersionLessThan_5_0()) {
//        [oldCont viewWillDisappear:NO];
//        [oldCont viewDidDisappear:NO];
//    }
    
    [self removeAttributeForController:oldCont];
    
#ifdef kUseTransformEffect
    [self addObserverForController:newCont];
    [self removeObserverForController:oldCont];
#endif
    
    [self.controllerStack replaceController:oldCont withController:newCont];
    
    [oldCont release];
}

- (void)resetControllersWithController:(SNViewController *)controller
                                status:(SNSlideStatus)status
                          indexInStack:(NSInteger)index
{
    if (status != SNSlideStatusCenter) {
        return;
    }
    
    [self.controllerStack popControllersToIndex:index];
    
    if ([controller isEqual:self.topController]) {
        self.rightController.view.transform = CGAffineTransformIdentity;
        self.rightController.view.frame = self.view.bounds;
        self.rightController.maskView.alpha = 0.0;
        self.rightController.view.userInteractionEnabled = YES;
        
        self.leftController.view.transform = CGAffineTransformIdentity;
        self.leftController.view.frame = self.view.bounds;
        self.leftController.maskView.alpha = 0.0;
        self.leftController.view.userInteractionEnabled = YES;
    }
    else if ([controller isEqual:self.leftController]) {
//        self.leftController.view.transform = CGAffineTransformIdentity;
//        self.leftController.view.frame = self.view.bounds;
//        self.leftController.maskView.alpha = 0.0;
        self.leftController.view.userInteractionEnabled = YES;
    }
    else if ([controller isEqual:self.rightController]) {
//        self.rightController.view.transform = CGAffineTransformIdentity;
//        self.rightController.view.frame = self.view.bounds;
//        self.rightController.maskView.alpha = 0.0;
        self.rightController.view.userInteractionEnabled = YES;
    }
}

- (void)resetCurrentControllerWithController:(SNViewController *)controller status:(SNSlideStatus)status
{
    switch (status) {
        case SNSlideStatusCenter:
        {
            [self.controllerStack popController:controller];
            self.currentController = controller;
        }
            break;
            
        case SNSlideStatusRight:
        case SNSlideStatusRightOutOfScreen:
        {
            [self resetCurrentControllerWithController:controller andSideController:self.leftController];
        }
            break;
            
        case SNSlideStatusLeft:
        case SNSlideStatusLeftOutOfScreen:
        {
            [self resetCurrentControllerWithController:controller andSideController:self.rightController];
        }
            break;
            
        default:
            break;
    }
}

- (void)resetCurrentControllerWithController:(SNViewController *)controller andSideController:(SNViewController *)sideController
{
    if ([controller isEqual:self.topController]) {
        if (sideController) {
            if ([self.controllerStack canPushController:controller]) {
                [self.controllerStack pushController:controller];
            }
            self.currentController = sideController;
        }
        else {
            self.currentController = nil;
        }
    }
    else {
        self.currentController = nil;
    }
}

- (void)layoutControllers
{
    self.rightController.view.frame = self.view.bounds;
//    [self addShadowForController:self.rightController];
    [self.view insertSubview:self.rightController.view atIndex:0];
    
//    // iOS < 5.0 viewWill/DidAppear not call when addSubview
//    if (iOSVersionLessThan_5_0()) {
//        [self.rightController viewWillAppear:NO];
//        [self.rightController viewDidAppear:NO];
//    }
    
    self.leftController.view.frame = self.view.bounds;
//    [self addShadowForController:self.leftController];
    [self.view insertSubview:self.leftController.view atIndex:0];
//    if (iOSVersionLessThan_5_0()) {
//        [self.leftController viewWillAppear:NO];
//        [self.leftController viewDidAppear:NO];
//    }
    
    self.currentController = self.topController;
    self.topController.view.frame = self.view.bounds;
    [self addShadowForController:self.topController];
    [self.view addSubview:self.topController.view];
//    if (iOSVersionLessThan_5_0()) {
//        [self.topController viewWillAppear:NO];
//        [self.topController viewDidAppear:NO];
//    }
}

- (void)layoutControllersWithSelectedController:(SNViewController *)controller translation:(CGPoint)translation
{
    if (![controller isEqual:self.topController] || translation.x == 0) {
        return;
    }
    
    SNSlideAttribute attr = [self attributeForController:self.topController];
    CGRect frame = CGRectOffset(self.topController.view.frame, translation.x, 0);
    if (translation.x > 0 && CGRectGetMaxX(frame) > CGRectGetMaxX(self.view.bounds)) {
        if (attr.slideToRightEnable) {
            self.topControllerStatus = SNSlideStatusRight;
        }
        else {
            self.topControllerStatus = SNSlideStatusCenter;
        }
    }
    else if (translation.x < 0 && CGRectGetMinX(frame) < CGRectGetMinX(self.view.bounds)) {
        if (attr.slideToLeftEnable) {
            self.topControllerStatus = SNSlideStatusLeft;
        }
        else {
            self.topControllerStatus = SNSlideStatusCenter;
        }
    }
}

- (void)layoutSelectedController:(SNViewController *)controller withPanGestureRecognizer:(UIPanGestureRecognizer *)gesture
{
    CGFloat offset = CGRectGetMidX(controller.view.frame)-CGRectGetMidX(self.view.bounds);
    CGPoint velocity = [gesture velocityInView:self.view];
    
    if (fabs(velocity.x) > kVelocityThreshold && fabs(offset) > kXOffsetThreshold)
    {
        if (velocity.x > 0.0f)
        {
            if (offset < 0) {
                [self setStatus:SNSlideStatusCenter forController:controller animated:YES usingBounce:YES onCompletion:NULL];
            }
            else {
                [self setStatus:SNSlideStatusRight forController:controller animated:YES usingBounce:YES onCompletion:NULL];
            }
        }
        else
        {
            if (offset > 0) {
                [self setStatus:SNSlideStatusCenter forController:controller animated:YES usingBounce:YES onCompletion:NULL];
            }
            else {
                [self setStatus:SNSlideStatusLeft forController:controller animated:YES usingBounce:YES onCompletion:NULL];
            }
        }
    }
    else
    {
        if (self.lastControllerStatus == SNSlideStatusCenter) {
            SNSlideStatus status = SNSlideStatusCenter;
            if (offset > kXOffsetThreshold) {
                status = SNSlideStatusRight;
            }
            else if (offset < (-1)*kXOffsetThreshold) {
                status = SNSlideStatusLeft;
            }
            
            [self setStatus:status forController:controller animated:YES usingBounce:NO onCompletion:NULL];
        }
        else {
            SNSlideStatus status = SNSlideStatusCenter;
            CGFloat reservedWidth = (offset < 0) ? kLeftReservedWidth : kRightReservedWidth;
            CGFloat rOffset = (CGRectGetWidth(controller.view.frame)+CGRectGetWidth(self.view.bounds))*0.5-fabs(offset)-reservedWidth;
            if (rOffset < kXOffsetThreshold) {
                if ([self isStatus:self.topControllerStatus onSameSideWithStatus:SNSlideStatusLeft]) {
                    status = SNSlideStatusLeft;
                }
                else if ([self isStatus:self.topControllerStatus onSameSideWithStatus:SNSlideStatusRight]) {
                    status = SNSlideStatusRight;
                }
            }
            
            [self setStatus:status forController:controller animated:YES usingBounce:NO onCompletion:NULL];
        }
    }
}

- (void)bringController:(SNViewController *)controller toFrontOfController:(SNViewController *)anotherController
{
    if (controller == nil || anotherController == nil) {
        return;
    }
    
    NSUInteger indexOfController = [self.view.subviews indexOfObject:controller.view];
    NSUInteger indexOfAnotherController = [self.view.subviews indexOfObject:anotherController.view];
    if (indexOfController < indexOfAnotherController) {
        [self.view exchangeSubviewAtIndex:indexOfController withSubviewAtIndex:indexOfAnotherController];
    }
}

- (void)bringControllerToFront:(UIViewController *)controller
{
    [controller.view removeFromSuperview];
    [self.view insertSubview:controller.view belowSubview:self.topController.view];
    controller.view.hidden = NO;
}

- (void)sendControllerToBack:(UIViewController *)controller
{
    [self.view sendSubviewToBack:controller.view];
    controller.view.hidden = YES;
}

- (SNViewController *)controllerBelow:(SNViewController *)controller withStatus:(SNSlideStatus)status
{
    SNViewController *belowController = nil;
    if ([controller isEqual:self.topController]) {
        if ([self isStatus:status onSameSideWithStatus:SNSlideStatusRight]
            && self.leftController) {
            belowController = self.leftController;
        }
        else if ([self isStatus:status onSameSideWithStatus:SNSlideStatusLeft]
                 && self.rightController) {
            belowController = self.rightController;
        }
    }
    else {
        return nil;
    }
    
    return belowController;
}

@end
