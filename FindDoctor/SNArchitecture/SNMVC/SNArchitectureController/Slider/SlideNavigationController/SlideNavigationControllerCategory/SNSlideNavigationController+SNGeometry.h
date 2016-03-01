//
//  SNSlideNavigationController+SNGeometry.h
//  YiRen
//
//  Created by Nova on 13-4-10.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNSlideNavigationController.h"

@interface SNSlideNavigationController (SNGeometry)

- (CGFloat)scaleForController:(SNViewController *)controller withFrame:(CGRect)frame;
- (CGFloat)alphaForController:(SNViewController *)controller withFrame:(CGRect)frame;

@end
