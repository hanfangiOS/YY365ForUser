//
//  NSData+SNExtension.m
//  HuiYangChe
//
//  Created by li na on 14-9-14.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import "NSData+SNExtension.h"

@implementation NSData (SNExtension)

- (NSArray*)array
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:self];
}

- (NSDictionary*)dictionary
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:self];
}

- (UIImage*)image
{
    return [UIImage imageWithData:self];
}

- (NSData*)data
{
    return self;
}

- (NSString*)UTF8String
{
     NSString *string = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    return string;
}

@end
