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
    [[CUOrderManager sharedInstance] getOrderHasPayHasMeetListWithFilter:self.filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError)
        {
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
        }
    } pageName:@"MyTreatmentController"];
}

- (void)gotoNextPage:(SNServerAPIResultBlock)resultBlock
{

    [[CUOrderManager sharedInstance] getOrderHasPayHasMeetListWithFilter:self.filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError)
        {
            if (!result.hasError)
            {
                SNBaseListModel * list = result.parsedModelObject;
                [self.items addObjectsFromArray:list.items];
                
                SNPageInfo * info = list.pageInfo;
                self.pageInfo.pageSize = info.pageSize;
                self.pageInfo.totalPage = info.totalPage;
                self.pageInfo.currentPage++;
            }
        }
    } pageName:@"MyTreatmentController"];

}

@end
