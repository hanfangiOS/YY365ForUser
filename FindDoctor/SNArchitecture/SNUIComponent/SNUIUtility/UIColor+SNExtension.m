//
//  UIColor+Extension.m
//  CollegeUnion
//
//  Created by li na on 15/3/1.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "UIColor+SNExtension.h"

@implementation UIColor (SNExtension)

+ (UIColor *)colorWithHex:(int)hex {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    NSScanner *scanner = [[NSScanner alloc] initWithString:hexString];
    unsigned int hex = 0;
    [scanner scanHexInt:&hex];
    
    return [UIColor colorWithHex:hex];
}


@end
