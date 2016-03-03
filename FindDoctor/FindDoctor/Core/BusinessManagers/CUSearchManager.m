//
//  CUSearchManager.m
//  FindDoctor
//
//  Created by zhuhaoran on 16/3/2.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "CUSearchManager.h"
#import "CUUserManager.h"
#import "JSONKit.h"
#import "AppCore.h"
#import "CUServerAPIConstant.h"
#import "TipHandler+HUD.h"
#import "SNBaseListModel.h"
#import "Search.h"

@implementation CUSearchManager

SINGLETON_IMPLENTATION(CUSearchManager);

- (void)getDoctorSearchResultListWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize filter:(SearchFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary * param = [NSMutableDictionary new];
    [param setObjectSafely:@"ios" forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"Search" forKey:@"require"];
    [param setObjectSafely:@(11004) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary new];
    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:filter.keyword forKey:@"search"];
    [dataParam setObjectSafely:@([kCurrentLng doubleValue]) forKey:@"longtitude"];
    [dataParam setObjectSafely:@([kCurrentLat doubleValue]) forKey:@"latitude"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                
                SNBaseListModel *listModel = [[SNBaseListModel alloc] init];
                NSMutableArray * list1 = [result.responseObject valueForKeySafely:@"data"];
                Search * search = [[Search alloc] init];
                search.searchResultList = [[NSMutableArray alloc] initWithCapacity:0];
                [list1 enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * stop) {
                    SearchResultListInfo * searchResultListInfo = [[SearchResultListInfo alloc] init];
                    searchResultListInfo.brief = [obj valueForKeySafely:@"brief"];
                    searchResultListInfo.dataID = [[obj valueForKeySafely:@"dataID"] integerValue];
                    searchResultListInfo.dataType = [[obj valueForKeySafely:@"dataType"] integerValue];
                    searchResultListInfo.icon = [obj valueForKeySafely:@"icon"];
                    searchResultListInfo.name = [obj valueForKeySafely:@"name"];
                    searchResultListInfo.numDiag = [[obj valueForKeySafely:@"numDiag"] integerValue];
                    searchResultListInfo.orderState = [[obj valueForKeySafely:@"orderState"] integerValue];
                    searchResultListInfo.skill = [obj valueForKeySafely:@"skill"];
                    searchResultListInfo.time = [[obj valueForKeySafely:@"time"] integerValue];
                    searchResultListInfo.title = [obj valueForKeySafely:@"title"];
                }];
            }
            else {
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject valueForKey:@"data"]];
            }
        }
        else {
            NSLog(@"====哦哟，出错了====");
            [TipHandler showTipOnlyTextWithNsstring:@"====哦哟，出错了===="];
        }
        
        resultBlock(request, result);
        
    }forKey:@"get_subject_doctor_list" forPageNameGroup:pageName];
    
}


@end
