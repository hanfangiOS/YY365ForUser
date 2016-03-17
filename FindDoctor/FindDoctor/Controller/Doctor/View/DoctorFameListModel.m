
//
//  DoctorFameListModel.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/3/15.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "DoctorFameListModel.h"

@implementation DoctorFameListModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        DoctorFameFilter *filter = [[DoctorFameFilter alloc] init];
        return [self initWithFilter:filter];
    }
    return nil;
    
}

- (instancetype)initWithFilter:(DoctorFameFilter *)filter
{
    self = [super init];
    
    if (self) {
        _filter = filter;
    }
    
    return self;
}



- (void)gotoFirstPage:(SNServerAPIResultBlock)resultBlock
{
    [[CUCommentManager sharedInstance] getDoctorFameList:self.filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
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
        
        
    } pageName:@"DoctorFameListController"];
}

- (void)gotoNextPage:(SNServerAPIResultBlock)resultBlock
{
    [[CUCommentManager sharedInstance] getDoctorFameList:self.filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
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
    } pageName:@"DoctorFameListController"];
}

@end
