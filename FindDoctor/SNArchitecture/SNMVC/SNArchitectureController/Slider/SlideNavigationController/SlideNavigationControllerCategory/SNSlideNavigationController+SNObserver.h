//
//  SNSlideNavigationController+SNObserver.h
//  YiRen
//
//  Created by Nova on 13-4-10.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNSlideNavigationController.h"

@interface SNSlideNavigationController (SNObserver)

- (BOOL)hasObservedController:(SNViewController *)controller;
- (BOOL)addObserverForController:(SNViewController *)controller;
- (BOOL)removeObserverForController:(SNViewController *)controller;
- (void)removeAllObservers;

@end
