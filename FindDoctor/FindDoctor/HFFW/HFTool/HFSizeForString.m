//
//  HFSizeForString.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/5/28.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "HFSizeForString.h"

@implementation HFSizeForString

- (float)heightForString:(NSString *)string font:(UIFont *)font limitWidth:(float)limitWidth{
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(limitWidth, CGFLOAT_MAX)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    
    return rect.size.height;
    
}

- (float)heightForString:(NSString *)string attributes:(NSDictionary *)attributes limitWidth:(float)limitWidth{
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(limitWidth,CGFLOAT_MAX)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributes
                                       context:nil];
    return rect.size.height;
}

- (float)widthForString:(NSString *)string font:(UIFont *)font limitHeight:(float)limitHeight{
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, limitHeight)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    return rect.size.width;
    
}

- (float)widthForString:(NSString *)string attributes:(NSDictionary *)attributes limitHeight:(float)limitHeight{
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,limitHeight)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributes
                                       context:nil];
    return rect.size.height;
    
}

- (CGSize)sizeForString:(NSString *)string font:(UIFont *)font limitSize:(CGSize)limitSize{
    
    CGFloat width = limitSize.width;
    CGFloat height = limitSize.height;
    if (!width) {
        width = CGFLOAT_MAX;
    }
    if (!height) {
        height = CGFLOAT_MAX;
    }
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, height)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    
    return rect.size;
}

- (CGSize)sizeForString:(NSString *)string attributes:(NSDictionary *)attributes limitSize:(CGSize)limitSize{
    
    CGFloat width = limitSize.width;
    CGFloat height = limitSize.height;
    if (!width) {
        width = CGFLOAT_MAX;
    }
    if (!height) {
        height = CGFLOAT_MAX;
    }
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, height)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributes
                                       context:nil];

    return rect.size;
}

@end
