//
//  DoctorListModel.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/13.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "SearchResultListModel.h"
#import "CUSearchManager.h"

@implementation SearchResultListModel

- (instancetype)initWithSortType:(SearchSortType)type
{
    SearchFilter *filter = [[SearchFilter alloc] init];
    filter.sortType = type;
    
    return [self initWithFilter:filter];
}

- (instancetype)initWithFilter:(SearchFilter *)filter
{
    self = [super init];
    
    if (self) {
        _filter = filter;
    }
    
    return self;
}

- (void)gotoFirstPage:(SNServerAPIResultBlock)resultBlock
{
    [[CUSearchManager sharedInstance] getSearchResultListWithFilter:self.filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
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
        else {
            NSLog(@"连接服务器失败，请检查网络");
        }
        resultBlock(request,result);
    } pageName:@"SearchResultViewController"];
}

- (void)gotoNextPage:(SNServerAPIResultBlock)resultBlock
{
    [[CUSearchManager sharedInstance] getSearchResultListWithFilter:self.filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
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
    } pageName:@"SearchResultViewController"];
}

@end
