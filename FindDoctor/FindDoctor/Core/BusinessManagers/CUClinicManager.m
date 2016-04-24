//
//  CUClinicManager.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/2/26.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "CUClinicManager.h"
#import "CUDoctorManager.h"
#import "CUUserManager.h"
#import "AppCore.h"
#import "CUServerAPIConstant.h"
#import "CUDoctorParser.h"
#import "SNPlatFormManager.h"
#import "JSONKit.h"
#import "TipHandler+HUD.h"
#import "CUOrder.h"

@implementation CUClinicManager

SINGLETON_IMPLENTATION(CUClinicManager);

- (void)getClinicNearbyListWithFilter:(ClinicFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"DituNearClinic" forKey:@"require"];
    [param setObjectSafely:@(31001) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    //    NSArray *types = @[@"subject", @"symptom", @"disease"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:@(filter.regionID) forKey:@"regionID"];
    [dataParam setObjectSafely:@(filter.longitude) forKey:@"longitude"];
    [dataParam setObjectSafely:@(filter.latitude) forKey:@"latitude"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
#if !LOCAL
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            //服务器内部正常
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                
                SNBaseListModel *listModel = [[SNBaseListModel alloc] init];
                
                NSArray *recvList = [result.responseObject arrayForKeySafely:@"data"];
                NSMutableArray *listSubjectClinic = [[NSMutableArray alloc] init];
                
                [recvList enumerateObjectsUsingBlockSafety:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    Clinic *clinic = [[Clinic alloc] init];
                    
                    clinic.breifInfo = [obj valueForKeySafely:@"briefIntro"];
                    clinic.icon      = [obj valueForKeySafely:@"icon"];
                    clinic.name      = [obj valueForKeySafely:@"name"];
                    clinic.doctorsString   = [obj valueForKeySafely:@"doctors"];
                    clinic.state     = [[obj valueForKeySafely:@"state"] integerValue];
                    clinic.latitude  = [[obj valueForKeySafely:@"latitude"] doubleValue];
                    clinic.longitude = [[obj valueForKeySafely:@"longitude"] doubleValue];
                    clinic.numDiag   = [[obj valueForKeySafely:@"numDiag"] integerValue];
                    clinic.ID        = [[obj valueForKeySafely:@"ID"] integerValue];
                    
                    [listSubjectClinic addObject:clinic];
                }];
                
                listModel.items = listSubjectClinic;
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
#else
    if (resultBlock) {
        resultBlock(nil, result);
    }
#endif
}

- (void)getClinicMainWithClinic:(Clinic *)clinic resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"ClinicMain" forKey:@"require"];
    [param setObjectSafely:@(31002) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    //    NSArray *types = @[@"subject", @"symptom", @"disease"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:@(clinic.ID) forKey:@"clinicID"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
#if !LOCAL
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            //服务器内部正常
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                
                NSDictionary *data = [result.responseObject dictionaryForKeySafely:@"data"];


                clinic.doctorsString   = [data valueForKeySafely:@"doctors"];
                clinic.state     = [[data valueForKeySafely:@"state"] integerValue];
                clinic.latitude  = [[data valueForKeySafely:@"latitude"] doubleValue];
                clinic.longitude = [[data valueForKeySafely:@"longitude"] doubleValue];
                clinic.numDiag   = [[data valueForKeySafely:@"numDiag"] integerValue];
                
                clinic.ID        = [[data valueForKeySafely:@"ID"] integerValue];
                clinic.address   = [data valueForKeySafely:@"address"];
                clinic.breifInfo = [data valueForKeySafely:@"briefIntro"];
                clinic.detailIntro = [data valueForKeySafely:@"detailIntro"];
                clinic.phone     = [data valueForKeySafely:@"phone"];
                clinic.goodRemark = [data integerForKeySafely:@"goodRemark"];
                clinic.icon      = [data valueForKeySafely:@"icon"];
                clinic.name      = [data valueForKeySafely:@"name"];
                clinic.isConcern = [[data valueForKeySafely:@"isConcern"] integerValue]!=0 ? YES: NO;
                clinic.numDiag   = [[data valueForKeySafely:@"numDiag"] integerValue];
                clinic.numConcern   = [[data valueForKeySafely:@"numConcern"] integerValue];
                clinic.skillTreat   = [data valueForKeySafely:@"skillTreat"];
                
                NSArray *recvList   = [data valueForKeySafely:@"isConcern"];
//                NSMutableArray *recvList = [data objectForKey:@"doctorList"];
                NSMutableArray *subjectList = [NSMutableArray new];
                
//                [ParserTools enumerateObjects:recvList UsingBlockSafety:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    Doctor *doctor = [[Doctor  alloc]init];
//                    doctor.doctorId = [[obj valueForKey:@"ID"] integerValue];
//                    doctor.avatar = [obj valueForKey:@"icon"];
//                    doctor.name = [obj valueForKey:@"name"];
//                    doctor.doctorState = [[obj valueForKey:@"state"] integerValue];
//                    doctor.levelDesc = [obj valueForKey:@"title"];
//                    [subjectList addObject:doctor];
//                }];
                
                [recvList enumerateObjectsUsingBlockSafety:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    Doctor *doctor = [[Doctor  alloc]init];
                    doctor.doctorId = [[obj valueForKey:@"ID"] integerValue];
                    doctor.avatar = [obj valueForKey:@"icon"];
                    doctor.name = [obj valueForKey:@"name"];
                    doctor.doctorState = [[obj valueForKey:@"state"] integerValue];
                    doctor.levelDesc = [obj valueForKey:@"title"];
                    [subjectList addObject:doctor];
                }];
                clinic.doctorsArray = subjectList;
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
#else
    if (resultBlock) {
        resultBlock(nil, result);
    }
#endif
}



- (void)clinicConcernWithClinic:(Clinic *)clinic resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"ClinicConcern" forKey:@"require"];
    [param setObjectSafely:@(32002) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:@(clinic.ID) forKey:@"clinicID"];
    [dataParam setObjectSafely:@(clinic.isConcern ? 0 : 1) forKey:@"isConcern"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
#if !LOCAL
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            //服务器内部正常
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
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
#else
    if (resultBlock) {
        resultBlock(nil, result);
    }
#endif
}

- (void)getMyClinicWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"MyFavorite" forKey:@"require"];
    [param setObjectSafely:@(13102) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
#if !LOCAL
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            //服务器内部正常
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                SNBaseListModel *listModel = [[SNBaseListModel alloc] init];
                
                NSArray *recvList = [result.responseObject arrayForKeySafely:@"data"];
                NSMutableArray *listSubjectDoctor = [[NSMutableArray alloc] init];
                
                [recvList enumerateObjectsUsingBlockSafety:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    Clinic *clinic = [[Clinic alloc] init];
                    
                    clinic.ID = [(NSNumber *)[obj valueForKey:@"clinicID"] integerValue];
                    clinic.state = [(NSNumber *)[obj valueForKey:@"clinicID"] integerValue];
                    clinic.name = [obj valueForKey:@"name"];
                    clinic.icon = [obj valueForKey:@"icon"];
                    clinic.breifInfo = [obj valueForKey:@"briefIntro"];
                    clinic.skillTreat = [obj valueForKey:@"skillTreat"];
                    
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
#else
    if (resultBlock) {
        resultBlock(nil, result);
    }
#endif
}

//好评诊所
- (void)getGoodRemarkClinicListWithFilter:(ClinicFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:14202 require:@"goodRemarkDoctorList"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:@"/baseFrame/base/goodRemarkClinicList.jmm" parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if ([errorCode integerValue] != -1) {
                
                NSMutableArray * dataList = [NSMutableArray array];
                
                NSDictionary * data = [result.responseObject dictionaryForKeySafely:@"data"];
                NSArray * tempList1 = [data arrayForKeySafely:@"goodRemarkClinicList"];
                [tempList1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    Clinic * clinic = [[Clinic alloc] init];
                    
                    clinic.ID = [obj longlongForKeySafely:@"clinicID"];
                    clinic.goodRemark = [obj integerForKeySafely:@"goodRemark"];
                    clinic.skillTreat = [obj stringForKeySafely:@"goodatsubjects"];
                    clinic.icon = [obj stringForKeySafely:@"icon"];
                    clinic.name = [obj stringForKeySafely:@"name"];
                    
                    [dataList addObjectSafely:clinic];
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


@end
