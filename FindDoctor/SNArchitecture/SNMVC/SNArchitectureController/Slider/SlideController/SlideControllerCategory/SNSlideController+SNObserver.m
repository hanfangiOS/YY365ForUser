//
//  SNSlideController+SNObserver.m
//  SNSlideController
//
//  Created by Nova on 13-4-9.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNSlideController+SNObserver.h"
#import "SNSlideController+SNGeometry.h"
#import "SNUISystemConstant.h"

@implementation SNSlideController (SNObserver)

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
    [self.observerDict setObject:controller forKey:controller.identifier];
    
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
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_7_0))
            {
                if (frame.origin.x > kXOffsetThreshold || frame.origin.x < -kXOffsetThreshold) {
                    [[UIApplication sharedApplication] setStatusBarHidden:YES];
                }
            }
            
            CGFloat ralpha = [self alphaForController:self.rightController withFrame:frame];
            CGFloat lalpha = [self alphaForController:self.leftController withFrame:frame];
            self.rightController.maskView.alpha = ralpha;
            self.leftController.maskView.alpha = lalpha;
            
#ifdef kUseTransformEffect
            CGFloat rscale = [self scaleForController:self.rightController withFrame:frame];
            CGFloat lscale = [self scaleForController:self.leftController withFrame:frame];
            self.rightController.view.transform = CGAffineTransformMakeScale(rscale, rscale);
            self.leftController.view.transform = CGAffineTransformMakeScale(lscale, lscale);
#endif
        }
    }
}

@end
