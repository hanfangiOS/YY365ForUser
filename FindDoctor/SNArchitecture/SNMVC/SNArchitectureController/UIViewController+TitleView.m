//
//  UIViewController+TitleView.m
//  HuiYangChe
//
//  Created by zhouzhenhua on 14-9-14.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import "UIViewController+TitleView.h"
//#import "SystemConstant.h"
#import "SNUISystemConstant.h"
#import "SNSlideDefines.h"
//#import "UIConstants.h"
#import "CUUIContant.h"

#define kNavOffset_Y                 (IS_IOS7 ? 20 : 0)

@implementation UIViewController (TitleView)

UILabel *navTitleLabel(NSString *title)
{
    UILabel *titleViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 44 * 2, 44)];
    titleViewLabel.font = [UIFont systemFontOfSize:17];
    titleViewLabel.textColor = UIColorFromHex(Color_Hex_NavText_Normal);
    titleViewLabel.text = title;
    titleViewLabel.backgroundColor = [UIColor clearColor];
    titleViewLabel.textAlignment = NSTextAlignmentCenter;
    titleViewLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    return titleViewLabel;
}

void changeViewControllerTitle(NSString *title,UIViewController *controller)
{
    UILabel *titleLabel = navTitleLabel(title);
    UIView *labelBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleLabel.frame), CGRectGetHeight(titleLabel.frame))];
    labelBg.tag = kNavigationItemAlignment_HC_VC;
    [labelBg addSubview:titleLabel];
    
    controller.navigationItem.titleView = labelBg;
}

- (void)changeNaigationTitle:(NSString *)title
{
    changeViewControllerTitle(title, self);
}

// 重写title显示
- (void)setTitle:(NSString *)title
{
    [self changeNaigationTitle:title];
}

@end
