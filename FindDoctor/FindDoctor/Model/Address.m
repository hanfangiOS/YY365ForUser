//
//  Address.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/15.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "Address.h"

@implementation Address

- (BOOL)isEqual:(Address *)object
{
    if ([object isKindOfClass:[Address class]] && [object.addressId isEqualToString:self.addressId]) {
        return YES;
    }
    
    return NO;
}

- (NSUInteger)hash
{
    return self.addressId.hash;
}

@end
