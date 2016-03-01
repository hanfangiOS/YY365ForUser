//
//  UIBarButtonItem+SNExtension.h
//  CollegeUnion
//
//  Created by li na on 15/3/5.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIBarButtonItem (SNExtension)

+ (UIBarButtonItem *)leftBackButtonItemWithImageAndTitle;

+ (UIBarButtonItem *)buttonItemWithTitleAndImage:(NSString *)imageName title:(NSString *)title;
@end
