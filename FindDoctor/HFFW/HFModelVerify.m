//
//  HFModelVerify.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/5/26.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "HFModelVerify.h"

@implementation HFModelVerify

+ (BOOL)VerifyWithObjects:(NSArray *)arr{
    for(id item in arr){
        if([item isKindOfClass:[UITextField class]]){
            UITextField *textField = item;
            if ([textField.text isEmpty]) {
                return NO;
            }
        }
        if([item isKindOfClass:[UILabel class]]){
            UILabel *label = item;
            if ([label.text isEmpty]) {
                return NO;
            }
        }
        if([item isKindOfClass:[NSString class]]){
            NSString *str = item;
            if ([str isEmpty]) {
                return NO;
            }
        }
    }
    return YES;
}

@end
