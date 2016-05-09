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
- (void)getDiagnosisComment:(CommentFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"ClickRemark" forKey:@"require"];
    [param setObjectSafely:@(11901) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
    //    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:@(19) forKey:@"accID"];
    [dataParam setObjectSafely:@(filter.order.diagnosisID) forKey:@"diagnosisID"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    

    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                
                NSDictionary * data = [result.responseObject dictionaryForKeySafely:@"data"];
                
                Doctor * doctor = [[Doctor alloc] init];
                doctor.address = [data objectForKeySafely:@"clinicAddress"];
                doctor.clinicName = [data objectForKeySafely:@"clinicName"];
                doctor.diagnosisTime = [[data objectForKeySafely:@"diagnosisTime"] integerValue];
                doctor.avatar = [data objectForKeySafely:@"doctorIcon"];
                doctor.name = [data objectForKeySafely:@"doctorName"];
                doctor.levelDesc = [data objectForKeySafely:@"doctorTitle"];
                NSArray * flagList = [NSArray new];
                flagList = [data arrayForKeySafely:@"flagList"];
                [flagList enumerateObjectsUsingBlockSafety:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    FlagListInfo * flagListInfo = [[FlagListInfo alloc] init];
                    flagListInfo.ID = [[obj valueForKeySafely:@"ID"] integerValue];
                    flagListInfo.icon = [obj valueForKeySafely:@"icon"];
                    flagListInfo.money = [[obj valueForKeySafely:@"money"] integerValue];
                    flagListInfo.name = [obj valueForKeySafely:@"name"] ;
                    flagListInfo.score = [[obj valueForKeySafely:@"score"] integerValue];
                    [doctor.flagList addObject:flagListInfo];
                }];
                
                result.parsedModelObject = doctor;
//
            }
            else {
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject stringForKeySafely:@"data"]];
            }
        }
        else {
            NSLog(@"连接服务器失败，请检查网络");
            [TipHandler showTipOnlyTextWithNsstring:@"连接服务器失败，请检查网络"];
        }
        
        resultBlock(request, result);
        
    }forKey:URL_AfterBase forPageNameGroup:pageName];
    
}

//11902用户提交点评
- (void)getCommitComment:(CommentFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"SubmitRemark" forKey:@"require"];
    [param setObjectSafely:@(11902) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
    //    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:@(19) forKey:@"accID"];
    [dataParam setObjectSafely:@(filter.order.diagnosisID) forKey:@"dataID"];
    [dataParam setObjectSafely:@(filter.remarkListInfo.numStar) forKey:@"numStar"];
    [dataParam setObjectSafely:@(filter.remarkListInfo.flagID) forKey:@"flagID"];
    [dataParam setObjectSafely:filter.remarkListInfo.content forKey:@"content"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                
                NSDictionary * data = [result.responseObject dictionaryForKeySafely:@"data"];
//                
//                Comment * comment = [[Comment alloc] init];
//                comment.score = [[data objectForKeySafely:@"score"] integerValue];
//                
//                result.parsedModelObject = comment;
                
            }
            else {
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject stringForKeySafely:@"data"]];
            }
        }
        else {
            NSLog(@"连接服务器失败，请检查网络");
            [TipHandler showTipOnlyTextWithNsstring:@"连接服务器失败，请检查网络"];
        }
        
        resultBlock(request, result);
        
    }forKey:URL_AfterBase forPageNameGroup:pageName];
    
}

//11903用户空间-我的点评
- (void)getMyCommentList:(CommentFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"UserMyRemarks" forKey:@"require"];
    [param setObjectSafely:@(11903) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
    //    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:@(19) forKey:@"accID"];
    [dataParam setObjectSafely:@(pageSize) forKey:@"num"];
    [dataParam setObjectSafely:@(filter.lastID) forKey:@"lastID"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                SNBaseListModel *listModel = [[SNBaseListModel alloc] init];
                NSArray * dataArr = [result.responseObject arrayForKeySafely:@"data"];
                NSMutableArray * listItemArr = [NSMutableArray new];
               
                [dataArr enumerateObjectsUsingBlockSafety:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    RemarkListInfo * remarkListInfo = [[RemarkListInfo alloc] init];
                    remarkListInfo.content = [NSString stringWithFormat:@"%@",[obj valueForKeySafely:@"content"]];
                    remarkListInfo.doctorName = [obj valueForKeySafely:@"doctorName"];
                    remarkListInfo.doctorTitle = [obj valueForKeySafely:@"doctorTitle"];
                    remarkListInfo.flagName = [obj valueForKeySafely:@"flagName"];
                    remarkListInfo.numStar = [[obj valueForKeySafely:@"numStar"] integerValue];
                    remarkListInfo.score = [[obj valueForKeySafely:@"score"] integerValue];
                    remarkListInfo.time = [[obj valueForKeySafely:@"time"] integerValue];
                    
                    [listItemArr addObject:remarkListInfo];
                }];
                
                listModel.items = listItemArr;
                result.parsedModelObject = listModel;
                
            }
            else {
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject stringForKeySafely:@"data"]];
            }
        }
        else {
            NSLog(@"连接服务器失败，请检查网络");
            [TipHandler showTipOnlyTextWithNsstring:@"连接服务器失败，请检查网络"];
        }
        
        resultBlock(request, result);
        
    }forKey:URL_AfterBase forPageNameGroup:pageName];
    
}

//11905医生口碑接口
- (void)getDoctorFameList:(CommentFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"DoctorPraise" forKey:@"require"];
    [param setObjectSafely:@(11905) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:@(filter.doctor.doctorId) forKey:@"doctorID"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                DoctorFameListModel * listModel = [[DoctorFameListModel alloc] init];
                NSDictionary * data = [result.responseObject dictionaryForKeySafely:@"data"];
                
                Doctor * doctor = [[Doctor alloc] init];
                doctor.rate = [[data valueForKeySafely:@"averageStar"] floatValue];
                doctor.numConcern = [[data valueForKeySafely:@"totalConern"] integerValue];
                doctor.numDiag = [[data valueForKeySafely:@"totalDiagnosis"] integerValue];
                doctor.score = [[data valueForKeySafely:@"totalScore"] integerValue];
                NSArray * flagList = [NSArray new];
                flagList = [data arrayForKeySafely:@"flagList"];
                [flagList enumerateObjectsUsingBlockSafety:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    FlagListInfo * flagListInfo = [[FlagListInfo alloc] init];
                    flagListInfo.ID = [[obj objectForKeySafely:@"ID"] integerValue];
                    flagListInfo.icon = [obj objectForKeySafely:@"icon"];
                    flagListInfo.name = [obj objectForKeySafely:@"name"];
                    flagListInfo.num = [[obj objectForKeySafely:@"num"] integerValue];
                    [doctor.flagList addObject:flagListInfo];
                }];
                
                NSArray * remarkList = [NSArray new];
                remarkList = [data arrayForKeySafely:@"remarkList"];
                [remarkList enumerateObjectsUsingBlockSafety:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    RemarkListInfo * remarkListInfo = [[RemarkListInfo alloc] init];
                    
                    remarkListInfo.content = [NSString stringWithFormat:@"%@",[obj valueForKeySafely:@"content"]] ;
                    remarkListInfo.flagName = [obj objectForKeySafely:@"flagName"];
                    remarkListInfo.numStar = [[obj objectForKeySafely:@"numStar"] integerValue];
                    remarkListInfo.time = [[obj objectForKeySafely:@"time"] integerValue];
                    remarkListInfo.userName = [obj objectForKeySafely:@"userName"];
                    [doctor.remarkList addObject:remarkListInfo];
                }];
                
                listModel.doctor = doctor;
                listModel.filter = filter;
                
                listModel.items = doctor.remarkList;
                
                result.parsedModelObject = listModel;
            }
            else {
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject stringForKeySafely:@"data"]];
            }
        }
        else {
            NSLog(@"连接服务器失败，请检查网络");
            [TipHandler showTipOnlyTextWithNsstring:@"连接服务器失败，请检查网络"];
        }
        
        resultBlock(request, result);
        
    }forKey:URL_AfterBase forPageNameGroup:pageName];
    
}

//11906医生口碑接口 下拉更新更多的点评内容读取接口
- (void)getDoctorFameCommentList:(CommentFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"DoctorPraise" forKey:@"require"];
    [param setObjectSafely:@(11906) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:@(filter.doctor.doctorId) forKey:@"doctorID"];
    [dataParam setObjectSafely:@(pageSize) forKey:@"num"];
    [dataParam setObjectSafely:@(filter.lastID) forKey:@"lastID"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                DoctorFameListModel * listModel = [[DoctorFameListModel alloc] init];
                NSMutableArray * listItemArr = [NSMutableArray new];
                NSArray * data = [result.responseObject arrayForKeySafely:@"data"];
                [data enumerateObjectsUsingBlockSafety:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject stringForKeySafely:@"data"]];
            }
        }
        else {
            NSLog(@"连接服务器失败，请检查网络");
            [TipHandler showTipOnlyTextWithNsstring:@"连接服务器失败，请检查网络"];
        }
        
        resultBlock(request, result);
        
    }forKey:URL_AfterBase forPageNameGroup:pageName];
    
}


@end
