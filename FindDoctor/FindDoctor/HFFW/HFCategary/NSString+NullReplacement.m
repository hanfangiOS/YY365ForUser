//
//  NSString+NullReplacement.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/5/17.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "NSString+NullReplacement.h"

@implementation NSString (NullReplacement)

- (NSString *)stringByReplacingNullWithBlank{
    NSString * replaceBlank = @"";
    const id nul = [NSNull null];
    if (self == nul) {
        return replaceBlank;
    }
    return self;
}

@end
