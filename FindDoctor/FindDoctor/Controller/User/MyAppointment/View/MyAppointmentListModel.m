//
//  MyAppointmentListModel.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/18.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "MyAppointmentListModel.h"
#import "CUOrderManager.h"

@implementation MyAppointmentListModel

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
    if (self.filter.orderStatus == ORDERSTATUS_UNPAID) {
    [[CUOrderManager sharedInstance]getOrderNotPayListWithFilter:self.filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        
        if (!result.hasError)
        {
            SNBaseListModel * listModel = result.parsedModelObject;
            NSArray *orderArray = listModel.items;
            
            [self.items removeAllObjects];
            [self.items addObjectsFromArray:orderArray];
            
            SNPageInfo * info = listModel.pageInfo;
            self.pageInfo.pageSize = info.pageSize;
            self.pageInfo.totalPage = info.totalPage;
            self.pageInfo.currentPage = startPageNum;
        }
        resultBlock(request,result);
        
    } pageName:@"MyAppointmentController"];
}
    
    if (self.filter.orderStatus == ORDERSTATUS_PAID) {
        [[CUOrderManager sharedInstance]getOrderHasPayNotMeetListWithFilter:self.filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
            if (!result.hasError)
            {
                SNBaseListModel * listModel = result.parsedModelObject;
                NSArray *orderArray = listModel.items;
                
                [self.items removeAllObjects];
                [self.items addObjectsFromArray:orderArray];
                
                SNPageInfo * info = listModel.pageInfo;
                self.pageInfo.pageSize = info.pageSize;
                self.pageInfo.totalPage = info.totalPage;
                self.pageInfo.currentPage = startPageNum;
            }
            resultBlock(request,result);
        } pageName:@"MyAppointmentController"];
   }
}

- (void)gotoNextPage:(SNServerAPIResultBlock)resultBlock
{
    if (self.filter.orderStatus == ORDERSTATUS_UNPAID) {
        [[CUOrderManager sharedInstance]getOrderNotPayListWithFilter:self.filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
            
            if (!result.hasError)
            {

                    SNBaseListModel * listModel = result.parsedModelObject;
                    [self.items addObjectsFromArray:listModel.items];
                    
                    SNPageInfo * info = listModel.pageInfo;
                    self.pageInfo.pageSize = info.pageSize;
                    self.pageInfo.totalPage = info.totalPage;
                    self.pageInfo.currentPage++;
            }
            resultBlock(request,result);
            
        } pageName:@"MyAppointmentController"];
    }

    if (self.filter.orderStatus == ORDERSTATUS_PAID) {
        [[CUOrderManager sharedInstance]getOrderHasPayNotMeetListWithFilter:self.filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
            
            if (!result.hasError)
            {
                    SNBaseListModel * listModel = result.parsedModelObject;
                    [self.items addObjectsFromArray:listModel.items];
                    
                    SNPageInfo * info = listModel.pageInfo;
                    self.pageInfo.pageSize = info.pageSize;
                    self.pageInfo.totalPage = info.totalPage;
                    self.pageInfo.currentPage++;
            }
            resultBlock(request,result);
            
        } pageName:@"MyAppointmentController"];
    }
}

@end
