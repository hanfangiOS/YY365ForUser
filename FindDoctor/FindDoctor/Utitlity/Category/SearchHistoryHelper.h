//
//  SearchHistoryHelper.h
//  
//
//  Created by zhouzhenhua on 15/6/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchHistoryHelper : NSObject

+ (NSArray *)searchHistoryArray;
+ (void)saveSearchHistory:(NSString *)history;

@end