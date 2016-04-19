//
//  MyTreatmentListModel.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/19.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "MyTreatmentListModel.h"
#import "CUOrderManager.h"

@implementation MyTreatmentListModel

- (instancetype)initWithFilter:(OrderFilter *)filter{
    self = [super init];
    if (self) {
        self.filter = filter;
        return self;
    }
    return nil;
}

- (void)gotoFirstPage:(SNServerAPIResultBlock)resultBlock
{
    [[CUOrderManager sharedInstance] getUncommentOrderListWithPageNum:0 pageSize:kPageSize user:self.filter.user searchedWithOrderStatus:self.filter.orderStatus resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
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
    } pageName:@"MyAppointmentController"];
}

- (void)gotoNextPage:(SNServerAPIResultBlock)resultBlock
{
    [[CUOrderManager sharedInstance] getUncommentOrderListWithPageNum:self.filter.pageNum pageSize:kPageSize user:self.filter.user searchedWithOrderStatus:self.filter.orderStatus resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError)
        {
            SNBaseListModel * list = result.parsedModelObject;
            [self.items addObjectsFromArray:list.items];
            
            SNPageInfo * info = list.pageInfo;
            self.pageInfo.pageSize = info.pageSize;
            self.pageInfo.totalPage = info.totalPage;
            self.pageInfo.currentPage++;
        }
        resultBlock(request,result);
    } pageName:@"MyAppointmentController"];
    
}

@end
