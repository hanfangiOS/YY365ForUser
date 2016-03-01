//
//  SNSlideController+SNGeometry.h
//  SNSlideController
//
//  Created by Nova on 13-4-2.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNSlideController.h"

@interface SNSlideController (SNGeometry)

CGFloat CGRectGetLeftMinX(CGRect rect);      // CGRectGetMinX(rect)+kLeftReservedWidth
CGFloat CGRectGetRightMaxX(CGRect rect);     // CGRectGetMaxX(rect)-kRightReservedWidth

// Find the topest controller whose view.frame contains point, may be nil.
- (SNViewController *)hitTest:(CGPoint)point;

- (CGFloat)scaleForController:(SNViewController *)controller withFrame:(CGRect)frame;
- (CGFloat)alphaForController:(SNViewController *)controller withFrame:(CGRect)frame;

@end
