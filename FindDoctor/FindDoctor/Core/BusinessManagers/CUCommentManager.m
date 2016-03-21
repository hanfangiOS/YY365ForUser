//
//  CUCommentManager.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/3/14.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "CUCommentManager.h"
#import "AppCore.h"
#import "TipHandler+HUD.h"
#import "NSData+SNExtension.h"
#import "JSONKit.h"
#import "CUUserManager.h"
#import "CUServerAPIConstant.h"
#import "SNBaseListModel.h"
#import "Comment.h"
#import "DoctorFameListModel.h"

@implementation CUCommentManager

SINGLETON_IMPLENTATION(CUCommentManager);

//11901点评按钮接口
- (void)getDiagnosisComment:(DiagnosisCommentFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"ClickRemark" forKey:@"require"];
    [param setObjectSafely:@(11901) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:@(filter.diagnosisID) forKey:@"diagnosisID"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                
                NSDictionary * data = [result.responseObject valueForKeySafely:@"data"];
                
                Comment * comment = [[Comment alloc] init];
                comment.clinicAddress = [data objectForKeySafely:@"clinicAddress"];
                comment.clinicName = [data objectForKeySafely:@"clinicName"];
                comment.diagnosisTime = [[data objectForKeySafely:@"diagnosisTime"] integerValue];
                comment.doctorIcon = [data objectForKeySafely:@"doctorIcon"];
                comment.doctorName = [data objectForKeySafely:@"doctorName"];
                comment.doctorTitle = [data objectForKeySafely:@"doctorTitle"];
                comment.clinicAddress = [data objectForKeySafely:@"clinicAddress"];
                NSMutableArray * flagList = [NSMutableArray new];
                flagList = [data objectForKeySafely:@"flagList"];
                [flagList enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    FlagListInfo * flagListInfo = [[FlagListInfo alloc] init];
                    flagListInfo.ID = [[obj valueForKeySafely:@"ID"] integerValue];
                    flagListInfo.icon = [obj valueForKeySafely:@"icon"];
                    flagListInfo.money = [[obj valueForKeySafely:@"money"] integerValue];
                    flagListInfo.name = [obj valueForKeySafely:@"name"] ;
                    flagListInfo.scoreForDoctorOnece = [[obj valueForKeySafely:@"score"] integerValue];
                    [comment.flagList addObject:flagListInfo];
                }];
                
                result.parsedModelObject = comment;
                
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
        
    }forKey:URL_AfterBase forPageNameGroup:pageName];
    
}

//11902用户提交点评
- (void)getCommitComment:(CommitCommentFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"SubmitRemark" forKey:@"require"];
    [param setObjectSafely:@(11902) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:@(filter.dataID) forKey:@"dataID"];
    [dataParam setObjectSafely:@(filter.numStar) forKey:@"numStar"];
    [dataParam setObjectSafely:@(filter.flagID) forKey:@"flagID"];
    [dataParam setObjectSafely:filter.content forKey:@"content"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                
                NSDictionary * data = [result.responseObject valueForKeySafely:@"data"];
                
                Comment * comment = [[Comment alloc] init];
                comment.score = [[data objectForKeySafely:@"score"] integerValue];
                
                result.parsedModelObject = comment;
                
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
        
    }forKey:URL_AfterBase forPageNameGroup:pageName];
    
}

//11903用户空间-我的点评
- (void)getMyCommentList:(MyCommentFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"UserMyRemarks" forKey:@"require"];
    [param setObjectSafely:@(11903) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:@(filter.num) forKey:@"num"];
    [dataParam setObjectSafely:@(filter.lastID) forKey:@"lastID"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                SNBaseListModel *listModel = [[SNBaseListModel alloc] init];
                NSMutableArray * dataArr = [result.responseObject valueForKeySafely:@"data"];
                NSMutableArray * listItemArr = [NSMutableArray new];
                [dataArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    Comment * comment = [[Comment alloc] init];
                    comment.content = [obj valueForKeySafely:@"content"];
                    comment.doctorName = [obj valueForKeySafely:@"doctorName"];
                    comment.doctorTitle = [obj valueForKeySafely:@"doctorTitle"];
                    comment.flagName = [obj valueForKeySafely:@"flagName"];
                    comment.numStar = [[obj valueForKeySafely:@"numStar"] integerValue];
                    comment.score = [[obj valueForKeySafely:@"score"] integerValue];
                    comment.time = [[obj valueForKeySafely:@"time"] integerValue];
                    
                    [listItemArr addObject:comment];
                }];
                listModel.items = listItemArr;
                result.parsedModelObject = listModel;
                
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
        
    }forKey:URL_AfterBase forPageNameGroup:pageName];
    
}

//11905医生口碑接口
- (void)getDoctorFameList:(DoctorFameFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"DoctorPraise" forKey:@"require"];
    [param setObjectSafely:@(11905) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:@(filter.doctorID) forKey:@"doctorID"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                DoctorFameListModel * listModel = [[DoctorFameListModel alloc] init];
                NSDictionary * data = [result.responseObject valueForKeySafely:@"data"];
                
                Comment * comment = [[Comment alloc] init];
                comment.averageStar = [[data valueForKeySafely:@"averageStar"] integerValue];
                comment.totalConern = [[data valueForKeySafely:@"totalConern"] integerValue];
                comment.totalDiagnosis = [[data valueForKeySafely:@"totalDiagnosis"] integerValue];
                comment.totalScore = [[data valueForKeySafely:@"totalScore"] integerValue];
                NSMutableArray * flagList = [NSMutableArray new];
                flagList = [data objectForKeySafely:@"flagList"];
                [flagList enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    FlagListInfo * flagListInfo = [[FlagListInfo alloc] init];
                    flagListInfo.ID = [[obj objectForKeySafely:@"ID"] integerValue];
                    flagListInfo.icon = [obj objectForKeySafely:@"icon"];
                    flagListInfo.name = [obj objectForKeySafely:@"name"];
                    flagListInfo.num = [[obj objectForKeySafely:@"num"] integerValue];
                    [comment.flagList addObject:flagListInfo];
                }];
                NSMutableArray * remarkList = [NSMutableArray new];
                remarkList = [data objectForKeySafely:@"remarkList"];
                [remarkList enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    RemarkListInfo * remarkListInfo = [[RemarkListInfo alloc] init];
                    remarkListInfo.content = [obj objectForKeySafely:@"content"] ;
//                    remarkListInfo.flagName = [obj objectForKeySafely:@"flagName"];
//                    remarkListInfo.numStar = [[obj objectForKeySafely:@"numStar"] integerValue];
//                    remarkListInfo.time = [[obj objectForKeySafely:@"time"] integerValue];
//                    remarkListInfo.userName = [obj objectForKeySafely:@"userName"];
//                    [comment.remarkList addObject:remarkListInfo];
                }];
                
                listModel.comment = comment;
                
                listModel.items = comment.remarkList;
                
                result.parsedModelObject = listModel;
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
        
    }forKey:URL_AfterBase forPageNameGroup:pageName];
    
}

//11906医生口碑接口 下拉更新更多的点评内容读取接口
- (void)getDoctorFameCommentList:(DoctorFameCommentFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"DoctorPraise" forKey:@"require"];
    [param setObjectSafely:@(11906) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:@(filter.doctorID) forKey:@"doctorID"];
    [dataParam setObjectSafely:@(pageSize) forKey:@"num"];
    [dataParam setObjectSafely:@(filter.lastID) forKey:@"lastID"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                DoctorFameListModel * listModel = [[DoctorFameListModel alloc] init];

                NSMutableArray * listItemArr = [NSMutableArray new];
                
                NSMutableArray * data = [result.responseObject valueForKeySafely:@"data"];
                [data enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    RemarkListInfo * remarkListInfo = [[RemarkListInfo alloc] init];
                    remarkListInfo.content = [obj objectForKeySafely:@"content"] ;
                    remarkListInfo.flagName = [obj objectForKeySafely:@"flagName"];
                    remarkListInfo.numStar = [[obj objectForKeySafely:@"numStar"] integerValue];
                    remarkListInfo.time = [[obj objectForKeySafely:@"time"] integerValue];
                    remarkListInfo.userName = [obj objectForKeySafely:@"userName"];
                    [listItemArr addObject:remarkListInfo];
                }];
                
                listModel.items = listItemArr;
                
                result.parsedModelObject = listModel;
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
        
    }forKey:URL_AfterBase forPageNameGroup:pageName];
    
}


@end
