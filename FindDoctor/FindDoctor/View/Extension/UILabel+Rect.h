//
//  UILabel+Rect.h
//  CommonUI
//
//  Created by zhouzhenhua on 15-4-4.
//  Copyright (c) 2015年. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Rect)

/**
 * 根据字号自适应高度，center不变
 * @param
 *     fontSize 字号大小，默认HelveticaNeue
 * @return
 *     none
 */
- (void)rectToFit:(CGFloat)fontSize;

/**
 * 根据字号自适应高度，center不变
 * @param
 *     rect     初始rect
 *     fontSize 字号大小，默认HelveticaNeue
 * @return
 *     自适应后的rect
 */
+ (CGRect)textRectWithRect:(CGRect)rect withFontSize:(CGFloat)fontSize;

/**
 * 根据字号自适应高度
 * @param
 *     fontSize 字号大小，默认HelveticaNeue
 * @return
 *     自适应后的高度
 */
+ (CGFloat)textHeightWithFontSize:(CGFloat)fontSize;

@end
