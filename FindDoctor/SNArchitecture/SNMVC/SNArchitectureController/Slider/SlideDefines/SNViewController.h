//
//  SNViewController.h
//  SNSlideController
//
//  Created by Nova on 13-4-2.
//  Copyright (c) 2013年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSlideControllerDelegate.h"
#import "SNSlideNavigationControllerDelegate.h"
#import "SNView.h"
//#import "SNOldNavigationBar+Background.h"
//#import "SNOldNavigationBar.h"
#import "SNTabBarItem.h"
#import "SNSlideNavigationController.h"
#import "SNNavigationBar.h"

//@class SNNavigationBar;
@class UIToolbar;
@class SNSlideController;

@interface SNViewController : UIViewController <SNSlideControllerDelegate, SNSlideNavigationControllerDelegate, SNViewDelegate>
{
    NSString *_identifier;
    NSString * _pageName;
    
    BOOL    _hasNavigationBar;            // Default YES
    BOOL    _hasToolbar;                  // Default NO
    BOOL    _hasRightViewController;      // Default NO
    
    CGFloat _navigationBarHeight;         // (hasNavi == YES) ? 44 : 0
    CGFloat _toolbarHeight;               // (hasTool == YES) ? 44 : 0
    
    UIView  *_maskView;
    
    SNNavigationBar             *_navigationBar;
    UIToolbar                   *_toolbar;
    SNSlideController           *_slideController;
    SNSlideNavigationController *_slideNavigationController;
    SNTabBarItem                *_customTabBarItem;
    BOOL                        _isPanValid;
    BOOL                        _canRotate;
}
@property (nonatomic, assign) BOOL canRotate;
@property (nonatomic, assign) BOOL isPanValid;
@property (nonatomic, retain,readonly) NSString *identifier;
@property (nonatomic,retain,readwrite)NSString * pageName;

@property (nonatomic, assign) BOOL  hasNavigationBar;
@property (nonatomic, assign) BOOL  hasToolbar;
@property (nonatomic, assign) BOOL  hasRightViewController;
@property (nonatomic, assign) BOOL  releaseViewWhileMemoryWarning;  // default is YES, while NO, do not release view while memory warning.

@property (nonatomic, assign) CGFloat  navigationBarHeight;
@property (nonatomic, assign) CGFloat  toolbarHeight;

@property (nonatomic, retain) UIView   *maskView;

@property (nonatomic, retain) SNNavigationBar               *navigationBar;
@property (nonatomic, retain) UIToolbar                     *toolbar;
@property (nonatomic, assign) SNSlideController             *slideController;
@property (nonatomic, assign) SNSlideNavigationController   *slideNavigationController;
@property (nonatomic, retain) SNTabBarItem                  *customTabBarItem;

- (instancetype)initWithPageName:(NSString *)pageName;

- (CGRect)subviewFrame;
- (SNViewController *)rightViewController;

- (void)setNavigationBarTintColor:(UIColor *)tintColor;
- (void)setNavigationBarBackgroundImage:(UIImage *)backgroundImage;
- (void)setToolbarTintColor:(UIColor *)tintColor;
- (void)setToolbarBackgroundImage:(UIImage *)backgroundImage;

/* 收取消息
 * 用于收取来自上一级或者下一级controller发送的消息
 * message类型为NSDictionary，传递消息的双方需自定义NSDictionary的协议，根据协议区分不同消息
 * viewController为传递此消息的controller
 */

- (void)handleMessage:(NSDictionary *)message viewController:(SNViewController *)viewController;

/**
 *  发生内存告警的时候,清除视图资源。如果子类有需要释放的资源时,需要重载此函数,以清除特定的资源。
 *
 *  @param shouldClean 是否可以清除视图
 */
- (void)cleanupViews:(BOOL)shouldClean;

- (void)backAction;
- (void)closeAction;

@end


