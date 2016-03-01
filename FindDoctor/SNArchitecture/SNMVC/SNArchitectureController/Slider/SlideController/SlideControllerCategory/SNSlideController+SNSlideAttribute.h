//
//  SNSlideController+SNSlideAttribute.h
//  SNSlideController
//
//  Created by Nova on 13-4-1.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNSlideController.h"

@interface SNSlideController (SNSlideAttribute)

/* init
 * topController, self.leftControllers -> slideToRightEnable = YES,
 *                self.rightControllers -> slideToLeftEnable = YES
 * leftController, slideToRightEnable = YES, others = NO
 * rightController, slideToLeftEnable = YES, others = NO
 */
- (void)initAttributes;

- (SNSlideAttribute)defaultAttribute;
- (SNSlideAttribute)defaultAttributeForTopController;
- (SNSlideAttribute)defaultAttributeForLeftController;
- (SNSlideAttribute)defaultAttributeForRightController;

- (void)setAttribute:(SNSlideAttribute)attribute forController:(SNViewController *)controller;
- (void)removeAttributeForController:(SNViewController *)controller;
- (SNSlideAttribute)attributeForController:(SNViewController *)controller;

@end
