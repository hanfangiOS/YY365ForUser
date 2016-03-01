//
//  SNSlideNavigationController+SNControllerHierarchy.h
//  SNSlideController
//
//  Created by Nova on 13-4-2.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNSlideNavigationController.h"

@interface SNSlideNavigationController (SNControllerHierarchy)

- (SNViewController *)controllerBelowController:(UIViewController *)viewController;

// Layout controller's view, set frame, add shadow
- (void)layoutControllers;

// Set status of selectedController
- (void)layoutSelectedController:(SNViewController *)controller
                andPanGestureRecognizer:(UIPanGestureRecognizer *)gesture;

- (void)layoutSelectedController:(SNViewController *)controller
                              andStatus:(SNSlideStatus)status
                            usingBounce:(BOOL)usingBounce;

- (void)layoutCurrentSelectedController:(SNViewController *)controller
                                     andStatus:(SNSlideStatus)status
                                   usingBounce:(BOOL)usingBounce;

@end
