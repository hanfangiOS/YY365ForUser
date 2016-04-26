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
#import "Clinic.h"
#import "Doctor.h"

@implementation CUSearchManager

SINGLETON_IMPLENTATION(CUSearchManager);

- (void)getDoctorSearchResultListWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize filter:(SearchFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary * param = [NSMutableDictionary new];
    [param setObjectSafely:kPlatForm forKey:@"from"];
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
                SNBaseListModel * listModel = [[SNBaseListModel alloc] init];
                NSArray * list1 = [result.responseObject arrayForKeySafely:@"data"];
                NSMutableArray * searchResultList = [NSMutableArray new];
                [list1 enumerateObjectsUsingBlockSafety:^(NSDictionary * obj, NSUInteger idx, BOOL * stop) {
                    NSInteger dataType = [[obj valueForKeySafely:@"dataType"] integerValue];
                    switch (dataType) {
                        case 6:{
                            Doctor *doctor = [[Doctor alloc]init];
                            doctor.name = [obj valueForKeySafely:@"name"];
                            doctor.doctorId =  [[obj valueForKeySafely:@"dataID"] integerValue];
                            doctor.avatar =  [obj valueForKeySafely:@"icon"];
                            doctor.briefIntro = [obj valueForKeySafely:@"brief"];
                            doctor.skillTreat = [obj valueForKeySafely:@"skill"];
                            doctor.levelDesc = [obj valueForKeySafely:@"title"];
                            doctor.numDiag = [[obj valueForKeySafely:@"numDiag"] integerValue];
//                            doctor.doctorState = [[obj valueForKeySafely:@"orderState"] integerValue];
                            doctor.doctorState = -1;
                            [searchResultList addObject:doctor];
                            
                        }break;
                        case 7:{
                            Clinic *clinic = [[Clinic alloc]init];
                            clinic.ID =  [[obj valueForKeySafely:@"dataID"] integerValue];
                            clinic.icon =  [obj valueForKeySafely:@"icon"];
                            clinic.breifInfo = [obj valueForKeySafely:@"brief"];
                            clinic.skillTreat = [obj valueForKeySafely:@"skill"];
                            clinic.name = [obj valueForKeySafely:@"name"];
                            clinic.numDiag = [[obj valueForKeySafely:@"numDiag"] integerValue];
                            [searchResultList addObject:clinic];
                        }break;
                        default:
                            break;
                    }
                }];
                listModel.items = searchResultList;
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
        
    }forKey:@"get_subject_doctor_list" forPageNameGroup:pageName];
    
}

- (void)gethotSearchClinicListWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:14202 require:@"hotSearchClinic"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);

    [[AppCore sharedInstance].apiManager POST:@"/baseFrame/base/hotSearchClinic.jmm" parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                NSArray *recList = [[result.responseObject dictionaryForKeySafely:@"data"] arrayForKeySafely:@"hotSearchClinicList"];
                NSMutableArray *dataList = [NSMutableArray new];
                [recList enumerateObjectsUsingBlockSafety:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *str = [obj valueForKey:@"keys"];
                    [dataList addObject:str];
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
    }forKey:@"hotSearchClinicList" forPageNameGroup:pageName];
}

- (void)gethotSearchSymptomListWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:14202 require:@"hotSearchSymptom"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:@"/baseFrame/base/hotSearchSymptom.jmm" parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                NSArray *recList = [[result.responseObject dictionaryForKeySafely:@"data"] arrayForKeySafely:@"hotSearchSymptomList"];
                NSMutableArray *dataList = [NSMutableArray new];
                [recList enumerateObjectsUsingBlockSafety:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *str = [obj valueForKey:@"keys"];
                    [dataList addObject:str];
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
    }forKey:@"hotSearchSymptom" forPageNameGroup:pageName];
}

- (void)gethotSearchDoctorListWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:14202 require:@"hotSearchDoctor"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:@"/baseFrame/base/hotSearchDoctor.jmm" parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                NSArray *recList = [[result.responseObject dictionaryForKeySafely:@"data"] arrayForKeySafely:@"hotSearchDoctorList"];
                NSMutableArray *dataList = [NSMutableArray new];
                [recList enumerateObjectsUsingBlockSafety:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    Doctor *doctor =  [[Doctor alloc]init];
                    doctor.name = [obj valueForKey:@"name"];
                    doctor.doctorId = [obj integerForKeySafely:@"doctorid"];
                    doctor.avatar = [obj valueForKey:@"icon"];
                    doctor.skillTreat = [obj valueForKey:@"goodatdisease"];
                    [dataList addObject:doctor];
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
    }forKey:@"hotSearchDoctor" forPageNameGroup:pageName];
}


@end
