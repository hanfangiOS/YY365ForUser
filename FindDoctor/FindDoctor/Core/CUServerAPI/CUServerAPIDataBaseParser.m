//
//  CUServerAPIDataBaseParser.m
//  CollegeUnion
//
//  Created by li na on 15/2/26.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUServerAPIDataBaseParser.h"
#import "CUServerAPIConstant.h"

@implementation CUServerAPIDataBaseParser

- (NSDictionary *)parseBaseDataWithDict:(NSDictionary *)dict
{
    NSDictionary * data = nil;
    
    if ( dict == nil
        || ![dict isKindOfClass:[NSDictionary class]]
        || ErrorCode_None != [[dict objectForKeySafely:@"error_code"] intValue] )
    {
        self.hasError = YES;
        
        if ([dict isKindOfClass:[NSDictionary class]]) {
            id tempData = [dict objectForKeySafely:@"data"];
            // 进一步处理失败
            NSString * errorCode = [dict objectForKeySafely:@"error_code"];
            if (errorCode && [errorCode intValue] > 0)
            {
                self.errorCode = [[dict objectForKeySafely:@"error_code"] intValue];
                self.errorMessage = [dict objectForKeySafely:@"error_message"];
                
                // TODO
                data = tempData;
            }
        }
    }
    else
    {
        id tempData = [dict objectForKeySafely:@"data"];
        
        if ( [tempData isKindOfClass:[NSDictionary class]] )
        {
            data = tempData;
        }
        else
        {
            // TODO:统一data格式？
            //self.hasError = YES;
            data = dict;
        }
    }
    return data;
}

- (SNPageInfo *)parsePageInfoWithDict:(NSDictionary *)dict
{
    SNPageInfo * page = [[SNPageInfo alloc] init];
    page.totalPage = [[dict valueForKeyPathSafely:@"pageInfo.totalPage"] integerValue];
    page.pageSize = [[dict valueForKeyPathSafely:@"pageInfo.pageSize"] integerValue];
    page.currentPage = [[dict valueForKeyPathSafely:@"pageInfo.currentPage"] integerValue];
    return page;
}

@end
