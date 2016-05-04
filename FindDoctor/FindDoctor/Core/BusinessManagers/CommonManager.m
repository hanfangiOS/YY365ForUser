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
#import "OptionList.h"

@implementation CommonManager

SINGLETON_IMPLENTATION(CommonManager);

//获取科目列表
- (void)getSubjectListWithFilter:(SubObjectFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:14202 require:@"subjectList"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:URL_subjectList parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                
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
        
    }forKey:@"subjectList" forPageNameGroup:pageName];
    
}

//轮播图
- (void)getActivityBannerWithFilter:(BannerFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:14202 require:@"ActivityBanner"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:URL_ActivityBanner parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
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
        
    }forKey:@"ActivityBanner" forPageNameGroup:pageName];
}


- (void)getOptionListWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:11101 require:@"OptionList"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
//    [dataParam setObject:@( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.userId : 0 )  forKey:@"accID"];
    [dataParam setObject:@(510000) forKey:@"regionID"];
    [dataParam setObject:kCurrentLng forKey:@"longitude"];
    [dataParam setObject:kCurrentLat forKey:@"latitude"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:URL_OptionList parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                
                NSMutableDictionary * dataDict = [NSMutableDictionary dictionary];
                
                NSArray *recListDate = [[result.responseObject dictionaryForKeySafely:@"data"] arrayForKeySafely:@"dateOption"];
                NSArray *recListRegion = [[result.responseObject dictionaryForKeySafely:@"data"] arrayForKeySafely:@"regionOption"];
                NSArray *recListSymptom= [[result.responseObject dictionaryForKeySafely:@"data"] arrayForKeySafely:@"symptomOption"];
                
                NSMutableArray *resultListDate= [NSMutableArray array];
                [recListDate enumerateObjectsUsingBlockSafety:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    DateOption *dateoption = [[DateOption alloc]init];
                    dateoption.ID = [obj integerForKeySafely:@"ID"];
                    dateoption.date = [obj valueForKeySafely:@"date"];
                    [resultListDate addObject:dateoption];
                }];
                [dataDict setObject:resultListDate forKey:@"dateOption"];
                
                NSMutableArray *resultListRegion= [NSMutableArray array];
                [recListRegion enumerateObjectsUsingBlockSafety:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    RegionOption *regionOption = [[RegionOption alloc]init];
                    regionOption.ID = [[[obj dictionaryForKeySafely:@"regionOption"]valueForKey:@"id"] integerValue];
                    regionOption.name = [[obj dictionaryForKeySafely:@"regionOption"]valueForKeySafely:@"name"];
                    [resultListRegion addObject:regionOption];
                }];
                [dataDict setObject:resultListRegion forKey:@"regionOption"];
                
                NSMutableArray *resultListSymptom= [NSMutableArray array];
                [recListSymptom enumerateObjectsUsingBlockSafety:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    SymptomOption *symptomOption = [[SymptomOption alloc]init];
                    symptomOption.ID = [[[obj dictionaryForKeySafely:@"symptomOption"]valueForKey:@"id"] integerValue];
                    symptomOption.name = [[obj dictionaryForKeySafely:@"symptomOption"]valueForKeySafely:@"name"];
                    
                    NSArray *sub = [[obj dictionaryForKeySafely:@"symptomOption"]valueForKeySafely:@"child"];
                    NSMutableArray *subResultArr = [NSMutableArray array];
                    if (sub) {
                        for(NSDictionary *dic in sub){
                            SymptomSubOption *subOption = [[SymptomSubOption alloc]init];
                            subOption.ID = [[dic valueForKey:@"id"] integerValue];
                            subOption.name = [dic stringForKeySafely:@"name"];
                            [subResultArr addObject:subOption];
                        }
                    }
                    symptomOption.symptomSubOptionArray = subResultArr;
                    [resultListSymptom addObject:symptomOption];
                }];
                [dataDict setObject:resultListSymptom forKey:@"symptomOption"];
                
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
        
    }forKey:@"ActivityBanner" forPageNameGroup:pageName];
}

@end
