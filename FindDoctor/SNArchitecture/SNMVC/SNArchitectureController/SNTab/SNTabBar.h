//
//  SNTabBar.h
//  tabbar
//
//  Created by nova on 12-12-25.
//  Copyright (c) 2012年 SINA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNTabBarItem.h"

@protocol SNTabBarDelegate;

@interface SNTabBar : UIView

@property (nonatomic, weak) id<SNTabBarDelegate> delegate;
@property (nonatomic, strong) NSArray             *items;
@property (nonatomic, strong) UIImage             *backgroundImage;
@property (nonatomic, strong) UIImage             *selectionIndicatorImage;
@property (nonatomic, strong) UIImage             *shadowImage;
@property (nonatomic, strong) SNTabBarItem        *selectedItem;
@property (nonatomic) BOOL                 animateSelection;
@property (nonatomic) NSUInteger           selectedIndex;

- (void)setItems:(NSArray *)items animated:(BOOL)animated;
- (void)didClickTabBarItem:(SNTabBarItem *)item;

@end

@protocol SNTabBarDelegate<NSObject>

@optional
- (void)tabBar:(SNTabBar *)tabBar didSelectItemAtIndex:(NSUInteger)index tabBarItem:(SNTabBarItem*)item;

@end
