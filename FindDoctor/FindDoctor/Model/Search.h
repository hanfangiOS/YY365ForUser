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


typedef NS_OPTIONS(NSInteger, SearchSortType) {
    SearchSortTypeNone                 = 1,//无
    SearchSortTypeWithDate             = 1 << 1,//带日期
    SearchSortTypeWithRegion           = 1 << 2,//带地区
    SearchSortTypeWithSubjectID        = 1 << 3,//病症第一级
    SearchSortTypeWithSymptomID        = 1 << 4 ,//病症第二级
};

typedef NS_OPTIONS(NSInteger, SearchListType) {
    SearchListTypeDoctor             = 0,//无
    SearchListTypeClinic             = 1 ,//带日期
};

@interface SearchFilter : HFFilter

@property SearchSortType sortType;
@property (nonatomic, strong) NSString * keyword;//搜索内容
@property NSString      *date;//日期
@property RegionOption  *region;//地区
@property SymptomOption     *subject;//病症第一级
@property SymptomSubOption     *symptom;//病症第二级
@property SearchListType      searchListType;

@end