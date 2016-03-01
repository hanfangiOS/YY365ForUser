//
//  SNTabViewController.h
//  YiRen
//
//  Created by frostfeng on 14-3-6.
//  Copyright (c) 2014年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNViewController.h"

#define SNTabBarDefaultSelctedIndex      0

#define kSNTabViewControllerDidChangeNotification    @"SNTabViewControllerDidChangeNotification"

@protocol SNTopTabBarTapDelegate;
@interface SNTopTabViewController : SNViewController

@property(nonatomic, assign) NSUInteger selectedIndex;
@property(nonatomic, copy) NSArray *viewControllers;
@property(nonatomic, assign, readonly) UIViewController * selectedViewController;
@property (nonatomic, assign,readonly) CGFloat  tabBarHeight;
@property (nonatomic) BOOL showBottomLine;
@property (nonatomic) CGFloat bottomLineWidth;

- (instancetype)initWithHeight:(NSInteger)height;

@end

#pragma mark ----------- SNTabBarTapDelegate -----------

@protocol SNTopTabBarTapDelegate <NSObject>

@optional

- (void)tabViewControllerDoubleTap:(SNTopTabViewController *)tabBarController;
- (void)tabViewControllerSingleTap:(SNTopTabViewController *)tabBarController;
- (void)tabViewControllerChangeSelectTap:(SNTopTabViewController *)tabBarController;

@end


