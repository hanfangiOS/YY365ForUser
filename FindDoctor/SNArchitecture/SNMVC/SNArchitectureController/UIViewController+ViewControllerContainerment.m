//
//  UIViewController+ViewControllerContainerment.m
//  YiRen
//
//  Created by frost on 14-3-10.
//  Copyright (c) 2014年. All rights reserved.
//

#import "UIViewController+ViewControllerContainerment.h"

@implementation UIViewController (ViewControllerContainerment)

- (void)sn_addChildViewController:(UIViewController *)controller
{
    @try
    {
        if (controller.parentViewController != self)
        {
            [self addChildViewController:controller];
        }
        else
        {
        }
    }
    @catch (NSException *exception)
    {
        
    }
}

- (void)sn_removeFromParentViewController
{
    @try
    {
        if (self.parentViewController)
        {
            [self removeFromParentViewController];
        }
        else
        {
            
        }
    }
    @catch (NSException *exception)
    {
        
    }
}

@end
