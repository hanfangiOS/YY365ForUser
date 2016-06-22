//
//  YueZhenRecordListModel.m
//  
//
//  Created by Guo on 15/10/6.
//
//

#import "MyDoctorListModel.h"
#import "CUDoctorManager.h"


@implementation MyDoctorListModel

- (instancetype)initWithSortType:(MyDoctorSortType)type
{
    MyDoctorFilter *filter = [[MyDoctorFilter alloc] init];
    filter.sortType = type;
    
    return [self initWithFilter:filter];
}

- (instancetype)initWithFilter:(MyDoctorFilter *)filter
{
    self = [super init];
    
    if (self) {
        _filter = filter;
    }
    
    return self;
}




- (void)gotoFirstPage:(SNServerAPIResultBlock)resultBlock
{
    [[CUDoctorManager sharedInstance] getMyDoctorWithResultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError)
        {
            SNBaseListModel * list = result.parsedModelObject;
            NSArray *orderArray = list.items;
            
            [self.items removeAllObjects];
            [self.items addObjectsFromArray:orderArray];
            
            SNPageInfo * info = list.pageInfo;
            self.pageInfo.totalCount = info.totalCount;
            self.pageInfo.pageSize = info.pageSize;
            self.pageInfo.totalPage = info.totalPage;
            self.pageInfo.currentPage = startPageNum;
        }
        resultBlock(request,result);
    } pageSize:pageSize pageID:startPageNum pageName:@"getCurrentTreatmentList"];
}

- (void)gotoNextPage:(SNServerAPIResultBlock)resultBlock
{
    [[CUDoctorManager sharedInstance] getMyDoctorWithResultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError)
        {
            SNBaseListModel * list = result.parsedModelObject;
            [self.items addObjectsFromArray:list.items];
            
            SNPageInfo * info = list.pageInfo;
            self.pageInfo.totalCount = info.totalCount;
            self.pageInfo.pageSize = info.pageSize;
            self.pageInfo.totalPage = info.totalPage;
            self.pageInfo.currentPage++;
        }
        resultBlock(request,result);
    }pageSize:pageSize pageID:(self.pageInfo.currentPage + 1) pageName:@"getCurrentTreatmentList"];
}



@end
