//
//  SNTabBar.h
//  tabbar
//
//  Created by nova on 12-12-25.
//  Copyright (c) 2012年 SINA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNTopTabBarItem.h"

@protocol SNTopTabBarDelegate;

@interface SNTopTabBar : UIView

@property (nonatomic, weak) id<SNTopTabBarDelegate> delegate;
@property (nonatomic, strong) NSArray             *items;
@property (nonatomic, strong) UIImage             *backgroundImage;
@property (nonatomic, strong) UIImage             *selectionIndicatorImage;
@property (nonatomic, strong) UIImage             *shadowImage;
@property (nonatomic, strong) SNTopTabBarItem        *selectedItem;
@property (nonatomic) BOOL                 animateSelection;
@property (nonatomic) NSUInteger           selectedIndex;
@property (nonatomic) BOOL showBottomLine;
@property (nonatomic) CGFloat bottomLineWidth;

- (void)setItems:(NSArray *)items animated:(BOOL)animated;

@end

@protocol SNTopTabBarDelegate<NSObject>

@optional
- (void)tabBar:(SNTopTabBar *)tabBar didSelectItemAtIndex:(NSUInteger)index tabBarItem:(SNTopTabBarItem*)item;

@end
