
//  CUDoctorManager.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/13.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUDoctorManager.h"
#import "CUUserManager.h"
#import "AppCore.h"
#import "CUServerAPIConstant.h"
#import "CUDoctorParser.h"
#import "SNPlatFormManager.h"
#import "JSONKit.h"
#import "TipHandler+HUD.h"
#import "CUOrder.h"


#import "NSDate+SNExtension.h"

@implementation CUDoctorManager

SINGLETON_IMPLENTATION(CUDoctorManager);

- (void)getDoctorListWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize filter:(DoctorFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    if(filter.classNumber == 0){
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObjectSafely:kPlatForm forKey:@"from"];
        [param setObjectSafely:@"0" forKey:@"token"];
        [param setObjectSafely:@"SearchDoctorBySubject" forKey:@"require"];
        [param setObjectSafely:@(11101) forKey:@"interfaceID"];
        [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
        
        //    NSArray *types = @[@"subject", @"symptom", @"disease"];
        
        NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
        [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
        [dataParam setObjectSafely:@(filter.typeId) forKey:@"subjectID"];
        [dataParam setObjectSafely:@(510000) forKey:@"regionID"];
        [dataParam setObjectSafely:@([kCurrentLng doubleValue]) forKey:@"longitude"];
        [dataParam setObjectSafely:@([kCurrentLat doubleValue]) forKey:@"latitude"];
        
        [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
        
        NSLog(@"%@",param);
        
        [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
            
            if (!result.hasError) {
                //服务器内部正常
                if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                    
                    SNBaseListModel *listModel = [[SNBaseListModel alloc] init];
                    
                    NSArray *recvListDoctor = [[result.responseObject dictionaryForKeySafely:@"data"] arrayForKeySafely:@"doctorReleaseList"];
                    NSMutableArray *listSubjectDoctor = [[NSMutableArray alloc] init];
                    
                    [recvListDoctor enumerateObjectsUsingBlockSafety:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
                        Doctor *doctor = [[Doctor alloc] init];
                        
                        doctor.doctorId = [(NSNumber *)[obj valueForKey:@"doctorID"] integerValue];
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
                        
//                        doctor.isAvailable = YES;  //医生可以约诊， 这个是可约诊列表
//                        if([(NSNumber *)[obj valueForKey:@"state"] integerValue] == 2) doctor.isAvailable = NO;
                        
                        doctor.rate = [(NSNumber *)[obj valueForKey:@"star_grade"] doubleValue];
                        doctor.price = [(NSNumber *)[obj valueForKey:@"fee"] doubleValue];
                        doctor.availableTime = [obj valueForKey:@"releaseTime"];
                        doctor.address = [NSString stringWithFormat:@"%@(%@)",[obj valueForKey:@"clinicName"],[obj valueForKey:@"clinicAddress"]];
                        doctor.doctorState = [[obj valueForKey:@"state"] integerValue];
                        doctor.numDiag = [[obj valueForKey:@"numDiag"] integerValue];
                        
                        [listSubjectDoctor addObject:doctor];
                    }];
                    
//                    recvListDoctor = [NSMutableArray new];
                    recvListDoctor = [[result.responseObject dictionaryForKeySafely:@"data"] arrayForKeySafely:@"doctorList"];
                    
                    [recvListDoctor enumerateObjectsUsingBlockSafety:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
                        Doctor *doctor = [[Doctor alloc] init];
                        
                        doctor.doctorId = [(NSNumber *)[obj valueForKey:@"doctorID"] integerValue];
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
                        
                        
//                        doctor.isAvailable = YES;
//                        if([(NSNumber *)[obj valueForKey:@"state"] integerValue] == 2) doctor.isAvailable = NO;
//                        
                        doctor.rate = [(NSNumber *)[obj valueForKey:@"star_grade"] doubleValue];
                        doctor.price = [(NSNumber *)[obj valueForKey:@"fee"] doubleValue];
                        doctor.availableTime = [obj valueForKey:@"releaseTime"];
                        doctor.address = [NSString stringWithFormat:@"%@(%@)",[obj valueForKey:@"clinicName"],[obj valueForKey:@"clinicAddress"]];
                        doctor.briefIntro = [NSString stringWithFormat:@"%@",[obj valueForKey:@"briefIntro"]];
                        doctor.skillTreat = [obj valueForKey:@"skillTreat"];
                        doctor.doctorState = -1;
                        doctor.numDiag = [[obj valueForKey:@"numDiag"] integerValue];
                        
                        [listSubjectDoctor addObject:doctor];
                    }];
                    
                    NSArray *recvListSymptomOption = [[result.responseObject dictionaryForKeySafely:@"data"] arrayForKeySafely:@"symptomOption"];
                    NSMutableArray *listSubjectSymptomOption = [[NSMutableArray alloc] init];
                    [recvListSymptomOption enumerateObjectsUsingBlockSafety:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
                        NSString *string = [obj valueForKey:@"name"];
                        [listSubjectSymptomOption addObject:string];
                        filter.symptomOptionArray = listSubjectSymptomOption;
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
    else{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObjectSafely:kPlatForm forKey:@"from"];
        [param setObjectSafely:@"0" forKey:@"token"];
        [param setObjectSafely:@"DoctorListSelect" forKey:@"require"];
        [param setObjectSafely:@(11202) forKey:@"interfaceID"];
        [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
        
        //    NSArray *types = @[@"subject", @"symptom", @"disease"];
        
        NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
        [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
        [dataParam setObjectSafely:@(filter.typeId) forKey:@"subjectID"];
        [dataParam setObjectSafely:@(510000) forKey:@"regionID"];
        [dataParam setObjectSafely:@([kCurrentLng doubleValue]) forKey:@"longitude"];
        [dataParam setObjectSafely:@([kCurrentLat doubleValue]) forKey:@"latitude"];
        [dataParam setObjectSafely:@(filter.subTypeId) forKey:@"symptomID"];
        [dataParam setObjectSafely:(filter.orderDate == nil ? @"0":filter.orderDate) forKey:@"orderDate"];
        
        [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
        
        NSLog(@"%@",param);
        
        [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
            
            if (!result.hasError) {
                //服务器内部正常
                if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                    
                    SNBaseListModel *listModel = [[SNBaseListModel alloc] init];
                    
                    NSArray *recvListDoctor = [[result.responseObject dictionaryForKeySafely:@"data"] arrayForKeySafely:@"doctorReleaseList"];
                    NSMutableArray *listSubjectDoctor = [[NSMutableArray alloc] init];
                    
                    [recvListDoctor enumerateObjectsUsingBlockSafety:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
                        Doctor *doctor = [[Doctor alloc] init];
                        
                        doctor.doctorId = [(NSNumber *)[obj valueForKey:@"doctorID"] integerValue];
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
                        doctor.availableTime = [obj valueForKey:@"releaseTime"];
                        doctor.address = [NSString stringWithFormat:@"%@(%@)",[obj valueForKey:@"clinicName"],[obj valueForKey:@"clinicAddress"]];
                        doctor.doctorState = [[obj valueForKey:@"state"] integerValue];
                        doctor.numDiag = [[obj valueForKey:@"numDiag"] integerValue];
                        
                        [listSubjectDoctor addObject:doctor];
                    }];
                    
                    recvListDoctor = [[result.responseObject dictionaryForKeySafely:@"data"] arrayForKeySafely:@"doctorList"];
                    
                    [recvListDoctor enumerateObjectsUsingBlockSafety:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
                        Doctor *doctor = [[Doctor alloc] init];
                        
                        doctor.doctorId = [(NSNumber *)[obj valueForKey:@"doctorID"] integerValue];
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
//                        doctor.rate = [(NSNumber *)[obj valueForKey:@"star_grade"] doubleValue];
                        doctor.price = [(NSNumber *)[obj valueForKey:@"fee"] doubleValue];
                        doctor.availableTime = [obj valueForKey:@"releaseTime"];
                        doctor.address = [NSString stringWithFormat:@"%@(%@)",[obj valueForKey:@"clinicName"],[obj valueForKey:@"clinicAddress"]];
                        doctor.briefIntro = [NSString stringWithFormat:@"%@",[obj valueForKey:@"briefIntro"]];
                        doctor.skillTreat = [obj valueForKey:@"skillTreat"];
                        doctor.doctorState = -1;
                        doctor.numDiag = [[obj valueForKey:@"numDiag"] integerValue];
                        
                        [listSubjectDoctor addObject:doctor];
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
    
    
}


- (void)getSubObjectListWithResultBlock:(SNServerAPIResultBlock)resultBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"DoctorMain" forKey:@"require"];
    [param setObjectSafely:@(11201) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    //    NSArray *types = @[@"subject", @"symptom", @"disease"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:@(0) forKey:@"doctorID"];
    
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
#if !LOCAL
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase
                                   parameters:param
                     callbackRunInGlobalQueue:YES
                                       parser:nil
                                  parseMethod:nil
                                  resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
                                      
                                      if (!result.hasError) {
                                          
                                          SNBaseListModel *listModel = [[SNBaseListModel alloc] init];
                                          
                                          NSDictionary *data = [result.responseObject valueForKeySafely:@"data"];
                                          NSArray *lists = @[@"list_subject", @"list_symptom", @"list_disease"];
                                          
                                          for (int i = 0; i < 3; ++i) {
                                              NSArray *listSubject = [data valueForKeySafely:lists[i]];
                                              NSMutableArray *subList = [[NSMutableArray alloc] init];
                                              
                                              [listSubject enumerateObjectsUsingBlockSafety:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
                                                  
                                                  SubObject *subObject = [[SubObject alloc] init];
                                                  subObject.type_id = [NSString stringWithFormat:@"%@",[obj valueForKeySafely:@"data_id"]];
                                                  subObject.name = [obj valueForKeySafely:@"name"];
                                                  subObject.imageURL = [obj valueForKeySafely:@"icon"];
                                                  [subList addObject:subObject];
                                              }];
                                              
                                              [listModel.items addObjectSafely:subList];
                                          }
                                          
                                          result.parsedModelObject = listModel;
                                      }
                                      else {
                                          NSLog(@"连接服务器失败，请检查网络");
                                      }
                                      resultBlock(request, result);
                                      
                                  }];
#else
    if (resultBlock) {
        SNBaseListModel *listModel  =[[SNBaseListModel alloc] init];
        listModel.items = [self fakeSubObjectList];
        
        SNServerAPIResultData *result = [[SNServerAPIResultData alloc] init];
        result.parsedModelObject = listModel;
        
        resultBlock(nil, result);
    }
#endif
}

- (void)updateDoctorInfo:(Doctor *)doctor date:(NSInteger)date resultBlock:(SNServerAPIResultBlock)resultBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"DoctorMain" forKey:@"require"];
    [param setObjectSafely:@(11201) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:@(doctor.doctorId) forKey:@"doctorID"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                NSDictionary *doctorInfo = [result.responseObject dictionaryForKeySafely:@"data"];
                NSArray *appointmentList = [[result.responseObject dictionaryForKeySafely:@"data"] arrayForKeySafely:@"releaseList"];
                
                NSMutableArray *list = [[NSMutableArray alloc] init];
                [appointmentList enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
                    DoctorAppointmentListItem *item = [[DoctorAppointmentListItem alloc] init];
                    
                    item.clinicAddr = [obj valueForKey:@"clinicAddr"];
                    item.clinicName = [obj valueForKey:@"clinicName"];
                    item.fee = [(NSNumber *)[obj valueForKey:@"fee"] integerValue];
                    item.numOrder = [(NSNumber *)[obj valueForKey:@"numOrder"] integerValue];
                    item.numRelease = [(NSNumber *)[obj valueForKey:@"numRelease"] integerValue];
                    item.orderState = [(NSNumber *)[obj valueForKey:@"orderState"] integerValue];
                    item.releaseID = [(NSNumber *)[obj valueForKey:@"releaseID"] longLongValue];
                    item.releaseTime = [obj valueForKey:@"releaseTime"];
                    item.time = [(NSNumber *)[obj valueForKey:@"time"] integerValue];
                    
                    [list addObject:item];
                }];
                doctor.appointmentList = list;
                doctor.levelDesc = [doctorInfo valueForKey:@"title"];
                doctor.briefIntro = [NSString stringWithFormat:@"%@",[doctorInfo valueForKey:@"briefIntro"]];
                doctor.detailIntro = [doctorInfo valueForKey:@"detailIntro"];
                doctor.rate = [(NSNumber *)[doctorInfo valueForKey:@"starGrade"] doubleValue];
                doctor.name = [doctorInfo valueForKey:@"name"];
                doctor.avatar = [doctorInfo valueForKey:@"icon"];
                doctor.doctorId = [[doctorInfo valueForKey:@"doctorID"] integerValue];
                doctor.numConcern = [[doctorInfo valueForKey:@"numConcern"] integerValue];
                doctor.numDiag = [[doctorInfo valueForKey:@"numDiag"] integerValue];
                doctor.goodRemark = [[doctorInfo valueForKey:@"goodRemark"] integerValue];
                doctor.didConcern = ([[doctorInfo valueForKey:@"isConcern"] integerValue] == 1) ? YES:NO;
                
            }
            else {
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject stringForKeySafely:@"data"]];
            }
        }
        else {
            NSLog(@"连接服务器失败，请检查网络");
        }
        resultBlock(request, result);
    }];
}

- (void)getCommentListWithDoctor_id:(NSString *)doctor_id resultBlock:(SNServerAPIResultBlock)resultBlock
{
    
}

- (void)getOrderTimeSegmentWithReleaseID:(long long)releaseID resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"OrderTimeSegment" forKey:@"require"];
    [param setObjectSafely:@(11302) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:@(releaseID) forKey:@"releaseID"];
    [dataParam setObjectSafely:[SNPlatformManager deviceId] forKey:@"deviceInfo"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                NSArray *recvList = [[result.responseObject dictionaryForKeySafely:@"data"] arrayForKeySafely:@"orderTimeSegment"];
                NSMutableArray *listSubject = [[NSMutableArray alloc] init];
                
                __block BOOL mark = NO;
                [recvList enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
                    SelectOrderTime *selectOrderTime = [[SelectOrderTime alloc] init];
                    
                    selectOrderTime.house       = [obj valueForKeySafely:@"house"];
                    selectOrderTime.isOrdered   = [[obj valueForKeySafely:@"isOrdered"] integerValue];
                    selectOrderTime.orderID     = [[obj valueForKeySafely:@"orderID"] integerValue];
                    selectOrderTime.orderTime   = [obj valueForKeySafely:@"orderTime"];
                    
                    if (selectOrderTime.isOrdered == NO) {
                        mark = YES;
                    }
                    if (mark) {
                        [listSubject addObject:selectOrderTime];
                    }
                    
                }];
                result.parsedModelObject = listSubject;
                
            }
            else {
                //                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject valueForKey:@"data"]];
            }
        }
        else {
            NSLog(@"连接服务器失败，请检查网络");
            [TipHandler showTipOnlyTextWithNsstring:@"连接服务器失败，请检查网络"];
        }
        
        resultBlock(request, result);
        
    }forKey:@"get_subject_doctor_list" forPageNameGroup:pageName];
}


- (void)doctorConcernWithDoctorID:(NSInteger)doctorID isConcern:(NSInteger)isConcern resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"DoctorConcern" forKey:@"require"];
    [param setObjectSafely:@(11301) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:@(doctorID) forKey:@"doctorID"];
    [dataParam setObjectSafely:@(isConcern) forKey:@"isConcern"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
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
    
}

- (void)getMyDoctorWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"MyDoctor" forKey:@"require"];
    [param setObjectSafely:@(13101) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                SNBaseListModel *listModel = [[SNBaseListModel alloc] init];
                
                NSArray *recvListDoctor = [result.responseObject arrayForKeySafely:@"data"];
                NSMutableArray *listSubjectDoctor = [[NSMutableArray alloc] init];
                
                if ([recvListDoctor isKindOfClass:[NSArray class]]) {
                    [recvListDoctor enumerateObjectsUsingBlockSafety:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
                        Doctor *doctor = [[Doctor alloc] init];
                        
                        doctor.doctorId = [(NSNumber *)[obj valueForKey:@"doctorID"] integerValue];
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
                        
                        //                    doctor.isAvailable = YES;  //医生可以约诊， 这个是可约诊列表
                        //                    if([(NSNumber *)[obj valueForKey:@"state"] integerValue] == 2) doctor.isAvailable = NO;
                        
                        doctor.rate = [(NSNumber *)[obj valueForKey:@"star_grade"] doubleValue];
                        doctor.price = [(NSNumber *)[obj valueForKey:@"fee"] doubleValue];
                        doctor.availableTime = [obj valueForKey:@"releaseTime"];
                        doctor.address = [NSString stringWithFormat:@"%@(%@)",[obj valueForKey:@"clinicName"],[obj valueForKey:@"clinicAddress"]];
                        doctor.doctorState = -1;
                        doctor.numDiag = [[obj valueForKey:@"numDiag"] integerValue];
                        
                        [listSubjectDoctor addObject:doctor];
                    }];
                }
                
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

- (NSMutableArray *)fakeSubObjectList
{
    NSMutableArray *subobjectArray = [NSMutableArray new];
    for (int i=0; i<10; i++) {
        SubObject *subobject = [[SubObject alloc] init];
        subobject.type_id = [NSString stringWithFormat:@"%@",@(i+10)];
        subobject.name = @"内科";
        subobject.imageURL = @"http://wenwen.soso.com/p/20101003/20101003092618-1015437083.jpg";
        [subobjectArray addObject:subobject];
    }
    return subobjectArray;
}

- (NSMutableArray *)fakeDoctorList
{
    NSMutableArray *doctorArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 10; i ++) {
        Doctor *doctor = [[Doctor alloc] init];
//        doctor.doctorId = [NSString stringWithFormat:@"%@", @(i + 100)];
//        doctor.name = @"华佗";
//        doctor.avatar = @"http://www.91danji.com/attachments/201406/25/13/28lp1eh2g.jpg";
//        doctor.desc = @"华佗被后人称为“外科圣手”[5]  、“外科鼻祖”。被后人多用神医华佗称呼他，又以“华佗再世”、“元化重生”称誉有杰出医术的医师。";
//        doctor.levelDesc = @"主任医师";
//        doctor.subject = @"内科 皮肤科 慢性支气管炎 儿科 头疼";
//        doctor.availableTime = @"2015-8-18";
//        doctor.isAvailable = i % 2;
//        doctor.rate = 4.5;
//        doctor.price = 200;
//        doctor.area = @"青羊区";
//        doctor.city = @"成都";
//        doctor.address = @"华西医院";
//        doctor.background = @"华佗[1]  （约公元145年－公元208年），字元化，一名旉，沛国谯县人，东汉末年著名的医学家。华佗与董奉、张仲景并称为“建安三神医”。少时曾在外游学，行医足迹遍及安徽、河南、山东、江苏等地，钻研医术而不求仕途。他医术全面，尤其擅长外科，精于手术。并精通内、妇、儿、针灸各科。[2-4]  晚年因遭曹操怀疑，下狱被拷问致死。";
//        doctor.skilledDisease = @"疑难杂症";
//        doctor.skilledSubject = @"外科、内、妇、儿、针灸各科";
//        doctor.longitude = 104.106953;
//        doctor.latitude = 30.681503;
        
        doctor.appointmentList = [NSMutableArray new];
        for (int i = 0; i < 10; i++) {
            DoctorAppointmentListItem *item = [[DoctorAppointmentListItem alloc]init];
            
            [doctor.appointmentList addObjectSafely:item];
        }
        
        [doctorArray addObjectSafely:doctor];
    }
    
    return doctorArray;
}

- (void)getGoodRemarkDoctorListWithFilter:(DoctorFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:14202 require:@"goodRemarkDoctorList"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:@"/baseFrame/base/goodRemarkDoctorList.jmm" parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if ([errorCode integerValue] != -1) {
                
                NSMutableArray * dataList = [NSMutableArray array];
                
                NSDictionary * data = [result.responseObject dictionaryForKeySafely:@"data"];
                NSArray * tempList1 = [data arrayForKeySafely:@"goodRemarkDoctorList"];
                [tempList1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    Doctor * doctor = [[Doctor alloc] init];
                    
                    doctor.doctorId = [obj longlongForKeySafely:@"doctorID"];
                    doctor.goodRemark = [obj integerForKeySafely:@"goodRemark"];
                    doctor.skillTreat = [obj stringForKeySafely:@"goodatsubject"];
                    doctor.avatar = [obj stringForKeySafely:@"icon"];
                    doctor.name = [obj stringForKeySafely:@"name"];
                    doctor.levelDesc = [obj stringForKeySafely:@"title"];
                    
                    [dataList addObjectSafely:doctor];
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
        
    }forKey:@"goodRemarkDoctorList" forPageNameGroup:pageName];
    
}

- (void)getfamousDoctorClinicWithFilter:(DoctorFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:14202 require:@"famousDoctorClinicList"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:@(filter.rows) forKey:@"rows"];
    [dataParam setObjectSafely:@(filter.rows) forKey:@"total"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:@"/baseFrame/base/famousDoctorClinic.jmm" parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                
                NSMutableArray * dataList = [NSMutableArray array];
                
                NSDictionary * data = [result.responseObject dictionaryForKeySafely:@"data"];
                NSArray * tempList1 = [data arrayForKeySafely:@"famousDoctorClinicList"];
                [tempList1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    Doctor * doctor = [[Doctor alloc] init];
                    
                    doctor.doctorId = [obj longlongForKeySafely:@"doctorID"];
                    doctor.goodRemark = [obj integerForKeySafely:@"goodRemark"];
                    doctor.skillTreat = [obj stringForKeySafely:@"skillTreat"];
                    doctor.avatar = [obj stringForKeySafely:@"icon"];
                    doctor.name = [obj stringForKeySafely:@"name"];
                    doctor.levelDesc = [obj stringForKeySafely:@"titleDoctor"];
                    doctor.grade = [obj stringForKeySafely:@"gradeDoctor"];
                    doctor.briefIntro = [obj stringForKeySafely:@"briefIntro"];
                    
                    [dataList addObjectSafely:doctor];
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
        
    }forKey:@"famousDoctorClinic" forPageNameGroup:pageName];
    
}

@end
