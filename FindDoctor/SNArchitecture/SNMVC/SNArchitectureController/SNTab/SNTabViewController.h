//
//  SNTabViewController.h
//  YiRen
//
//  Created by frostfeng on 14-3-6.
//  Copyright (c) 2014年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNViewController.h"
#import "SNTabBar.h"


#define SNTabBarDefaultSelctedIndex      0

#define kSNTabViewControllerDidChangeNotification    @"SNTabViewControllerDidChangeNotification"

@protocol SNTabBarTapDelegate;
@interface SNTabViewController : SNViewController

@property(nonatomic, assign) NSUInteger selectedIndex;
@property(nonatomic, copy) NSArray *viewControllers;
@property(nonatomic, assign, readonly) SNViewController * selectedViewController;
@property (nonatomic, assign,readonly) CGFloat  tabBarHeight;

- (instancetype)initWithHeight:(NSInteger)height;
@property (nonatomic, retain) SNTabBar      *customTabBar;

@end

#pragma mark ----------- SNTabBarTapDelegate -----------

@protocol SNTabBarTapDelegate <NSObject>

@optional

- (void)tabViewControllerDoubleTap:(SNTabViewController *)tabBarController;
- (void)tabViewControllerSingleTap:(SNTabViewController *)tabBarController;
- (void)tabViewControllerChangeSelectTap:(SNTabViewController *)tabBarController;

@end


