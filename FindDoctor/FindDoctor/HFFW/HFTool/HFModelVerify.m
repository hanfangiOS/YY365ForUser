//
//  HFModelVerify.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/5/26.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "HFModelVerify.h"

@implementation HFModelVerify

+ (BOOL)VerifyWithArray:(NSArray *)array{
    for(id item in array){

        if([item isKindOfClass:[NSNumber class]]){
            if (!item || item == [NSNull null]) {
                NSLog(@"%@:Null",item);
                return NO;
            }
        }
        if([item isKindOfClass:[NSString class]]){
            if ([item isEmpty]) {
                NSLog(@"%@:空",item);
                return NO;
            }
        }
        
    }
    return YES;
}

@end
