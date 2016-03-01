//
//  SNSlideNavigationController+SNGeometry.m
//  YiRen
//
//  Created by Nova on 13-4-10.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNSlideNavigationController+SNGeometry.h"

@implementation SNSlideNavigationController (SNGeometry)

- (CGFloat)scaleForController:(SNViewController *)controller withFrame:(CGRect)frame
{
    return 1;
    
    CGFloat factor = frame.origin.x/CGRectGetWidth(self.view.bounds);
    CGFloat scale = kTransformStartValue+factor*(kTransformEndValue-kTransformStartValue);
    if (scale > 1.0) {
        scale = 1.0;
    }
    
    return scale;
}

- (CGFloat)alphaForController:(SNViewController *)controller withFrame:(CGRect)frame
{
    return 0;
    
    CGFloat factor = frame.origin.x/CGRectGetWidth(self.view.bounds);
    CGFloat alpha = kAlphaStartValue-factor*(kAlphaStartValue-kAlphaEndValue);
    if (alpha < 0.0) {
        alpha = 0.0;
    }
    else if (alpha > 1.0) {
        alpha = 1.0;
    }
    
    return alpha;
}

@end
