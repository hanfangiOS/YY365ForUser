//
//  NewsListModel.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/13.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "NewsListModel.h"
#import "CUOrderManager.h"

@implementation NewsListModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        return self;
    }
    return nil;
    
}

- (void)gotoFirstPage:(SNServerAPIResultBlock)resultBlock
{
    [[CUOrderManager sharedInstance] getHomeTipListWithResultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError) {
            SNBaseListModel * list = [[SNBaseListModel alloc] init];
            list.items = result.parsedModelObject;
            NSArray *orderArray = list.items;
            
            [self.items removeAllObjects];
            [self.items addObjectsFromArray:orderArray];
            
            SNPageInfo * info = list.pageInfo;
            self.pageInfo.pageSize = info.pageSize;
            self.pageInfo.totalPage = info.totalPage;
            self.pageInfo.currentPage = startPageNum;
        }
        resultBlock(request,result);
    }
        pageName:@"NewsListController"];
}

- (void)gotoNextPage:(SNServerAPIResultBlock)resultBlock
{
    [[CUOrderManager sharedInstance] getHomeTipListWithResultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError) {
            SNBaseListModel * list = [[SNBaseListModel alloc] init];
            list.items = result.parsedModelObject;
            NSArray * orderArray = list.items;
            
            [self.items addObjectsFromArray:orderArray];
            
            SNPageInfo * info = list.pageInfo;
            self.pageInfo.pageSize = info.pageSize;
            self.pageInfo.totalPage = info.totalPage;
            self.pageInfo.currentPage = startPageNum;
        }
       resultBlock(request,result);
    }
    pageName:@"NewsListController"];
}


@end
