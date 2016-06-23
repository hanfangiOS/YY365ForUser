//
//  YueZhenRecordListModel.m
//  
//
//  Created by Guo on 15/10/6.
//
//

#import "MyClinicListModel.h"
#import "CUClinicManager.h"


@implementation MyClinicListModel

- (instancetype)initWithSortType:(MyClinicSortType)type
{
    MyClinicFilter *filter = [[MyClinicFilter alloc] init];
    filter.sortType = type;
    
    return [self initWithFilter:filter];
}

- (instancetype)initWithFilter:(MyClinicFilter *)filter
{
    self = [super init];
    
    if (self) {
        _filter = filter;
    }
    
    return self;
}



- (void)gotoFirstPage:(SNServerAPIResultBlock)resultBlock
{
    [[CUClinicManager sharedInstance] getMyClinicWithResultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
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
    } pageSize:pageSize pageNum:startPageNum pageName:@"getCurrentTreatmentList"];
}

- (void)gotoNextPage:(SNServerAPIResultBlock)resultBlock
{
    [[CUClinicManager sharedInstance] getMyClinicWithResultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
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
