//
//  ParserTools.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/3/23.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "ParserTools.h"

@implementation ParserTools

+ (void)enumerateObjects:(id)item UsingBlockSafety:(void (^)(id  _Nonnull obj, NSUInteger idx, BOOL *stop))block{
    if ([item isKindOfClass:[NSArray class]]) {
        NSArray *arr = item;
        [arr enumerateObjectsUsingBlock:block];
    }
}
@end
