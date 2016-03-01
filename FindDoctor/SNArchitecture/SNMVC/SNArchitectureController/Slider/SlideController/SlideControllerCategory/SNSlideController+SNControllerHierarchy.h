//
//  SNSlideController+SNControllerHierarchy.h
//  SNSlideController
//
//  Created by Nova on 13-4-2.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNSlideController.h"

@interface SNSlideController (SNControllerHierarchy)

// Used in @method -(void)changeTopWith:attribute:animated:
- (void)resetOldTopController:(SNViewController *)oldCont withNewTopController:(SNViewController *)newCont;

// Reset controllers below controller, frame = self.view.bounds, enable userInteraction.
- (void)resetControllersWithController:(SNViewController *)controller
                                status:(SNSlideStatus)status
                          indexInStack:(NSInteger)index;

// Change currentController when status changes.
- (void)resetCurrentControllerWithController:(SNViewController *)controller status:(SNSlideStatus)status;
- (void)resetCurrentControllerWithController:(SNViewController *)controller andSideController:(SNViewController *)sideController;

// Layout controller's view, set frame, add shadow
- (void)layoutControllers;

// Modify controller hierarchy according to topController's status.
- (void)layoutControllersWithSelectedController:(SNViewController *)controller translation:(CGPoint)translation;

// Set status of selectedController
- (void)layoutSelectedController:(SNViewController *)controller withPanGestureRecognizer:(UIPanGestureRecognizer *)gesture;

- (void)bringController:(SNViewController *)controller toFrontOfController:(SNViewController *)anotherController;
- (void)bringControllerToFront:(UIViewController *)controller;
- (void)sendControllerToBack:(UIViewController *)controller;
- (SNViewController *)controllerBelow:(SNViewController *)controller withStatus:(SNSlideStatus)status;

@end
