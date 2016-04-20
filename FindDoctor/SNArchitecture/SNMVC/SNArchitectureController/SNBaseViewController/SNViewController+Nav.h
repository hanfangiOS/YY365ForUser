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

/** 设置 **/

- (UIButton *)addRightButtonItemWithTitle:(NSString *)title  action:(SEL)selector;

/** 右上角图片 **/
- (UIButton *)addRightButtonItemWithImage:(UIImage *)image action:(SEL)selector;

//- (UIBarButtonItem *)newButtonItemWithTitleAndImage:(NSString *)imageName title:(NSString *)title target:(id)target action:(SEL)selector;

@end
