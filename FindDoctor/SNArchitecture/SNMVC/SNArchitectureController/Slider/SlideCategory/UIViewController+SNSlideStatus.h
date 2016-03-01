//
//  UIViewController+SNSlideStatus.h
//  SNSlideController
//
//  Created by Nova on 13-4-2.
//  Copyright (c) 2013年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSlideDefines.h"

@interface UIViewController (SNSlideStatus)

- (BOOL)isLeftStatus:(SNSlideStatus)status;
- (BOOL)isRightStatus:(SNSlideStatus)status;
- (BOOL)isStatus:(SNSlideStatus)statusOne onSameSideWithStatus:(SNSlideStatus)statusTwo;

- (SNSlideStatus)statusForController:(UIViewController *)controller;

@end
