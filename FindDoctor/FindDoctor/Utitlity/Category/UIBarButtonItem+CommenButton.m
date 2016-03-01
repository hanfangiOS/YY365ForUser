//
//  UIBarButtonItem+CommenButton.m
//  HuiYangChe
//
//  Created by zhouzhenhua on 14-9-20.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import "UIBarButtonItem+CommenButton.h"
#import "UIConstants.h"
#import "SNSlideDefines.h"

#define kNavButtonOriginY      kNavigationDelY
#define kNavButtonHeight       (kNavigationHeight - kNavigationDelY)
#define kNavButtonWidth        kNavButtonHeight

@implementation UIBarButtonItem (CommenButton)

+ (UIBarButtonItem *)backItemWithTarget:(id)target action:(SEL)action
{
    return [self leftItemWithImage:[UIImage imageNamed:ImgStr_BackBtn] hilightImage:[UIImage imageNamed:ImgStr_BackBtn] target:target action:action];
}

+ (UIBarButtonItem *)closeItemWithTarget:(id)target action:(SEL)action
{
    return [self leftItemWithImage:[UIImage imageNamed:imgStr_CloseBtn] hilightImage:[UIImage imageNamed:imgStr_CloseBtn] target:target action:action];
}

+ (UIBarButtonItem *)searchItemWithTarget:(id)target action:(SEL)action
{
    return [self rightItemWithImage:[UIImage imageNamed:@"navigationbar_icon_search"] hilightImage:[UIImage imageNamed:@"navigationbar_icon_search_highlighted"] target:target action:action];
}

+ (UIBarButtonItem *)cityItemWithCityTitle:(NSString *)title Target:(id)target action:(SEL)action
{
    return nil;
}

+ (UIBarButtonItem *)leftItemWithImage:(UIImage *)image hilightImage:(UIImage *)hilightImage target:(id)target action:(SEL)action
{
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNavButtonWidth, kNavButtonHeight)];
    buttonView.backgroundColor = [UIColor clearColor];
    buttonView.tag = kNavigationItemAlignment_HL_VC;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = buttonView.bounds;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:hilightImage forState:UIControlStateHighlighted];
    [buttonView addSubview:button];
    
    return [[UIBarButtonItem alloc] initWithCustomView:buttonView];
}

+ (UIBarButtonItem *)rightItemWithImage:(UIImage *)image hilightImage:(UIImage *)hilightImage target:(id)target action:(SEL)action
{
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kNavButtonWidth, kNavButtonHeight)];
    buttonView.backgroundColor = [UIColor clearColor];
    buttonView.tag = kNavigationItemAlignment_HR_VC;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = buttonView.bounds;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:hilightImage forState:UIControlStateHighlighted];
    [buttonView addSubview:button];
    
    return [[UIBarButtonItem alloc] initWithCustomView:buttonView];
}

+ (UIBarButtonItem *)rightItemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:16]];
    titleSize.width = ceilf(titleSize.width);
    
    float labelPadding = 12;
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleSize.width + labelPadding * 2, 44)];
    buttonView.backgroundColor = [UIColor clearColor];
    buttonView.tag = kNavigationItemAlignment_HR_VC;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 4, CGRectGetWidth(buttonView.frame), 40);
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:.3] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [buttonView addSubview:button];
    
    return [[UIBarButtonItem alloc] initWithCustomView:buttonView];
}

+ (UIBarButtonItem *)leftItemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:16]];
    titleSize.width = ceilf(titleSize.width);
    
    float labelPadding = 12;
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleSize.width + labelPadding * 2, 44)];
    buttonView.backgroundColor = [UIColor clearColor];
    buttonView.tag = kNavigationItemAlignment_HL_VC;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 4, CGRectGetWidth(buttonView.frame), 40);
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:.3] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [buttonView addSubview:button];
    
    return [[UIBarButtonItem alloc] initWithCustomView:buttonView];
}

@end
