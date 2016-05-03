//
//  DoctorListModel.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/13.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "SNBaseListModel.h"
#import "SubObject.h"

@interface DoctorListModel : SNBaseListModel

@property (nonatomic, strong) SubObjectFilter *filter;

- (instancetype)initWithSortType:(SubObjectSortType)type;

- (instancetype)initWithFilter:(SubObjectFilter *)filter;

@end
