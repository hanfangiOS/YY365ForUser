//
//  YueZhenRecordListModel.h
//  
//
//  Created by Guo on 15/10/6.
//
//

#import "SNBaseListModel.h"
#import "CUService.h"
#import "Clinic.h"

@interface MyClinicListModel : SNBaseListModel

@property (nonatomic, strong) MyClinicFilter *filter;


- (instancetype)initWithSortType:(MyClinicSortType)type;

@end
