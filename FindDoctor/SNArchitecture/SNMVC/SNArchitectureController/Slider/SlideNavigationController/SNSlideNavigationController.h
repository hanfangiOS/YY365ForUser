//
//  SNSlideNavigationController.h
//  SNSlideController
//
//  Created by Nova on 13-4-2.
//  Copyright (c) 2013年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSlideDefines.h"

@class SNViewController;

@interface SNSlideNavigationController : UIViewController <UIGestureRecognizerDelegate>
{
    NSMutableArray      *_viewControllers;
    NSMutableDictionary *_observerDict;
    
    UIPanGestureRecognizer *_panGestureRecognizer;
    
    BOOL _panValid;
    BOOL _layouting;
    
    SNViewController *_selectedController;
    SNViewController *_rootViewController;
}

@property (nonatomic, retain) NSMutableArray        *viewControllers;
@property (nonatomic, retain) NSMutableDictionary   *observerDict;

@property (nonatomic, readonly, retain) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, retain) SNViewController *selectedController;
@property (nonatomic, readonly, retain) SNViewController *rootViewController;

@property (nonatomic, assign, getter = isPanValid)  BOOL panValid;
@property (nonatomic, assign, getter = isLayouting) BOOL layouting;

- (id)initWithRootViewController:(SNViewController *)rootViewController;

- (void)pushViewController:(SNViewController *)viewController animated:(BOOL)animated;
- (SNViewController *)popViewControllerAnimated:(BOOL)animated;
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (NSArray *)popToViewControllerAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated;
- (void)clearAllViewControllers;

/* push的同时传递消息
 * 用于发送消息给下一级controller，下一级controller会自动通过 handleMessage:(NSDictionary *)message来收取消息
 * message类型为NSDictionary，传递消息的双方需自定义NSDictionary的协议，根据协议区分不同消息
 */
- (void)pushViewController:(SNViewController *)viewController animated:(BOOL)animated message:(NSDictionary *)message;

/* 发送消息给上一级controller
 * 用于发送消息给上一级controller，上一级controller会自动通过 handleMessage:(NSDictionary *)message来收取消息
 * message类型为NSDictionary，传递消息的双方需自定义NSDictionary的协议，根据协议区分不同消息
 * viewController为发送此消息的controller
 */
- (void)postMessageToParentViewController:(NSDictionary *)message viewController:(SNViewController *)viewController;
- (void)postMessageToViewController:(NSDictionary *)message viewController:(SNViewController *)viewController;

@end
