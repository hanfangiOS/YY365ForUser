//
//  UILabel+Rect.m
//  CommonUI
//
//  Created by zhouzhenhua on 15-4-4.
//  Copyright (c) 2015年. All rights reserved.
//

#import "UILabel+Rect.h"

static NSDictionary *defaultFontDictionary = nil;

@implementation UILabel (Rect)

+ (NSDictionary *)fontDictionary
{
    if (defaultFontDictionary == nil) {
        NSString *bundleDir = [[NSBundle mainBundle] resourcePath];
        NSString *fontPath = [bundleDir stringByAppendingPathComponent:@"fontHeight.plist"];
        
        defaultFontDictionary = [NSDictionary dictionaryWithContentsOfFile:fontPath];
    }
    
    return defaultFontDictionary;
}

- (void)rectToFit:(CGFloat)fontSize
{
    self.frame = [UILabel textRectWithRect:self.frame withFontSize:fontSize];
}

+ (CGRect)textRectWithRect:(CGRect)rect withFontSize:(CGFloat)fontSize
{
    if ((int)rect.size.height == 0) {
        return rect;
    }
    
    CGFloat textHeight = [UILabel textHeightWithFontSize:fontSize];
    return CGRectInset(rect, 0, (CGRectGetHeight(rect) - textHeight) / 2.0);
}

+ (CGFloat)textHeightWithFontSize:(CGFloat)fontSize
{
    NSDictionary *fontDic = [self fontDictionary];
    
    CGFloat textHeight = [[fontDic valueForKey:[NSString stringWithFormat:@"%d", (int)fontSize]] floatValue];
    
    if ((int)textHeight == 0) {
        textHeight = fontSize;
    }
    
    return textHeight;
}

@end
