//
//  YueZhenRecordListModel.h
//  
//
//  Created by Guo on 15/10/6.
//
//

#import "SNBaseListModel.h"
#import "CUService.h"

@interface MyDiagnosisRecordsListModel : SNBaseListModel

@property (nonatomic, strong) MyDiagnosisRecordsFilter *filter;


- (instancetype)initWithSortType:(MyDiagnosisRecordsSortType)type;

@end
