//
//  Search.h
//  FindDoctor
//
//  Created by zhuhaoran on 16/3/2.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFFilter.h"
#import "OptionList.h"

typedef NS_ENUM(NSInteger, SearchSortType) {
    SearchSortTypeNone  = 0
};

//@interface Search : NSObject
//
//@end

@interface SearchFilter : HFFilter

@property SearchSortType sortType;
@property (nonatomic, strong) NSString * keyword;//搜索内容
@property NSInteger     subjectID;
@property NSString      *date;
@property RegionOption  *Region;
@property NSInteger     SymptomID;

@end