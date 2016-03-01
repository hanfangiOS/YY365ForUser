//
//  SearchHistoryHelper.m
//  
//
//  Created by zhouzhenhua on 15/6/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "SearchHistoryHelper.h"
#import "AppCore.h"

#define kSearchHistoryArray          @"SearchHistoryArray"

@implementation SearchHistoryHelper

+ (NSArray *)searchHistoryArray
{
    return [[AppCore sharedInstance].fileAccessManager loadObjectForKey:kSearchHistoryArray error:nil];
}

+ (void)saveSearchHistoryArray:(NSArray *)array
{
    [[AppCore sharedInstance].fileAccessManager saveObject:array forKey:kSearchHistoryArray completionHandle:^(BOOL success,NSError* error) {
        
    }];
}

+ (void)saveSearchHistory:(NSString *)history
{
    if (history == nil || ![history isKindOfClass:NSClassFromString(@"NSString")]) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self searchHistoryArray]];
    
    NSInteger index = [array indexOfObject:history];
    if (index != NSNotFound) {
        [array removeObjectAtIndex:index];
    }
    
    [array insertObject:history atIndex:0];
    
    [self saveSearchHistoryArray:array];
}

@end