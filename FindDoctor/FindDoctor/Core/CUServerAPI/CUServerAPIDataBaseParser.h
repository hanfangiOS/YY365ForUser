//
//  CUServerAPIDataBaseParser.h
//  CollegeUnion
//
//  Created by li na on 15/2/26.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNServerAPIDataParser.h"
#import "SNBaseListModel.h"

@interface CUServerAPIDataBaseParser : SNServerAPIDataParser

- (NSDictionary *)parseBaseDataWithDict:(NSDictionary *)dict;
- (SNPageInfo *)parsePageInfoWithDict:(NSDictionary *)dict;

@end
