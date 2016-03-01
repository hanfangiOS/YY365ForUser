//
//  UIBarButtonItem+CommenButton.h
//  HuiYangChe
//
//  Created by zhouzhenhua on 14-9-20.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CommenButton)

+ (UIBarButtonItem *)backItemWithTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem *)closeItemWithTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem *)searchItemWithTarget:(id)target action:(SEL)action;

+ (UIBarButtonItem *)rightItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)leftItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)cityItemWithCityTitle:(NSString *)title Target:(id)target action:(SEL)action;

@end
