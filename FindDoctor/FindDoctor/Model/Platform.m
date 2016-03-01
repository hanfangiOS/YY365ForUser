//
//  Platform.m
//  EShiJia
//
//  Created by zhouzhenhua on 15/6/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "Platform.h"

#define kOldVersion            @"kOldVersion"

@implementation Platform

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_oldVersion forKey:kOldVersion];;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _oldVersion = [aDecoder decodeIntegerForKey:kOldVersion];
    }
    return self;
}

- (id)init
{
    if (self = [super init])
    {
        _oldVersion = 0;
        
        [self setDefaultValue];
    }
    return self;
}

- (void)setDefaultValue
{}

@end
