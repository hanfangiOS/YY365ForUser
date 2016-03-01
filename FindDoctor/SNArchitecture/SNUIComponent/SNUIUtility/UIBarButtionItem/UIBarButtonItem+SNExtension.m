//
//  UIBarButtonItem+SNExtension.m
//  CollegeUnion
//
//  Created by li na on 15/3/5.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "UIBarButtonItem+SNExtension.h"

@implementation UIBarButtonItem(SNExtension)

+ (UIBarButtonItem *)leftBackButtonItemWithImageAndTitle;
{
    // 选择城市
    UIView* leftButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.backgroundColor = [UIColor clearColor];
    leftButton.frame = leftButtonView.frame;
    [leftButton setImage:[UIImage imageNamed:@"navbaritem_downarrow_button"] forState:UIControlStateNormal];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
//    leftButton.tintColor = UIColorFromHex(Color_Hex_NavText_Normal);
    leftButton.autoresizesSubviews = YES;
    leftButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
//    [leftButton addTarget:self action:@selector(changeCity) forControlEvents:UIControlEventTouchUpInside];
    [leftButtonView addSubview:leftButton];
    
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
    return leftBarButton;

}

//+ (UIBarButtonItem *)buttonItemWithTitleAndImage:(NSString *)imageName title:(NSString *)title
//{
//    
//}

@end
