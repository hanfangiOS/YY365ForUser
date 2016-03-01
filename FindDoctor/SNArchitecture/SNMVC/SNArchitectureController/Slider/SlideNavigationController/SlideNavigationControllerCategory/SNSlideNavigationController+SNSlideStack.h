//
//  SNSlideNavigationController+SNSlideStack.h
//  YiRen
//
//  Created by Nova on 13-5-20.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNSlideNavigationController.h"

@interface SNSlideNavigationController (SNSlideStack)

- (SNViewController *)currentViewController;
- (SNViewController *)belowViewController;

// Data Management
- (void)addController:(SNViewController *)controller;
- (void)removeController:(SNViewController *)controller;

@end
