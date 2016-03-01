//
//  YueZhenRecordListModel.h
//  
//
//  Created by Guo on 15/10/6.
//
//

#import "SNBaseListModel.h"
#import "CUService.h"
#import "Doctor.h"

@interface MyDoctorListModel : SNBaseListModel

@property (nonatomic, strong) MyDoctorFilter *filter;


- (instancetype)initWithSortType:(MyDoctorSortType)type;

@end
