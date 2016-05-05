//
//  DoctorListModel.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/13.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "SNBaseListModel.h"
#import "Search.h"

@interface SearchResultListModel : SNBaseListModel

@property (nonatomic, strong) SearchFilter *filter;

- (instancetype)initWithSortType:(SearchSortType)type;

@end
