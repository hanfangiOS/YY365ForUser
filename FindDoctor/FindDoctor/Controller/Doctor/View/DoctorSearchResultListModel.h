//
//  DoctorSearchResultListModel.h
//  FindDoctor
//
//  Created by zhuhaoran on 16/3/1.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "SNBaseListModel.h"
#import "CUService.h"
#import "Search.h"

@interface DoctorSearchResultListModel : SNBaseListModel

@property (nonatomic, strong) SearchFilter * filter;

- (instancetype)initWithFilter:(SearchFilter *)filter;

@end
