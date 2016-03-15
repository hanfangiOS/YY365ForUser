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
                comment.scoreForUserOnece = 20;
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

@end
