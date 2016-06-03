//
//  NSMutableArray+NullReplacement.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/5/28.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "NSMutableArray+NullReplacement.h"

@implementation NSMutableArray (NullReplacement)


- (instancetype)arrayByReplacingNullWithArray:(NSArray *)replacingArray{
    
    
    for (int i = 0; i < [self count]; i++) {
        
        id item = [self objectAtIndexSafely:i];
        
        if([item isKindOfClass:[NSNumber class]]){
            if (!item || item == [NSNull null]) {
                NSNumber * replacingItem = [replacingArray objectAtIndexSafely:i];
                item = replacingItem.mutableCopy;
                NSLog(@"%@:Null-->%@",item,replacingItem);
            }
        }
        if([item isKindOfClass:[NSString class]]){
            if ([item isEmpty]) {
                NSString * replacingItem = [replacingArray objectAtIndexSafely:i];
                item = replacingItem.mutableCopy;
                NSLog(@"%@:空-->%@",item,replacingItem);
            }
        }
    }
    return self;
}

@end
