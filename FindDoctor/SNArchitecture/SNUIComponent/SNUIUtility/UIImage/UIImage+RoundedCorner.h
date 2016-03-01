// UIImage+RoundedCorner.h
// Created by Trevor Harmon on 9/20/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Extends the UIImage class to support making rounded corners
#import <UIKit/UIKit.h>

@interface UIImage (RoundedCorner)

/*
 *根据cornerSize、borderSize 创建图片圆角效果
 *cornerSize  圆角大小
 *borderSize  边框大小
 */
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;

@end
