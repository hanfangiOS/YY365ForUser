//
//  MyMemberListModel.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "MyMemberListModel.h"
#import "CUUserManager.h"

@implementation MyMemberListModel

- (instancetype)initWithFilter:(UserFilter *)filter{
    self = [super init];
    if (self) {
        self.filter = filter;
        return self;
    }
    return nil;
}

- (void)gotoFirstPage:(SNServerAPIResultBlock)resultBlock
{
    [[CUUserManager sharedInstance] getUserMemberListWithFilter:self.filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        
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
    } pageName:@""];
}

- (void)gotoNextPage:(SNServerAPIResultBlock)resultBlock
{
    [[CUUserManager sharedInstance] getUserInfo:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
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
    }];
}




@end
