//
//  UIView+Extension.h
//  HuiYangChe
//
//  Created by yutao on 14-9-20.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property(nonatomic, assign) CGFloat frameX;
@property(nonatomic, assign) CGFloat frameY;
@property(nonatomic, assign) CGFloat frameWidth;
@property(nonatomic, assign) CGFloat frameHeight;
@property(nonatomic, assign) CGFloat boundsX;
@property(nonatomic, assign) CGFloat boundsY;
@property(nonatomic, assign) CGFloat boundsWidth;
@property(nonatomic, assign) CGFloat boundsHeight;
@property(nonatomic, assign) CGFloat centerX;
@property(nonatomic, assign) CGFloat centerY;

/**
 * Returns the UIImage representation of this view.
 */
- (UIImage *)toImage;

/**
 * Returns a UIImageView representation of this view.  The image view's initial frame
 * is set to the frame as the view.
 */
- (UIImageView *)toImageView;

/**
 * Rounds corners of view with a radius of 8.0f.  This is a standard value throughout our app.
 */
- (void)roundCorners;
@end
