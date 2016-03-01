//
//  SNSlideControllerDelegate.h
//  YiRen
//
//  Created by Nova on 13-4-3.
//  Copyright (c) 2013年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNSlideDefines.h"

@protocol SNSlideControllerDelegate <NSObject>

@optional
- (void)slideControllerWillChangeTopViewController:(SNViewController *)viewController;
- (void)slideControllerDidSlideViewController:(SNViewController *)viewController toStatus:(SNSlideStatus)status;
- (void)slideControllerDidShowViewController:(SNViewController *)viewController;
- (void)slideControllerDidHideViewController:(SNViewController *)viewController;

@end
