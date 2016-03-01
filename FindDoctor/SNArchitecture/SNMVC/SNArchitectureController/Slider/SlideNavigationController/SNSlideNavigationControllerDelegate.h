//
//  SNSlideNavigationControllerDelegate.h
//  YiRen
//
//  Created by Nova on 13-4-7.
//  Copyright (c) 2013年. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SNSlideNavigationController;

@protocol SNSlideNavigationControllerDelegate <NSObject>

@optional
/**
 *
 * 如果viewController调用pop方法
 * 该方法会在viewController推出之前调用，viewController在此方法中清理资源
 *
 */
- (void)slideNavigationController:(SNSlideNavigationController *)slideNavigationController willPopViewController:(UIViewController *)viewController;
- (void)slideNavigationController:(SNSlideNavigationController *)slideNavigationController didPopViewController:(UIViewController *)viewController;

- (void)slideNavigationController:(SNSlideNavigationController *)slideNavigationController didPushViewController:(UIViewController *)viewController;

@end
