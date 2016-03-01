//
//  SNSlideNavigationController+SNObserver.m
//  YiRen
//
//  Created by Nova on 13-4-10.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNSlideNavigationController+SNObserver.h"
#import "SNSlideNavigationController+SNGeometry.h"
#import "SNSlideNavigationController+SNControllerHierarchy.h"
#import "SNViewController.h"

@implementation SNSlideNavigationController (SNObserver)

- (BOOL)hasObservedController:(SNViewController *)controller
{
    id observer = [self.observerDict objectForKey:controller.identifier];
    return (observer != nil);
}

- (BOOL)addObserverForController:(SNViewController *)controller
{
    if ([self hasObservedController:controller]) {
        return NO;
    }
    
    [controller.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [self.observerDict setObject:@"YES" forKey:controller.identifier];
    
    return YES;
}

- (BOOL)removeObserverForController:(SNViewController *)controller
{
    if (![self hasObservedController:controller]) {
        return NO;
    }
    
    [controller.view removeObserver:self forKeyPath:@"frame"];
    [self.observerDict removeObjectForKey:controller.identifier];
    
    return YES;
}

- (void)removeAllObservers
{
    for (SNViewController *viewController in self.observerDict.allValues) {
        [viewController.view removeObserver:self forKeyPath:@"frame"];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        id object = [change objectForKey:NSKeyValueChangeNewKey];
        if ([object respondsToSelector:@selector(CGRectValue)]) {
            CGRect frame = [object CGRectValue];
            
            SNViewController *belowController = [self controllerBelowController:self.selectedController];
            if (belowController) {
                CGFloat alpha = [self alphaForController:belowController withFrame:frame];
                belowController.maskView.alpha = alpha;
                
#ifdef kUseTransformEffect
                CGFloat scale = [self scaleForController:belowController withFrame:frame];
                belowController.view.transform = CGAffineTransformMakeScale(scale, scale);
#endif
            }
        }
    }
}

@end
