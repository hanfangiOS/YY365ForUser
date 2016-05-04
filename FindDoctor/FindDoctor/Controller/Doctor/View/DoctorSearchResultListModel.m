//
//  DoctorSearchResultListModel.m
//  FindDoctor
//
//  Created by zhuhaoran on 16/3/1.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "DoctorSearchResultListModel.h"
#import "CUSearchManager.h"

@implementation DoctorSearchResultListModel

- (instancetype)init
{
    SearchFilter * filter = [[SearchFilter alloc] init];
    
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
//    [[CUSearchManager sharedInstance] getDoctorSearchResultListWithPageNum:startPageNum pageSize:pageSize filter:self.filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
//        if (!result.hasError)
//        {
//            SNBaseListModel * list = result.parsedModelObject;
//            NSArray *orderArray = list.items;
//            
//            [self.items removeAllObjects];
//            [self.items addObjectsFromArray:orderArray];
//            
//            SNPageInfo * info = list.pageInfo;
//            self.pageInfo.pageSize = info.pageSize;
//            self.pageInfo.totalPage = info.totalPage;
//            self.pageInfo.currentPage = startPageNum;
//        }
//        else {
//            NSLog(@"连接服务器失败，请检查网络");
//        }
//        resultBlock(request,result);
//    } pageName:@"DoctorSearchResultList"];
}

- (void)gotoNextPage:(SNServerAPIResultBlock)resultBlock
{
//    [[CUSearchManager sharedInstance] getDoctorSearchResultListWithPageNum:self.pageInfo.currentPage + 1 pageSize:pageSize filter:self.filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
//        if (!result.hasError)
//        {
//            SNBaseListModel * list = result.parsedModelObject;
//            [self.items addObjectsFromArray:list.items];
//            
//            SNPageInfo * info = list.pageInfo;
//            self.pageInfo.pageSize = info.pageSize;
//            self.pageInfo.totalPage = info.totalPage;
//            self.pageInfo.currentPage++;
//        }
//        resultBlock(request,result);
//    } pageName:@"DoctorSearchResultList"];
}

@end
