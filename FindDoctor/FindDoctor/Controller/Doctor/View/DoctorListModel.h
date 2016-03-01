//
//  DoctorListModel.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/13.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "SNBaseListModel.h"
#import "Doctor.h"

@interface DoctorListModel : SNBaseListModel

@property (nonatomic, strong) DoctorFilter *filter;

- (instancetype)initWithSortType:(DoctorSortType)type;

- (instancetype)initWithFilter:(DoctorFilter *)filter;

@end
