//
//  CommonManager.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/20.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "CommonManager.h"
#import "CUUserManager.h"
#import "JSONKit.h"
#import "AppCore.h"
#import "CUServerAPIConstant.h"
#import "TipHandler+HUD.h"
#import "SNBaseListModel.h"
#import "Clinic.h"
#import "Doctor.h"
#import "HFRequestHeaderDict.h"

@implementation CommonManager

SINGLETON_IMPLENTATION(CommonManager);

- (void)getSubjectListWithFilter:(SubObjectFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:14202 require:@"subjectList"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:@"/baseFrame/base/subjectList.jmm" parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if ([errorCode integerValue] != -1) {
                
                NSMutableArray * dataList = [NSMutableArray array];
                
                NSDictionary * data = [result.responseObject dictionaryForKeySafely:@"data"];
                NSArray * tempList1 = [data arrayForKeySafely:@"subjectList"];
                [tempList1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    SubObject * subject = [[SubObject alloc] init];
                    subject.name = [obj stringForKeySafely:@"name"];
                    subject.type_id = [obj longlongForKeySafely:@"ID"];
                    subject.imageURL = [obj stringForKeySafely:@"img"];
                    [dataList addObjectSafely:subject];
                }];
                result.parsedModelObject = dataList;
            }
            else {
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject stringForKeySafely:@"message"]];
            }
        }
        else {
            NSLog(@"连接服务器失败，请检查网络");
//            [TipHandler showTipOnlyTextWithNsstring:@"连接服务器失败，请检查网络"];
        }
        
        resultBlock(request, result);
        
    }forKey:URL_AfterBase forPageNameGroup:pageName];
    
}

- (void)getActivityBannerWithFilter:(BannerFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:14202 require:@"ActivityBanner"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:@"/baseFrame/base/ActivityBanner.jmm" parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                
                NSMutableDictionary * dataDict = [NSMutableDictionary dictionary];
                NSMutableArray * mainList = [NSMutableArray array];
                NSMutableArray * secondList = [NSMutableArray array];
                
                NSDictionary * data = [result.responseObject dictionaryForKeySafely:@"data"];
                NSArray * tempList1 = [data arrayForKeySafely:@"main"];
                [tempList1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    Banner * banner = [[Banner alloc] init];
                    banner.activityId = [obj longlongForKeySafely:@"activityId"];
                    banner.imagePath = [obj stringForKeySafely:@"imagePath"];
                    banner.type = [obj stringForKeySafely:@"type"];
                    banner.redirectId = [obj integerForKeySafely:@"redirectId"];
                    [mainList addObjectSafely:banner];
                }];
                
                NSArray * tempList2 = [data arrayForKeySafely:@"second"];
                [tempList2 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    Banner * banner = [[Banner alloc] init];
                    banner.activityId = [obj longlongForKeySafely:@"activityId"];
                    banner.imagePath = [obj stringForKeySafely:@"imagePath"];
                    banner.type = [obj stringForKeySafely:@"type"];
                    banner.redirectId = [obj integerForKeySafely:@"redirectId"];
                    [secondList addObjectSafely:banner];
                }];
                
                [dataDict setObjectSafely:mainList forKey:@"main"];
                [dataDict setObjectSafely:secondList forKey:@"second"];
                
                result.parsedModelObject = dataDict;
            }
            else {
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject stringForKeySafely:@"message"]];
            }
        }
        else {
            NSLog(@"连接服务器失败，请检查网络");
            //            [TipHandler showTipOnlyTextWithNsstring:@"连接服务器失败，请检查网络"];
        }
        
        resultBlock(request, result);
        
    }forKey:URL_AfterBase forPageNameGroup:pageName];
    
}

@end
