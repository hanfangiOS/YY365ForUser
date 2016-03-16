//
//  MyCommentListModel.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/3/14.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "MyCommentListModel.h"
#import "CUCommentManager.h"

@implementation MyCommentListModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        MyCommentFilter *filter = [[MyCommentFilter alloc] init];
        return [self initWithFilter:filter];
    }
    return nil;
 
}

- (instancetype)initWithFilter:(MyCommentFilter *)filter
{
    self = [super init];
    
    if (self) {
        _filter = filter;
    }
    
    return self;
}



- (void)gotoFirstPage:(SNServerAPIResultBlock)resultBlock
{
    [[CUCommentManager sharedInstance] getMyCommentList:self.filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
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
        

    } pageName:@"MyCommentViewController"];
}

- (void)gotoNextPage:(SNServerAPIResultBlock)resultBlock
{
    [[CUCommentManager sharedInstance] getMyCommentList:self.filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
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
    } pageName:@"MyCommentViewController"];
}



@end
