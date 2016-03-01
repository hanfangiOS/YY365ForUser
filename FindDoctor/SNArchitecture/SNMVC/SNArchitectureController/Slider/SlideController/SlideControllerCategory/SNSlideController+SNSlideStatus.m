//
//  SNSlideController+SNSlideStatus.m
//  SNSlideController
//
//  Created by Nova on 13-4-1.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNSlideController+SNSlideStatus.h"
#import "SNSlideController+SNSlideAttribute.h"
#import "SNSlideController+SNGeometry.h"
#import "SNSlideController+SNControllerHierarchy.h"
#import "UIViewController+SNSlideStatus.h"
#import "SNSlideController+SNObserver.h"
#import "UIViewController+SNAppearance.h"
#import "SNUISystemConstant.h"

#define kSNSlideControllerStatusBarHeight   20

@implementation SNSlideController (SNSlideStatus)

- (void)setStatus:(SNSlideStatus)status
    forController:(SNViewController *)controller
         animated:(BOOL)animated usingBounce:(BOOL)bounce
     onCompletion:(void (^)(void))completionBlock
{   
    switch (status) {
        case SNSlideStatusCenter:
        case SNSlideStatusLeftOutOfScreen:
        case SNSlideStatusRightOutOfScreen:
        {
            [self moveController:controller toStatus:status animated:animated usingBounce:bounce onCompletion:completionBlock];
        }
            break;
            
        case SNSlideStatusLeft:
        {
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_7_0))
            {
                [[UIApplication sharedApplication] setStatusBarHidden:YES];
            }
            
            SNSlideAttribute attr = [self attributeForController:controller];
            SNSlideStatus adjustedStatus = (attr.slideToLeftEnable) ? SNSlideStatusLeft : SNSlideStatusCenter;
            [self moveController:controller toStatus:adjustedStatus animated:animated usingBounce:bounce onCompletion:completionBlock];
        }
            break;
            
        case SNSlideStatusRight:
        {
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_7_0))
            {
                [[UIApplication sharedApplication] setStatusBarHidden:YES];
            }
            
            SNSlideAttribute attr = [self attributeForController:controller];
            SNSlideStatus adjustedStatus = (attr.slideToRightEnable) ? SNSlideStatusRight : SNSlideStatusCenter;
            [self moveController:controller toStatus:adjustedStatus animated:animated usingBounce:bounce onCompletion:completionBlock];
            
        }
            break;
            
            //TODO
            
        default:
            break;
    }
}

- (void)resetTopViewControllerFrame:(SNSlideStatus)status
{
    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_7_0))
    {
        return;
    }

    CGRect rect = self.topController.view.frame;
    switch (status) {
        case SNSlideStatusCenter:
        {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
            rect.origin.y = 0;
            rect.size.height = CGRectGetHeight([UIScreen mainScreen].bounds);
        }
            break;

        case SNSlideStatusLeft:
        case SNSlideStatusRight:
        {
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            rect.origin.y = - kSNSlideControllerStatusBarHeight;
            rect.size.height = CGRectGetHeight([UIScreen mainScreen].bounds) + kSNSlideControllerStatusBarHeight;
        }
            break;
            
            //TODO
            
        default:
            break;
    }
    
    [UIView animateWithDuration:kSlideAnimationDuration animations:^{
        self.topController.view.frame = rect;
        [self addShadowForController:self.topController];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)moveController:(SNViewController *)controller
              toStatus:(SNSlideStatus)status
              animated:(BOOL)animated
           usingBounce:(BOOL)bounce
          onCompletion:(void (^)(void))completionBlock
{
    SNSlideStatus lastTopControllerStatus = self.topControllerStatus;
    if ([controller isEqual:self.topController]) {
        self.topControllerStatus = status;
    }
    
    CGRect frame = controller.view.frame;
    
#ifdef kUseTransformEffect 
    CGFloat roscale = [self scaleForController:self.rightController withFrame:frame];
    CGFloat loscale = [self scaleForController:self.leftController withFrame:frame];
#endif
    
    CGFloat roalpha = [self alphaForController:self.rightController withFrame:frame];
    CGFloat loalpha = [self alphaForController:self.leftController withFrame:frame];
    
    CGRect bounceFrame = frame;
    switch (status) {
        case SNSlideStatusCenter:
        {
            controller.view.userInteractionEnabled = YES;
            frame.origin.x = 0;
            if ([controller isEqual:self.topController]) {
                if ([self isStatus:lastTopControllerStatus onSameSideWithStatus:SNSlideStatusLeft]) {
                    bounceFrame = CGRectOffset(frame, kBounceDistance, 0.0f);
                }
                else if ([self isStatus:lastTopControllerStatus onSameSideWithStatus:SNSlideStatusRight]) {
                    bounceFrame = CGRectOffset(frame, (-1)*kBounceDistance, 0.0f);
                }
            }
        }
            break;
            
        case SNSlideStatusRight:
        {
            controller.view.userInteractionEnabled = NO;
            frame.origin.x = CGRectGetRightMaxX(self.view.bounds);
            bounceFrame = CGRectOffset(frame, kBounceDistance, 0.0f);
        }
            break;
            
        case SNSlideStatusLeft:
        {
            controller.view.userInteractionEnabled = NO;
            frame.origin.x = CGRectGetLeftMinX(self.view.bounds)-CGRectGetWidth(frame);
            bounceFrame = CGRectOffset(frame, (-1)*kBounceDistance, 0.0f);
        }
            break;
            
        case SNSlideStatusRightOutOfScreen:
        {
            frame.origin.x = CGRectGetMaxX(self.view.bounds)+kShadowRaidus;
        }
            break;
            
        case SNSlideStatusLeftOutOfScreen:
        {
            frame.origin.x = CGRectGetMinX(self.view.bounds)-CGRectGetWidth(frame)-kShadowRaidus;
        }
            
        default:
            break;
    }
    
#ifdef kUseTransformEffect
    CGFloat rscale = [self scaleForController:self.rightController withFrame:frame];
    CGFloat rbscale = [self scaleForController:self.rightController withFrame:bounceFrame];
#endif
    
    CGFloat ralpha = [self alphaForController:self.rightController withFrame:frame];
    CGFloat rbalpha = [self alphaForController:self.rightController withFrame:bounceFrame];
    
#ifdef kUseTransformEffect
    CGFloat lscale = [self scaleForController:self.leftController withFrame:frame];
    CGFloat lbscale = [self scaleForController:self.leftController withFrame:bounceFrame];
#endif
    
    CGFloat lalpha = [self alphaForController:self.leftController withFrame:frame];
    CGFloat lbalpha = [self alphaForController:self.leftController withFrame:bounceFrame];
    
    self.layouting = YES;
    bounce = NO;
    NSInteger indexInStack = [self.controllerStack indexOfObject:controller];
    if (animated) {
#ifdef kUseTransformEffect
        self.rightController.view.transform = CGAffineTransformMakeScale(roscale, roscale);
        self.leftController.view.transform = CGAffineTransformMakeScale(loscale, loscale);
#endif
        
        self.rightController.maskView.alpha = roalpha;
        self.leftController.maskView.alpha = loalpha;
        
        if (bounce == NO
            || (status == SNSlideStatusCenter && ![controller isEqual:self.topController])
            || status == SNSlideStatusLeftOutOfScreen
            || status == SNSlideStatusRightOutOfScreen) {
            float duration = (status == SNSlideStatusLeftOutOfScreen || status == SNSlideStatusRightOutOfScreen) ? kOutOfScreenAnimationDuration : kSlideAnimationDuration;
            
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
                controller.view.frame = frame;
#ifdef kUseTransformEffect
                self.rightController.view.transform = CGAffineTransformMakeScale(rscale, rscale);
                self.leftController.view.transform = CGAffineTransformMakeScale(lscale, lscale);
#endif
                
                self.rightController.maskView.alpha = ralpha;
                self.leftController.maskView.alpha = lalpha;
            } completion:^(BOOL finished) {
                [self resetControllersWithController:controller status:status indexInStack:indexInStack];
                if (completionBlock) {
                    completionBlock();
                }
                [self resetTopViewControllerFrame:status];
                [self performDelegateForController:controller withStatus:status andLastStatus:lastTopControllerStatus];
                self.layouting = NO;
            }];
        }
        else {
            [UIView animateWithDuration:kSlideAnimationDuration delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
                controller.view.frame = bounceFrame;
#ifdef kUseTransformEffect
                self.rightController.view.transform = CGAffineTransformMakeScale(rbscale, rbscale);
                self.leftController.view.transform = CGAffineTransformMakeScale(lbscale, lbscale);
#endif
                
                self.rightController.maskView.alpha = rbalpha;
                self.leftController.maskView.alpha = lbalpha;
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:kBounceAnimationDuration delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
                        controller.view.frame = frame;
#ifdef kUseTransformEffect
                        self.rightController.view.transform = CGAffineTransformMakeScale(rscale, rscale);
                        self.leftController.view.transform = CGAffineTransformMakeScale(lscale, lscale);
#endif
                        
                        self.rightController.maskView.alpha = ralpha;
                        self.leftController.maskView.alpha = lalpha;
                    } completion:^(BOOL finished) {
                        [self resetControllersWithController:controller status:status indexInStack:indexInStack];
                        if (completionBlock) {
                            completionBlock();
                        }
                        [self resetTopViewControllerFrame:status];
                        [self performDelegateForController:controller withStatus:status andLastStatus:lastTopControllerStatus];
                        self.layouting = NO;
                    }];
                }
                else {
                    controller.view.frame = frame;
#ifdef kUseTransformEffect
                    self.rightController.view.transform = CGAffineTransformMakeScale(rscale, rscale);
                    self.leftController.view.transform = CGAffineTransformMakeScale(lscale, lscale);
#endif
                    
                    self.rightController.maskView.alpha = ralpha;
                    self.leftController.maskView.alpha = lalpha;
                    
                    [self resetControllersWithController:controller status:status indexInStack:indexInStack];
                    if (completionBlock) {
                        completionBlock();
                    }
                    [self resetTopViewControllerFrame:status];
                    [self performDelegateForController:controller withStatus:status andLastStatus:lastTopControllerStatus];
                    self.layouting = NO;
                }
            }];
        }
        
        [self resetCurrentControllerWithController:controller status:status];
    }
    else {
        controller.view.frame = frame;
#ifdef kUseTransformEffect
        self.rightController.view.transform = CGAffineTransformMakeScale(rscale, rscale);
        self.leftController.view.transform = CGAffineTransformMakeScale(lscale, lscale);
#endif
        
        self.rightController.maskView.alpha = ralpha;
        self.leftController.maskView.alpha = lalpha;
        
        [self resetControllersWithController:controller status:status indexInStack:indexInStack];
        [self resetCurrentControllerWithController:controller status:status];
        if (completionBlock) {
            completionBlock();
        }
        [self resetTopViewControllerFrame:status];
        [self performDelegateForController:controller withStatus:status andLastStatus:lastTopControllerStatus];
        self.layouting = NO;
    }
}

- (void)performDelegateForController:(SNViewController *)controller
                          withStatus:(SNSlideStatus)status
                       andLastStatus:(SNSlideStatus)lastStatus
{
    if ([self.topController respondsToSelector:@selector(slideControllerDidSlideViewController:toStatus:)]) {
        [self.topController slideControllerDidSlideViewController:controller toStatus:status];
    }
    if ([self.rightController respondsToSelector:@selector(slideControllerDidSlideViewController:toStatus:)]) {
        [self.rightController slideControllerDidSlideViewController:controller toStatus:status];
    }
    if ([self.leftController respondsToSelector:@selector(slideControllerDidSlideViewController:toStatus:)]) {
        [self.leftController slideControllerDidSlideViewController:controller toStatus:status];
    }
    
    if ([controller isEqual:self.topController]) {
        if ([self isStatus:status onSameSideWithStatus:SNSlideStatusLeft]) {
            if ([self.rightController respondsToSelector:@selector(slideControllerDidShowViewController:)]) {
                [self.rightController slideControllerDidShowViewController:self.rightController];
            }
        }
        else if ([self isStatus:status onSameSideWithStatus:SNSlideStatusRight]) {
            if ([self.leftController respondsToSelector:@selector(slideControllerDidShowViewController:)]) {
                [self.leftController slideControllerDidShowViewController:self.leftController];
            }
        }
        else {
            // TopController is SNSlideStatusCenter
            if ([self isStatus:lastStatus onSameSideWithStatus:SNSlideStatusLeft]) {
                if ([self.rightController respondsToSelector:@selector(slideControllerDidHideViewController:)]) {
                    [self.rightController slideControllerDidHideViewController:self.rightController];
                }
            }
            else if ([self isStatus:lastStatus onSameSideWithStatus:SNSlideStatusRight]) {
                if ([self.leftController respondsToSelector:@selector(slideControllerDidHideViewController:)]) {
                    [self.leftController slideControllerDidHideViewController:self.leftController];
                }
            }
        }
    }
}

@end
