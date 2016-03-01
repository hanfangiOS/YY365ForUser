//
//  UINavigationBar+Background.m
//  Weibo
//
//  Created by Kai on 10/24/11.
//  Copyright (c) 2011. All rights reserved.
//

#import "UINavigationBar+Background.h"
#import "UIImage+Color.h"
#import "SNControllerUIConstant.h"
#import "CUUIContant.h"

@implementation SNNavigationBar (Background)

- (void)useCustomBackgroundImage
{
    
}

- (void)useTranslucentBackgroundImage
{
//    [self setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]] forBarMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.shadowImage = [UIImage new];
    self.translucent = YES;
}

- (void)useBlackTranslucentBackgroundImage
{
    [self setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]] forBarMetrics:UIBarMetricsDefault];
}

- (void)useDefaultBlackBackgroundImage
{
    UIImage * bgImg = [UIImage imageNamed:ImgStr_NavBackground];
    if (bgImg == nil)
    {
        [self setBackgroundImage:[UIImage createImageWithColor:UIColorFromHex(Color_Hex_NavBackground)] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        [self setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
    }
}


@end