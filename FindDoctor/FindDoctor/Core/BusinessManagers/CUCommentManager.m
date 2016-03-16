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

@implementation CUCommentManager

SINGLETON_IMPLENTATION(CUCommentManager);

//11903用户空间-我的点评
- (void)getMyCommentList:(MyCommentFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:@"ios" forKey:@"from"];
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
                    //                    comment.content = [obj valueForKeySafely:@"content"];
                    //                    comment.doctorName = [obj valueForKeySafely:@"doctorName"];
                    //                    comment.doctorTitle = [obj valueForKeySafely:@"doctorTitle"];
                    //                    comment.flagName = [obj valueForKeySafely:@"flagName"];
                    //                    comment.numStar = [[obj valueForKeySafely:@"numStar"] integerValue];
                    //                    comment.scoreForUserOnece = [[obj valueForKeySafely:@"score"] integerValue];
                    //                    comment.time = [[obj valueForKeySafely:@"time"] integerValue];
                    
                    [listItemArr addObject:comment];
                }];
                
                
                Comment * comment = [[Comment alloc] init];
                comment.content = @"XXXX1dmsakslcscsdcdscsdaasdcascdsvasdfasdasCASCSACASCASDasdcasCDVDSVDSCDSVDmsakslcmadsl才sq";
                comment.doctorName = @"XXXX2";
                comment.doctorTitle = @"XXXX3";
                comment.flagName = @"XXXX4";
                comment.numStar = 4;
                comment.score = 20;
                comment.time = 1458012222;
                [listItemArr addObject:comment];
                [listItemArr addObject:comment];
                [listItemArr addObject:comment];
                [listItemArr addObject:comment];
                [listItemArr addObject:comment];
                
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
    [param setObjectSafely:@"ios" forKey:@"from"];
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
                SNBaseListModel * listModel = [[SNBaseListModel alloc] init];
                NSDictionary * data = [result.responseObject valueForKeySafely:@"data"];
                NSMutableArray * listItemArr = [NSMutableArray new];
 
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
//                        RemarkListInfo * remarkListInfo = [[RemarkListInfo alloc] init];
//                        remarkListInfo.content = [obj objectForKeySafely:@"content"] ;
//                        remarkListInfo.flagName = [obj objectForKeySafely:@"flagName"];
//                        remarkListInfo.numStar = [[obj objectForKeySafely:@"numStar"] integerValue];
//                        remarkListInfo.time = [[obj objectForKeySafely:@"time"] integerValue];
//                        remarkListInfo.userName = [obj objectForKeySafely:@"userName"];
//                        [comment.remarkList addObject:remarkListInfo];
                    }];
                
                
                RemarkListInfo * remarkListInfo = [[RemarkListInfo alloc] init];
                remarkListInfo.content = @"scjsncmsacsaxssdsamcmasclsacmadsmcqwkfcsacmascmsmmscms水滴石穿撒没吃撒开吃开撒么sq" ;
                remarkListInfo.flagName = @"阿西吧";
                remarkListInfo.numStar = 4;
                remarkListInfo.time = 1458107629;
                remarkListInfo.userName = @"郭晓薇";
                [comment.remarkList addObject:remarkListInfo];
                [comment.remarkList addObject:remarkListInfo];
                [comment.remarkList addObject:remarkListInfo];
                
    
                [listItemArr addObject:comment];
       
                
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
