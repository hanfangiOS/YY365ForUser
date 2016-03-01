//
//  SNTabBarItem.h
//  tabbar
//
//  Created by nova on 12-12-25.
//  Copyright (c) 2012年 SINA. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define kSNTarBarItemTitleFontName       BOLD_FONT_NAME
#define kSNTabBarItemTitleFontSize       12

#define kSNTabBarItemImgTitleInterval    0.5

#define kSNTabBarItemBadgeViewTPadding   3
#define kSNTabBarItemBadgeViewRPadding   10

@class SNBadgeView;

@interface SNTopTabBarItem : UIButton
{
    UIImageView  *_badgeView;
}

@property (nonatomic, strong) UIImage      *image;
@property (nonatomic, strong) UIImage      *highlightedImage;
@property (nonatomic, strong) UIImage      *selectedImage;
@property (nonatomic, strong) NSString     *title;
@property (nonatomic, strong) UIColor      *titleColor;
@property (nonatomic, strong) UIColor      *highlightedTitleColor;
@property (nonatomic, strong) UIColor      *selectedTitleColor;

@property (nonatomic, strong) UIImage      *badgeImage;

@property (nonatomic, assign) BOOL          showTitle;
@property (nonatomic, assign) BOOL          showBadgeIndicator;

- (void)showBadge;
- (void)hideBadge;

@end
