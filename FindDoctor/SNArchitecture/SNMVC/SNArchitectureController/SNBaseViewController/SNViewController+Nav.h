//
//  SNViewController+Nav.h
//  CollegeUnion
//
//  Created by li na on 15/5/17.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "SNViewController.h"

@interface SNViewController (Nav)

/** < 返回 **/
- (void)addLeftBackButtonItemWithImageAndTitle;
/** < **/
- (void)addLeftBackButtonItemWithImage;
/** 返回 **/
//- (void)addLeftBackButtonItemWithTitle;

/** x 关闭 **/
- (void)addLeftCloseButtonItemWithImageAndTitle;
/** x **/
- (void)addLeftCloseButtonItemWithImage;
/** 关闭 **/
- (void)addLeftCloseButtonItemWithTitle;

//- (UIBarButtonItem *)newButtonItemWithTitleAndImage:(NSString *)imageName title:(NSString *)title target:(id)target action:(SEL)selector;

@end
