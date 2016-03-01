//
//  SNViewController+Nav.m
//  CollegeUnion
//
//  Created by li na on 15/5/17.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "SNViewController+Nav.h"
#import "CUUIContant.h"
#import "SNViewController+ServerAPI.h"

@implementation SNViewController (Nav)

- (void)addLeftBackButtonItemWithImage
{
    UIView* leftButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 45, 50)];
    leftButtonView.tag = kNavigationItemAlignment_HL_VC;
    
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.backgroundColor = [UIColor clearColor];
    leftButton.frame = leftButtonView.frame;
    [leftButton setImage:[UIImage imageNamed:ImgStr_BackBtn] forState:UIControlStateNormal];
    //    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -23, 0, 0);
    //    leftButton.autoresizesSubviews = YES;
    //    leftButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButtonView addSubview:leftButton];
    
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)addLeftCloseButtonItemWithImage
{
    UIView* leftButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 45, 50)];
    leftButtonView.tag = kNavigationItemAlignment_HL_VC;
    
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.backgroundColor = [UIColor clearColor];
    leftButton.frame = leftButtonView.frame;
    [leftButton setImage:[UIImage imageNamed:imgStr_CloseBtn] forState:UIControlStateNormal];
    //    [leftButton setTitle:@"关闭" forState:UIControlStateNormal];
    //    leftButton.tintColor = UIColor_NavbarItem;
    //    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);
    
    [leftButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButtonView addSubview:leftButton];
    
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
    self.navigationItem.leftBarButtonItem = leftBarButton;}

- (void)addLeftBackButtonItemWithImageAndTitle
{
//    self.navigationItem.leftBarButtonItem = [self newButtonItemWithTitleAndImage:@"navbar_back_button" title:@"返回" target:self action:@selector(backAction)];
    
    UIView* leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.backgroundColor = [UIColor clearColor];
    leftButton.frame = leftButtonView.frame;
    [leftButton setImage:[UIImage imageNamed:ImgStr_BackBtn] forState:UIControlStateNormal];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.tintColor = UIColorFromHex(Color_Hex_NavItem_Normal);
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);
    
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButtonView addSubview:leftButton];
    
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
    self.navigationItem.leftBarButtonItem = leftBarButton;

}

- (void)addLeftCloseButtonItemWithTitle
{
    UIView* leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 50)];
    
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.backgroundColor = [UIColor clearColor];
    leftButton.frame = leftButtonView.frame;
    [leftButton setTitle:@"关闭" forState:UIControlStateNormal];
    leftButton.tintColor = UIColorFromHex(Color_Hex_NavItem_Normal);
//    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [leftButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButtonView addSubview:leftButton];
    
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    

}

- (void)addLeftCloseButtonItemWithImageAndTitle
{
    //    self.navigationItem.leftBarButtonItem = [self newButtonItemWithTitleAndImage:@"navbar_back_button" title:@"返回" target:self action:@selector(backAction)];
    
    UIView* leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.backgroundColor = [UIColor clearColor];
    leftButton.frame = leftButtonView.frame;
    [leftButton setImage:[UIImage imageNamed:imgStr_CloseBtn] forState:UIControlStateNormal];
    [leftButton setTitle:@"关闭" forState:UIControlStateNormal];
    leftButton.tintColor = UIColorFromHex(Color_Hex_NavItem_Normal);
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);
    
    [leftButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButtonView addSubview:leftButton];
    
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
}


- (UIBarButtonItem *)newButtonItemWithTitleAndImage:(NSString *)imageName title:(NSString *)title target:(id)target action:(SEL)selector
{
    UIView* leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.backgroundColor = [UIColor clearColor];
    leftButton.frame = leftButtonView.frame;
    [leftButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [leftButton setTitle:title forState:UIControlStateNormal];
    leftButton.tintColor = UIColorFromHex(Color_Hex_NavItem_Normal);
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);
    
    [leftButton addTarget:self action:@selector(selector) forControlEvents:UIControlEventTouchUpInside];
    [leftButtonView addSubview:leftButton];
    
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
    
    return leftBarButton;
    
}

@end
