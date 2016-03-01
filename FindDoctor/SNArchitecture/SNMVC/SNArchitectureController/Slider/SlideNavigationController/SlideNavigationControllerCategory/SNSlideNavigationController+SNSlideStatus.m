//
//  SNSlideNavigationController+SNSlideStatus.m
//  SNSlideController
//
//  Created by Nova on 13-4-2.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNSlideNavigationController+SNSlideStatus.h"
#import "SNSlideNavigationController+SNControllerHierarchy.h"
#import "SNSlideNavigationController+SNGeometry.h"
#import "UIViewController+SNSlideStatus.h"
#import "SNSlideController.h"
#import "SNSlideNavigationController+SNSlideStack.h"

@implementation SNSlideNavigationController (SNSlideStatus)

- (void)setStatus:(SNSlideStatus)status
    forController:(UIViewController *)controller
         animated:(BOOL)animated usingBounce:(BOOL)bounce
     onCompletion:(void (^)(void))completionBlock
{
    switch (status) {
        case SNSlideStatusCenter:
        case SNSlideStatusRightOutOfScreen:
        {
            [self moveController:controller toStatus:status animated:animated usingBounce:bounce onCompletion:completionBlock];
        }
            break;
            
        case SNSlideStatusLeft:
        case SNSlideStatusLeftOutOfScreen:
        case SNSlideStatusRight:
            break;
            
            //TODO
            
        default:
            break;
    }
}

- (void)moveController:(UIViewController *)controller
              toStatus:(SNSlideStatus)status
              animated:(BOOL)animated
           usingBounce:(BOOL)bounce
          onCompletion:(void (^)(void))completionBlock
{
    CGRect frame = controller.view.frame;
    
    SNViewController *belowController = [self controllerBelowController:controller];
#ifdef kUseTransformEffect
    CGFloat oscale = [self scaleForController:belowController withFrame:frame];
#endif
    
    CGFloat oalpha = [self alphaForController:belowController withFrame:frame];
    
    CGRect bounceFrame = frame;
    switch (status) {
        case SNSlideStatusCenter:
        {
            controller.view.userInteractionEnabled = YES;
            frame.origin.x = 0;
            bounceFrame = CGRectOffset(frame, (-1)*kBounceDistance, 0.0f);
        }
            break;
            
        case SNSlideStatusRightOutOfScreen:
        {
            frame.origin.x = CGRectGetMaxX(self.view.bounds)+kShadowRaidus;
        }
            break;
            
        case SNSlideStatusLeft:
        case SNSlideStatusLeftOutOfScreen:
        case SNSlideStatusRight:
            break;
            
        default:
            break;
    }
    
#ifdef kUseTransformEffect
    CGFloat scale = [self scaleForController:belowController withFrame:frame];
    CGFloat bscale = [self scaleForController:belowController withFrame:bounceFrame];
#endif
    
    CGFloat alpha = [self alphaForController:belowController withFrame:frame];
    CGFloat balpha = [self alphaForController:belowController withFrame:bounceFrame];
    
    self.layouting = YES;
    
    if (animated) {
#ifdef kUseTransformEffect
        belowController.view.transform = CGAffineTransformMakeScale(oscale, oscale);
#endif
        
        belowController.maskView.alpha = oalpha;
        
        if (bounce == NO || status == SNSlideStatusRightOutOfScreen) {
            [UIView animateWithDuration:kSlideNaviAnimationDuration delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
                controller.view.frame = frame;
                
#ifdef kUseTransformEffect
                belowController.view.transform = CGAffineTransformMakeScale(scale, scale);
#endif
                
                belowController.maskView.alpha = alpha;
            } completion:^(BOOL finished) {
                if (completionBlock) {
                    completionBlock();
                }
                self.layouting = NO;
            }];
        }
        else {
            [UIView animateWithDuration:kSlideNaviAnimationDuration delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
                controller.view.frame = bounceFrame;
                
#ifdef kUseTransformEffect
                belowController.view.transform = CGAffineTransformMakeScale(bscale, bscale);
#endif
                
                belowController.maskView.alpha = balpha;
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:kBounceAnimationDuration delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
                        controller.view.frame = frame;
                        
#ifdef kUseTransformEffect
                        belowController.view.transform = CGAffineTransformMakeScale(scale, scale);
#endif
                        
                        belowController.maskView.alpha = alpha;
                    } completion:^(BOOL finished) {
                        if (completionBlock) {
                            completionBlock();
                        }
                        self.layouting = NO;
                    }];
                }
                else {
                    controller.view.frame = frame;
                    
#ifdef kUseTransformEffect
                    belowController.view.transform = CGAffineTransformMakeScale(scale, scale);
#endif
                    
                    belowController.maskView.alpha = alpha;
                    
                    if (completionBlock) {
                        completionBlock();
                    }
                    self.layouting = NO;
                }
            }];
        }
    }
    else {
        controller.view.frame = frame;
        
#ifdef kUseTransformEffect
        belowController.view.transform = CGAffineTransformMakeScale(scale, scale);
#endif
        
        belowController.maskView.alpha = alpha;
        if (completionBlock) {
            completionBlock();
        }
        self.layouting = NO;
    }
}

@end
