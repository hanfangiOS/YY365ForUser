//
//  YueZhenRecordListModel.m
//  
//
//  Created by Guo on 15/10/6.
//
//

#import "MyDiagnosisRecordsListModel.h"
#import "CUOrderManager.h"
#import "CUUserManager.h"


@implementation MyDiagnosisRecordsListModel

- (instancetype)initWithSortType:(MyDiagnosisRecordsSortType)type
{
    MyDiagnosisRecordsFilter *filter = [[MyDiagnosisRecordsFilter alloc] init];
    filter.accID = [CUUserManager sharedInstance].user.userId;
//    filter.sortType = type;
    
    return [self initWithFilter:filter];
}

- (instancetype)initWithFilter:(MyDiagnosisRecordsFilter *)filter
{
    self = [super init];
    
    if (self) {
        _filter = filter;
    }
    
    return self;
}



- (void)gotoFirstPage:(SNServerAPIResultBlock)resultBlock
{
    [[CUOrderManager sharedInstance] getMyDiagnosisRecordsWithUser:self.filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError)
        {
            SNBaseListModel * list = result.parsedModelObject;
            NSArray *orderArray = list.items;
            
            [self.items removeAllObjects];
            [self.items addObjectsFromArray:orderArray];
            
            SNPageInfo * info = list.pageInfo;
            self.pageInfo.pageSize = info.pageSize;
            self.pageInfo.totalPage = info.totalPage;
            self.pageInfo.currentPage = startPageNum;
        }
        resultBlock(request,result);
    } pageSize:pageSize pageNum:startPageNum pageName:@"getCurrentTreatmentList"];
}

- (void)gotoNextPage:(SNServerAPIResultBlock)resultBlock
{
    [[CUOrderManager sharedInstance] getMyDiagnosisRecordsWithUser:self.filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError)
        {
            SNBaseListModel * list = result.parsedModelObject;
            [self.items addObjectsFromArray:list.items];
            
            SNPageInfo * info = list.pageInfo;
            if ([list.items count] > 0) {
                self.pageInfo.totalCount = info.totalCount;
                self.pageInfo.pageSize = info.pageSize;
                self.pageInfo.totalPage = info.totalPage;
                self.pageInfo.currentPage++;
            }
        }
        resultBlock(request,result);
    } pageSize:pageSize pageNum:(self.pageInfo.currentPage + 1) pageName:@"getCurrentTreatmentList"];
}



@end
