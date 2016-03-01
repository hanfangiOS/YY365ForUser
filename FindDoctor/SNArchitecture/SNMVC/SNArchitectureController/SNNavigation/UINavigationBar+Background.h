//
//  UINavigationBar+Background.h
//  Weibo
//
//  Created by Kai on 10/24/11.
//  Copyright (c) 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNNavigationBar.h"

#define kNavigationBarBackgroundImageTag                            2001
#define kNavigationBarBlackTranslucentBackgroundImageTag			2002
#define kNavigationBarTranslucentBackgroundImageTag                 2003


@interface SNNavigationBar (Background)

- (void)useCustomBackgroundImage;

- (void)useTranslucentBackgroundImage;

- (void)useBlackTranslucentBackgroundImage;

- (void)useDefaultBlackBackgroundImage;


@end
