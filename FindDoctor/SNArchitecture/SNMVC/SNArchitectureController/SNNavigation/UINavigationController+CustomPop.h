//
//  UINavigationController+CustomPop.h
//  YiRen
//
//  Created by nova on 12-10-18.
//  Copyright (c) 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UINavigationControllerPopDelegate

@optional
/**
 *
 * 如果viewController调用customPop方法
 * 该方法会在viewController推出之前调用，viewController在此方法中清理资源
 * 
 */
- (void)navigationController:(UINavigationController *)navigationController willPopViewController:(UIViewController *)viewController;

@end

/**
 *
 * CustomPop Category
 *
 * 自定义了popViewControllerAnimated:和popToRootViewControllerAnimated:方法
 * 自定义的方法中会检测viewController是否实现了UINavigationControllerPopDelegate的navigationController:willPopViewController:
 *
 * 系统的pop方法，在viewController推出之前没有回调，有些viewController必须在pop之前进行一些清理工作
 *
 * 比如正文的viewController必须在pop之前移除广告，否则会导致controller无法释放，
 * 其他Controller如果调用popToRoot操作，就会导致内存泄漏
 * 所以必须使用customPopToRootViewControllerAnimated:替代系统的popToRootViewControllerAnimated:方法
 */

@interface UINavigationController (CustomPop)

- (UIViewController *)customPopViewControllerAnimated:(BOOL)animated;

- (NSArray *)customPopToRootViewControllerAnimated:(BOOL)animated;

- (void)cleanAllViewControllers;

@end
