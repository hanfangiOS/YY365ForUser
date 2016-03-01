//
//  UINavigationController+CustomPop.m
//  YiRen
//
//  Created by nova on 12-10-18.
//  Copyright (c) 2012年. All rights reserved.
//

#import "UINavigationController+CustomPop.h"

@implementation UINavigationController (CustomPop)

- (UIViewController *)customPopViewControllerAnimated:(BOOL)animated
{
    if ([self.viewControllers count] <= 1) {
        return [self popViewControllerAnimated:animated];
    }
    
    if ([self.topViewController respondsToSelector:@selector(navigationController:willPopViewController:)])
    {
        [self.topViewController performSelector:@selector(navigationController:willPopViewController:) withObject:self withObject:self.topViewController];
    }
    
    if (self.topViewController.modalViewController)
    {
        [self.topViewController dismissModalViewControllerAnimated:NO];
    }
    
    return [self popViewControllerAnimated:animated];
}

- (NSArray *)customPopToRootViewControllerAnimated:(BOOL)animated
{
    for (int index = [self.viewControllers count]-1; index > 0; index--)
    {
        UIViewController *controller = [self.viewControllers objectAtIndex:index];
        if ([controller respondsToSelector:@selector(navigationController:willPopViewController:)])
        {
            [controller performSelector:@selector(navigationController:willPopViewController:) withObject:self withObject:controller];
        }
        if (controller.modalViewController)
        {
            [controller dismissModalViewControllerAnimated:NO];
        }
    }
    
    return [self popToRootViewControllerAnimated:animated];
}

- (void)cleanAllViewControllers
{
    for (int index = [self.viewControllers count]-1; index >= 0; index--)
    {
        UIViewController *controller = [self.viewControllers objectAtIndex:index];
        if ([controller respondsToSelector:@selector(navigationController:willPopViewController:)])
        {
            [controller performSelector:@selector(navigationController:willPopViewController:) withObject:self withObject:controller];
        }
    }
}

@end
