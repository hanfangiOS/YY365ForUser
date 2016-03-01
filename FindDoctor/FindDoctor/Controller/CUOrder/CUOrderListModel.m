//
//  CUJobListModel.m
//  CollegeUnion
//
//  Created by li na on 15/3/7.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUOrderListModel.h"
#import "CUOrderManager.h"
#import "CUUserManager.h"

@implementation CUOrderListModel

- (instancetype)initWithOrderStatus:(OrderStatus)status
{
    if (self = [super init])
    {
        self.status = status;
    }
    return self;
}

- (void)gotoFirstPage:(SNServerAPIResultBlock)resultBlock
{
     [[CUOrderManager sharedInstance] getOrderListWithPageNum:0 pageSize:20 user:[CUUserManager sharedInstance].user searchedWithOrderStatus:self.status resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError)
        {
            SNBaseListModel * list = result.parsedModelObject;
            NSArray *orderArray = list.items;
            
            [self.items removeAllObjects];
            [self.items addObjectsFromArray:orderArray];
            
            SNPageInfo * info = list.pageInfo;
            self.pageInfo.pageSize = info.pageSize;
            self.pageInfo.totalPage = info.totalPage;
            self.pageInfo.currentPage = 0;
        }
        resultBlock(request,result);
    } pageName:@"CUOrderListViewController"];
}

- (void)gotoNextPage:(SNServerAPIResultBlock)resultBlock
{
    [[CUOrderManager sharedInstance] getOrderListWithPageNum:self.pageInfo.currentPage+1 pageSize:20 user:[CUUserManager sharedInstance].user searchedWithOrderStatus:self.status resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
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
    } pageName:@"CUOrderListViewController"];
}

@end
