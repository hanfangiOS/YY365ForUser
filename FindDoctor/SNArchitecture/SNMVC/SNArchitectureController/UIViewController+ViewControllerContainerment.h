//
//  UIViewController+ViewControllerContainerment.h
//  YiRen
//
//  Created by frost on 14-3-10.
//  Copyright (c) 2014年. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ViewControllerContainerment)

- (void)sn_addChildViewController:(UIViewController *)controller;
- (void)sn_removeFromParentViewController;

@end
