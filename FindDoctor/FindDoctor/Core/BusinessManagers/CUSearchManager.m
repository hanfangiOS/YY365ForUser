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

- (void)getSearchResultListWithFilter:(SearchFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{

    
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:11101 require:@"SearchEntry"];
    NSMutableDictionary * dataParam = [NSMutableDictionary new];
    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:filter.keyword forKey:@"search"];
//    if ([filter.keyword isEqualToString:@"-1"]){
//       [dataParam setObjectSafely:@(filter.subjectID) forKey:@"search"];
//    }
    [dataParam setObjectSafely:@([kCurrentLng doubleValue]) forKey:@"longtitude"];
    [dataParam setObjectSafely:@([kCurrentLat doubleValue]) forKey:@"latitude"];
    [dataParam setObjectSafely:[filter.subject.name isEqualToString:@"全部"] ? @"-1":filter.subject.name forKey:@"subject"];
//    [dataParam setObjectSafely:@(filter.region.ID) forKey:@"regionID"];
    [dataParam setObjectSafely:filter.region.name forKey:@"region"];
    [dataParam setObjectSafely:[filter.symptom.name isEqualToString:@"全部"] ? @"-1":filter.symptom.name forKey:@"symptom"];
    [dataParam setObjectSafely:@(filter.rows) forKey:@"rows"];
    [dataParam setObjectSafely:@(filter.total) forKey:@"total"];
    [dataParam setObjectSafely:filter.date forKey:@"orderDate"];
    [dataParam setObjectSafely:filter.searchListType == SearchListTypeDoctor ? @"doctorList":@"clinicList" forKey:@"listType"];
//    [dataParam setObjectSafely:@"clinicList" forKey:@"listType"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];

    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                
                SNBaseListModel *listModel = [[SNBaseListModel alloc] init];
                
                NSArray *recvListDoctor = [[result.responseObject dictionaryForKeySafely:@"data"] arrayForKeySafely:@"doctorList"];
                NSMutableArray *listSubjectDoctor = [[NSMutableArray alloc] init];
                
                [recvListDoctor enumerateObjectsUsingBlockSafety:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
                    Doctor *doctor = [[Doctor alloc] init];
                    
                    doctor.doctorId = [(NSNumber *)[obj valueForKey:@"dataID"] integerValue];
                    doctor.briefIntro = [obj valueForKey:@"briefIntro"];
                    doctor.avatar = [obj valueForKey:@"icon"];
                    if ([doctor.avatar isEqualToString:@"0"]) {
                        NSString *sex = [obj valueForKey:@"sex"];
                        if ([sex isEqualToString:@"男"]) {
                            doctor.avatar = [NSString stringWithFormat:@"http://uyi365.com/hanfang_nan.png"];
                        }else{
                            doctor.avatar = [NSString stringWithFormat:@"http://uyi365.com/hanfang_nv.png"];
                        }
                    }
                    doctor.subject = [obj valueForKey:@"matchItemDisease"];
                    doctor.name = [obj valueForKey:@"name"];
                    doctor.skillTreat = [obj valueForKey:@"skillTreat"];
                    doctor.levelDesc = [obj valueForKey:@"title"];
                    //
                    //                        doctor.isAvailable = YES;  //医生可以约诊， 这个是可约诊列表
                    //                        if([(NSNumber *)[obj valueForKey:@"state"] integerValue] == 2) doctor.isAvailable = NO;
                    //
                    doctor.rate = [(NSNumber *)[obj valueForKey:@"star_grade"] doubleValue];
                    doctor.price = [(NSNumber *)[obj valueForKey:@"fee"] doubleValue];
                    doctor.availableTime = [obj valueForKey:@"date"];
                    doctor.address = [NSString stringWithFormat:@"%@(%@)",[obj valueForKey:@"clinicName"],[obj valueForKey:@"address"]];
                    doctor.doctorState = [[obj valueForKey:@"state"] integerValue];
                    doctor.numDiag = [[obj valueForKey:@"numDiag"] integerValue];
//                    doctor.doctorState = -1;
                    
                    [listSubjectDoctor addObject:doctor];
                }];
                
                recvListDoctor = [[result.responseObject dictionaryForKeySafely:@"data"] arrayForKeySafely:@"clinicList"];
                
                [recvListDoctor enumerateObjectsUsingBlockSafety:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
                    Clinic *clinic = [[Clinic alloc] init];
                    
                    clinic.ID = [(NSNumber *)[obj valueForKey:@"dataID"] integerValue];
                    clinic.icon = [obj valueForKey:@"icon"];
                    clinic.name = [obj valueForKey:@"name"];
                    clinic.skillTreat = [obj valueForKey:@"skillTreat"];
                    clinic.address = [NSString stringWithFormat:@"%@(%@)",[obj valueForKey:@"clinicName"],[obj valueForKey:@"clinicAddress"]];
                    
                    [listSubjectDoctor addObject:clinic];
                }];
                
                
                listModel.items = listSubjectDoctor;
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

    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                NSArray *recList = [[result.responseObject dictionaryForKeySafely:@"data"] arrayForKeySafely:@"hotSearchClinicList"];
                NSMutableArray *dataList = [NSMutableArray new];
                [recList enumerateObjectsUsingBlockSafety:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    Clinic *clinic = [[Clinic alloc]init];
                    clinic.name = [obj valueForKey:@"keys"];
                    clinic.ID = [[obj valueForKey:@"clinicID"] integerValue];
                    [dataList addObject:clinic];
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
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
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
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
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
                    doctor.skillTreat = [obj valueForKey:@"skilltreat"];
                    doctor.levelDesc = [obj valueForKey:@"title"];
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
