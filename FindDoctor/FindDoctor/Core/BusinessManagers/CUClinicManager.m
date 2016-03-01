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
    [param setObjectSafely:@"ios" forKey:@"from"];
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
                
                NSMutableArray *recvListClinic = [result.responseObject valueForKeySafely:@"data"];
                NSMutableArray *listSubjectClinic = [[NSMutableArray alloc] init];
                
                [recvListClinic enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
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
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject valueForKey:@"data"]];
            }
        }
        else {
            NSLog(@"====哦哟，出错了====");
            [TipHandler showTipOnlyTextWithNsstring:@"====哦哟，出错了===="];
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
    [param setObjectSafely:@"ios" forKey:@"from"];
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
                
                NSMutableDictionary *data = [result.responseObject valueForKey:@"data"];


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
                clinic.goodRemark = [[data valueForKeySafely:@"goodRemark"] integerValue];
                clinic.icon      = [data valueForKeySafely:@"icon"];
                clinic.name      = [data valueForKeySafely:@"name"];
                clinic.isConcern = [[data valueForKeySafely:@"isConcern"] integerValue]!=0 ? YES: NO;
                clinic.numDiag   = [[data valueForKeySafely:@"numDiag"] integerValue];
                clinic.numConcern   = [[data valueForKeySafely:@"numConcern"] integerValue];
                clinic.skillTreat   = [data valueForKeySafely:@"skillTreat"];
                
                NSMutableArray *recvList = [data objectForKey:@"doctorList"];
                NSMutableArray *subjectList = [NSMutableArray new];
                [recvList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject valueForKey:@"data"]];
            }
        }
        else {
            NSLog(@"====哦哟，出错了====");
            [TipHandler showTipOnlyTextWithNsstring:@"====哦哟，出错了===="];
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
    [param setObjectSafely:@"ios" forKey:@"from"];
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
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject valueForKey:@"data"]];
            }
        }
        else {
            NSLog(@"====哦哟，出错了====");
            [TipHandler showTipOnlyTextWithNsstring:@"====哦哟，出错了===="];
        }
        
        resultBlock(request, result);
        
    }forKey:@"get_subject_doctor_list" forPageNameGroup:pageName];
#else
    if (resultBlock) {
        resultBlock(nil, result);
    }
#endif
}



@end
