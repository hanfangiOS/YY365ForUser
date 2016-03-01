//
//  SNSlideController+SNObserver.h
//  SNSlideController
//
//  Created by Nova on 13-4-9.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNSlideController.h"

@interface SNSlideController (SNObserver)

- (BOOL)hasObservedController:(SNViewController *)controller;
- (BOOL)addObserverForController:(SNViewController *)controller;
- (BOOL)removeObserverForController:(SNViewController *)controller;
- (void)removeAllObservers;

@end
