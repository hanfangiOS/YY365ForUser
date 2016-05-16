//
//  CUOrderManager.m
//  CollegeUnion
//
//  Created by li na on 15/2/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUOrderManager.h"
#import "CUServerAPIConstant.h"
#import "CUOrderParser.h"
#import "AppCore.h"
#import "CUUserManager.h"
#import "JSONKit.h"
#import "SNPlatformManager.h"
#import "Doctor.h"
#import "NSDateFormatter+SNExtension.h"
#import "TipMessageData.h"
#import "TipHandler+HUD.h"
#import "MyAccount.h"
#import "Diagnosis.h"
#import "NSDate+SNExtension.h"

@implementation CUOrderManager

SINGLETON_IMPLENTATION(CUOrderManager);


@end

@implementation CUOrderManager (Network)

- (void)getMemberListWithDiagnosisID:(long long)diagnosisID releaseID:(long long)releaseID orderID:(NSInteger)orderID resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"SelectOrderTime" forKey:@"require"];
    [param setObjectSafely:@(11401) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
        [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];

    [dataParam setObjectSafely:@(releaseID) forKey:@"releaseID"];
    [dataParam setObjectSafely:@(diagnosisID) forKey:@"diagnosisID"];
    [dataParam setObjectSafely:@(orderID) forKey:@"orderID"];
    [dataParam setObjectSafely:[SNPlatformManager deviceId] forKey:@"deviceInfo"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                NSArray *recvList = [[result.responseObject dictionaryForKeySafely:@"data"] arrayForKeySafely:@"memberList"];
                NSMutableArray *listSubject = [[NSMutableArray alloc] init];
                
                [recvList enumerateObjectsUsingBlockSafety:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
                    CUUser *user = [[CUUser alloc] init];
                    user.userId = [[obj valueForKey:@"ID"] integerValue];
                    user.name = [obj valueForKey:@"name"];
                    user.age  = [[obj valueForKey:@"age"] integerValue];
                    NSString *str = [obj valueForKey:@"sex"];
                    if ([str isEqualToString:@"男"]) {
                        user.gender = 1;
                    }
                    user.cellPhone = [obj valueForKey:@"phone"];
                    //        user.profile = @"http://www.91danji.com/attachments/201406/25/13/28lp1eh2g.jpg";
                    [listSubject addObjectSafely:user];
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

- (void)ReturnSelectOrderTimeWithDiagnosisID:(long long)diagnosisID resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"ReturnSelectOrderTime" forKey:@"require"];
    [param setObjectSafely:@(11402) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
        [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:@(diagnosisID) forKey:@"diagnosisID"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                //                NSMutableArray *recvList = [[result.responseObject valueForKeySafely:@"data"] valueForKeySafely:@"orderTimeSegment"];
                //                NSMutableArray *listSubject = [[NSMutableArray alloc] init];
                //
                //                [recvList enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
                //                    SelectOrderTime *selectOrderTime = [[SelectOrderTime alloc] init];
                //
                //                    selectOrderTime.house       = [obj valueForKeySafely:@"house"];
                //                    selectOrderTime.isOrdered   = [[obj valueForKeySafely:@"isOrdered"] integerValue];
                //                    selectOrderTime.orderID     = [[obj valueForKeySafely:@"orderID"] integerValue];
                //                    selectOrderTime.orderTime   = [obj valueForKeySafely:@"orderTime"];
                //
                //                    [listSubject addObject:selectOrderTime];
                //                }];
                //                result.parsedModelObject = listSubject;
                
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

- (void)submitOrder:(CUOrder *)order user:(CUUser *)user resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    // param
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"SubmitDiagnosis" forKey:@"require"];
    [param setObjectSafely:@(11502) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
        [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];

    [dataParam setObjectSafely:@(order.service.patience.memberId) forKey:@"userID"];
    [dataParam setObjectSafely:order.service.patience.name forKey:@"userName"];
    [dataParam setObjectSafely:@(order.service.patience.age) forKey:@"userAge"];
    [dataParam setObjectSafely:@(order.service.patience.gender) forKey:@"userSex"];
    [dataParam setObjectSafely:@([order.service.patience.cellPhone longLongValue]) forKey:@"userPhone"];
    [dataParam setObjectSafely:@(order.diagnosisID) forKey:@"diagnosisID"];
    [dataParam setObjectSafely:order.service.disease.desc forKey:@"description"];
    NSString *str = [NSString stringWithFormat:@""];
    if (order.service.disease.imageURLArray.count) {
        str = [order.service.disease.imageURLArray componentsJoinedByString:@","];
    }
    [dataParam setObjectSafely:str forKey:@"picDisease"];
    [dataParam setObjectSafely:order.service.disease.desc forKey:@"description"];
    
    
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                CUOrder *parsedModelObject = [[CUOrder alloc] init];
                parsedModelObject = order;
                NSDictionary *dic = [result.responseObject dictionaryForKeySafely:@"data"];
                
                order.coupon = [[dic stringForKeySafely:@"couponFee"] integerValue];
                order.service.doctor.phoneNumber = [dic stringForKeySafely:@"doctorPhone"];
                order.service.doctor.name = [dic stringForKeySafely:@"doctorName"];
                order.dealPrice = [[dic valueForKey:@"payMoney"] integerValue];
                order.service.doctor.price = [dic integerForKeySafely:@"fee"];
                order.diagnosisTime = [dic valueForKey:@"orderTime"];
                order.diagnosisID = [dic longlongForKeySafely:@"diagnosisID"];
                result.parsedModelObject = parsedModelObject;
            }
            else {
                NSLog(@"%@", [result.responseObject valueForKey:@"data"]);
            }
        }
        else {
            NSLog(@"====哎哟，出错了====");
        }
        resultBlock(request, result);
        
    }forKey:@"make_order" forPageNameGroup:pageName];
}

- (void)updateOrder:(CUOrder *)order status:(OrderStatus)status user:(CUUser *)user resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    // param
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:user.token forKey:Key_Token];
    [param setObjectSafely:order.orderId forKey:@"orderId"];
    [param setObjectSafely:@(status) forKey:@"status"];
    
    CUOrderParser * parser = [[CUOrderParser alloc] init];
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseUpdateOrderWithDict:) resultBlock:resultBlock forKey:URL_AfterBase forPageNameGroup:pageName];
}

- (void)cancelOrder:(CUOrder *)order user:(CUUser *)user resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    // param
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:13105 require:@"CancelOrderDiagnosis"];
    [param setObjectSafely:[CUUserManager sharedInstance].user.token forKey:@"token"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
        [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];

    [dataParam setObjectSafely:@(order.diagnosisID) forKey:@"diagnosisID"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    CUOrderParser * parser = [[CUOrderParser alloc] init];
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseCancelOrderWithDict:) resultBlock:resultBlock forKey:URL_AfterBase forPageNameGroup:pageName];
}

- (void)getOrderListWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize user:(CUUser *)user searchedWithOrderStatus:(OrderStatus)orderStatus resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    /*
     // param
     NSMutableDictionary * param = [NSMutableDictionary dictionary];
     [param setObjectSafely:user.token forKey:Key_Token];
     [param setObjectSafely:[NSNumber numberWithInteger:pageNum] forKey:Key_PageNum];
     [param setObjectSafely:[NSNumber numberWithInteger:pageSize] forKey:Key_PageSize];
     if (orderStatus != ORDERSTATUS_NONE)
     {
     [param setObjectSafely:@(orderStatus) forKey:@"status"];
     }
     
     CUOrderParser * parser = [[CUOrderParser alloc] init];
     
     if (orderStatus == ORDERSTATUS_NONE)
     {
     [[AppCore sharedInstance].apiManager POST:URL_GetOrderListReady parameters:param callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseGetOrderListWithDict:) resultBlock:resultBlock forKey:URL_GetOrderListReady forPageNameGroup:pageName];
     }
     else
     {
     [[AppCore sharedInstance].apiManager POST:URL_GetOrderList parameters:param callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseGetOrderListWithDict:) resultBlock:resultBlock forKey:URL_GetOrderList forPageNameGroup:pageName];
     }*/
    
    if (resultBlock) {
        SNBaseListModel *listModel  =[[SNBaseListModel alloc] init];
        listModel.items = [self fakeOrderList];
        
        SNServerAPIResultData *result = [[SNServerAPIResultData alloc] init];
        result.parsedModelObject = listModel;
        
        resultBlock(nil, result);
    }
}


- (void)getMyDiagnosisRecordsWithUser:(MyDiagnosisRecordsFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    // param
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"MyDiagnosisRecords" forKey:@"require"];
    [param setObjectSafely:@(13103) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
        [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError)
        {
            // 赋值user数据
            NSInteger err_code = [[result.responseObject valueForKey:@"errorCode"]integerValue];
            switch (err_code) {
                case 0:{
                    NSArray *reciveList = [result.responseObject arrayForKeySafely:@"data"];
                    NSMutableArray *listSubject = [NSMutableArray new];
                    if ([reciveList isKindOfClass:[NSMutableArray class]]) {
                        [reciveList enumerateObjectsUsingBlockSafety:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            Doctor *doctor = [[Doctor alloc]init];
                            doctor.address = [NSString stringWithFormat:@"%@(%@)",[obj valueForKey:@"clinicName"],[obj valueForKey:@"clinicAddress"]];
                            doctor.avatar = [obj valueForKey:@"doctorIcon"];
                            doctor.name = [obj valueForKey:@"doctorName"];
                            doctor.levelDesc = [obj valueForKey:@"title"];
                            
                            Disease *disease = [[Disease alloc]init];
                            disease.desc = [NSString stringWithFormat:@"%@",[obj valueForKey:@"illnessDescription"]];
                            disease.imageURLArray = [[obj stringForKeySafely:@"illnessPic"] componentsSeparatedByString:@","];
                            
                            CUUser *patience = [[CUUser alloc]init];
                            patience.name = [obj valueForKey:@"userName"];
                            patience.age = [[obj valueForKey:@"userAge"] integerValue];
                            patience.userId = [[obj valueForKey:@"userID"] integerValue];
                            patience.cellPhone = [obj valueForKey:@"userPhone"];
                            patience.gender = [[obj valueForKey:@"userSex"] integerValue];
                            
                            Diagnosis *diagnosis = [[Diagnosis alloc]init];
                            diagnosis.diagnosisText = [NSString  stringWithFormat:@"%@",[obj valueForKey:@"diagnosisContent"]];
                            diagnosis.recipeNum = [[obj valueForKey:@"recipeNum"] integerValue];
                            diagnosis.herbPic = [obj valueForKey:@"recipePic"];
                            
                            NSMutableArray *herbArray = [NSMutableArray new];
                            NSArray *herbRecive = [obj arrayForKeySafely:@"recipeData"];
                            [herbRecive enumerateObjectsUsingBlockSafety:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                CUHerb *herb = [[CUHerb alloc]init];
                                herb.unit = [obj valueForKey:@"unit"];
                                herb.name = [obj valueForKey:@"name"];
                                herb.herbid = [obj valueForKey:@"dataID"];
                                herb.weight = [[obj valueForKey:@"num"] integerValue];
                                [herbArray addObject:herb];
                            }];
                            diagnosis.herbArray = herbArray;
                            
                            CUService *service = [[CUService alloc]init];
                            service.doctor = doctor;
                            service.disease = disease;
                            service.patience = patience;
                            service.diagnosis = diagnosis;
                            
                            CUOrder *order = [[CUOrder alloc]init];
                            order.service = service;
                            order.state = [[obj valueForKey:@"state"] integerValue];
                            order.dealPrice = [[obj valueForKey:@"fee"] integerValue];
                            order.submitTime = [[obj valueForKey:@"submitTime"] integerValue];
                            order.submitTimeString = [[NSDate dateWithTimeIntervalSince1970:order.submitTime] stringWithDateFormat:@"yyyy-MM-dd HH:mm"];
                            order.diagnosisID = [[obj valueForKey:@"diagnosisID"] longLongValue];
                            order.createTimeStamp = [[obj valueForKey:@"orderStartTime"] integerValue];
                            order.diagnosisTime = [[NSDate dateWithTimeIntervalSince1970:order.createTimeStamp] stringWithDateFormat:@"yyyy-MM-dd HH:mm"];
                            order.finishedTimeStamp = [[obj valueForKey:@"orderEndTime"] integerValue];
                            order.orderNumber = [obj valueForKey:@"orderNo"];
                            
                            [listSubject addObject:order];
                        }];
                    }
                    
                    SNBaseListModel * listModel = [[SNBaseListModel alloc]init];
                    listModel.items = listSubject;
                    result.parsedModelObject = listModel;
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
        else {
            NSLog(@"MyDiagnosisRecords端口连接服务器失败，请检查网络");
            [TipHandler showTipOnlyTextWithNsstring:@"连接服务器失败，请检查网络"];
        }
        resultBlock(request,result);
    } forKey:URL_AfterBase forPageNameGroup:pageName];
}


- (NSMutableArray *)fakeOrderList
{
    NSMutableArray *dataArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 10; i ++) {
        //        Doctor *doctor = [[Doctor alloc] init];
        //        doctor.doctorId = [NSString stringWithFormat:@"%@", @(i + 100)];
        //        doctor.name = @"华佗";
        //        doctor.avatar = @"http://www.91danji.com/attachments/201406/25/13/28lp1eh2g.jpg";
        //        doctor.desc = @"华佗被后人称为“外科圣手”[5]  、“外科鼻祖”。被后人多用神医华佗称呼他，又以“华佗再世”、“元化重生”称誉有杰出医术的医师。";
        //        doctor.levelDesc = @"主任医师";
        //        doctor.subject = @"内科 皮肤科 慢性支气管炎 儿科 头疼";
        //        doctor.availableTime = @"2015-8-18";
        //        doctor.isAvailable = i % 2;
        //        doctor.rate = 4.5;
        //        doctor.area = @"青羊区";
        //        doctor.city = @"成都";
        //        doctor.address = @"华西医院";
        //        doctor.price = 200;
        //        doctor.background = @"华佗[1]  （约公元145年－公元208年），字元化，一名旉，沛国谯县人，东汉末年著名的医学家。华佗与董奉、张仲景并称为“建安三神医”。少时曾在外游学，行医足迹遍及安徽、河南、山东、江苏等地，钻研医术而不求仕途。他医术全面，尤其擅长外科，精于手术。并精通内、妇、儿、针灸各科。[2-4]  晚年因遭曹操怀疑，下狱被拷问致死。";
        //        doctor.skilledDisease = @"疑难杂症";
        //        doctor.skilledSubject = @"外科、内、妇、儿、针灸各科";
        
        CUOrder *order = [[CUOrder alloc] init];
        order.orderId = @"u90989087";
        order.orderNumber = @"888888";
        order.orderStatus = i % 3 + 1;
        
        //        order.service.doctor = doctor;
        order.service.serviceTime = @"2015-9-1";
        
        order.service.patience = [[CUUser alloc] init];
        order.service.patience.name = @"李四";
        order.service.patience.age = 26;
        order.service.patience.gender = CUUserGenderMale;
        order.service.patience.cellPhone = @"8789809";
        
        [dataArray addObjectSafely:order];
    }
    
    return dataArray;
}

//- (void)getOrderDetailWithOrderId:(NSString *)orderId user:(CUUser *)user resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
//{
//    // param
//    NSMutableDictionary * param = [NSMutableDictionary dictionary];
//    [param setObjectSafely:user.token forKey:Key_Token];
//    [param setObjectSafely:orderId forKey:@"orderId"];
//
//    CUOrderParser * parser = [[CUOrderParser alloc] init];
//
//    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseGetOrderDetailWithDict:) resultBlock:resultBlock forKey:URL_AfterBase forPageNameGroup:pageName];
//
//}




//首页推送
- (void)getHomeTipListWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
#if !LOCAL
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"UserAppMainPush" forKey:@"require"];
    [param setObjectSafely:@(10001) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    
    NSLog(@"%ld",(long)[CUUserManager sharedInstance].user.userId);
    
    [dataParam setObjectSafely:@([CUUserManager sharedInstance].user.userId) forKey:@"accID"];
    [dataParam setObjectSafely:@(510100) forKey:@"regionID"];
    [dataParam setObjectSafely:kCurrentLng == nil ? @(30.679694) : kCurrentLng forKey:@"longitude"];
    [dataParam setObjectSafely:kCurrentLat == nil ? @(104.145051) : kCurrentLat forKey:@"latitude"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        if (!result.hasError){
            NSInteger err_code = [[result.responseObject valueForKeySafely:@"errorCode"] integerValue];
            if (err_code == 0) {
                 NSMutableArray *resultArray = [NSMutableArray new];
                
                NSArray *dataArray3 = [[result.responseObject dictionaryForKeySafely:@"data"] arrayForKeySafely:@"msgPaper"];
                for (int i = 0; i < dataArray3.count; i++) {
                    NSMutableDictionary *dic = [dataArray3 objectAtIndex:i];
                    TipMessageData *data = [[TipMessageData alloc]init];
                    data.title = [dic valueForKeySafely:@"title"];

                    [resultArray addObjectSafely:data];
                }
                
                result.parsedModelObject = resultArray;
            }
        }
        resultBlock(nil, result);
    } forKey:@"HomeTipList" forPageNameGroup:pageName];
#else
    SNServerAPIResultData *result = [[SNServerAPIResultData alloc]init];
    result.hasError = NO;
    NSMutableArray *resultArray = [NSMutableArray new];
    for (int i = 0; i < 3; i++) {
        TipMessageData *data = [[TipMessageData alloc]init];
        data.title = @"测试首页信息推送消息";
        [resultArray addObjectSafely:data];
    }
    result.parsedModelObject = resultArray;
    resultBlock(nil,result);
    
#endif
    
}

- (void)getMyAccountWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:[CUUserManager sharedInstance].user.token forKey:@"token"];
    [param setObjectSafely:@"MyConsumeRecord" forKey:@"require"];
    [param setObjectSafely:@(23004) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:@([CUUserManager sharedInstance].user.userId) forKey:@"accID"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
#if !LOCAL
        if (!result.hasError){
            NSInteger err_code = [[result.responseObject valueForKeySafely:@"errorCode"] integerValue];
            if (err_code == 0) {
                NSDictionary  *dic = [result.responseObject dictionaryForKeySafely:@"data"];
                if([dic isKindOfClass:[NSDictionary class]]){
                    NSMutableArray *dataArray1 = [NSMutableArray new];
                    id obj = [dic objectForKey:@"moneyRecords"];
                    if (obj){
                        dataArray1 = [dic objectForKey:@"moneyRecords"];
                    }
                    MyAccount *myAccount = [[MyAccount alloc]init];
                    myAccount.totalCost = [[[result.responseObject dictionaryForKeySafely:@"data"] valueForKeySafely:@"moneyTotal"] doubleValue]/100.f;
                    myAccount.totalIncome = [[[result.responseObject dictionaryForKeySafely:@"data"] valueForKeySafely:@"couponTotal"] doubleValue]/100.f;
                    myAccount.costDetailList = [NSMutableArray new];
                    myAccount.incomeDetailList = [NSMutableArray new];
                    for (int i = 0; i < dataArray1.count; i ++) {
                        CostDetail *item = [[CostDetail alloc]init];
                        item.timeStamp = [[[dataArray1 objectAtIndex:i] valueForKeySafely:@"time"] longLongValue];
                        item.massage = [[dataArray1 objectAtIndex:i] valueForKeySafely:@"information"];
                        item.fee = [[[dataArray1 objectAtIndex:i] valueForKeySafely:@"fee"] integerValue]/100.f;
                        [myAccount.costDetailList addObject:item];
                    }
                    result.parsedModelObject = myAccount;
                }
            }
        }
        else {
            NSLog(@"连接服务器失败，请检查网络");
            [TipHandler showTipOnlyTextWithNsstring:@"连接服务器失败，请检查网络"];
        }
#else
        MyAccount *myAccount = [[MyAccount alloc]init];
        myAccount.totalCost = 1255.3;
        myAccount.totalIncome = 2325;
        myAccount.costDetailList = [NSMutableArray new];
        myAccount.incomeDetailList = [NSMutableArray new];
        for (int i = 0; i < 20; i ++) {
            CostDetail *item = [[CostDetail alloc]init];
            item.timeStamp = 1450855230;
            item.massage = @"下单约诊张仲景医生，支付定金";
            item.fee = 200;
            [myAccount.costDetailList addObject:item];
        }
        for (int i = 0; i < 20; i ++) {
            IncomeDetail *item = [[IncomeDetail alloc]init];
            item.timeStamp = 1450855230;
            item.massage = @"用户余智伟在电子科技大学校医院支付定金";
            item.fee = 200;
            [myAccount.incomeDetailList addObject:item];
        }
        result.parsedModelObject = myAccount;
#endif
        resultBlock(nil, result);
    } forKey:@"HomeTipList" forPageNameGroup:pageName];
}


- (void)CancelOrderWithDiagnosisID:(long long)diagnosisID resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"CancelOrderDiagnosis" forKey:@"require"];
    [param setObjectSafely:@(13105) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionary];
        [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];
    [dataParam setObjectSafely:@(diagnosisID) forKey:@"diagnosisID"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
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

- (void)CheckOrderHasPaidWithDiagnosisID:(long long)diagnosisID resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    //    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:@"OrderHashPaid" forKey:@"require"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary new];
    [dataParam setObjectSafely:@(diagnosisID) forKey:@"order_no"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    
    //    SNServerAPIManager *apiMr = [[SNServerAPIManager alloc] initWithServer:@"http://192.168.1.101:8889"];
    //    [apiMr POST:KCheckOrderHasPaidUrl parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
    //    [[AppCore sharedInstance].apiManager POST:KCheckOrderHasPaidUrl parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
    //        if (!result.hasError) {
    //            if ([(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue] == 0) {
    //
    //            }
    //            else {
    //                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject stringForKeySafely:@"data"]];
    //            }
    //        }
    //        else {
    //            [TipHandler showTipOnlyTextWithNsstring:@"连接服务器失败，请检查网络"];
    //        }
    //
    //        resultBlock(request, result);
    //
    //    }forKey:@"get_subject_doctor_list" forPageNameGroup:pageName];
    
}


- (void)getOrderStateWithDiagnosisID:(long long)diagnosisID andChargeid:(NSString *)chargeid andDynamicno:(long long)dynamicno resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObjectSafely:@(diagnosisID) forKey:@"order_no"];
    [param setObjectSafely:chargeid forKey:@"chargeid"];
    [param setObjectSafely:@(dynamicno) forKey:@"dynamicno"];
    NSLog(@"%@",param);
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/verify_order_state.jmm"] parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                NSDictionary *obj = [result.responseObject dictionaryForKeySafely:@"data"];
                Doctor *doctor = [[Doctor alloc]init];
                doctor.address = [NSString stringWithFormat:@"%@(%@)",[obj valueForKey:@"clinicName"],[obj valueForKey:@"clincAddr"]];
                doctor.avatar = [obj valueForKey:@"icon"];//
                doctor.name = [obj valueForKey:@"doctorName"];
                doctor.levelDesc = [obj valueForKey:@"doctorTitle"];
                doctor.price = [[obj valueForKey:@"payMoney"] integerValue];
                
                Disease * disease = [[Disease alloc]init];
                disease.desc = [NSString stringWithFormat:@"%@",[obj valueForKey:@"illnessDescription"]];
                disease.imageURLArray = [[obj valueForKey:@"illnessPic"] componentsSeparatedByString:@","];
                
                CUUser *patience = [[CUUser alloc]init];
                patience.name = [obj valueForKey:@"userName"];
                patience.age = [[obj valueForKey:@"userAge"] integerValue];
                patience.cellPhone = [obj valueForKey:@"userPhone"];
                
                if ([[obj stringForKeySafely:@"userSex"] isEqualToString:@"男"]) {
                    patience.gender = CUUserGenderMale;
                }
                
                CUService *service = [[CUService alloc]init];
                service.doctor = doctor;
                service.disease = disease;
                service.patience = patience;
                
                CUOrder *order = [[CUOrder alloc]init];
                order.service = service;
                order.orderStatus = [[obj valueForKey:@"state"] integerValue];
                order.dealPrice = [[obj valueForKey:@"currency"] integerValue];//
                order.coupon = [[obj valueForKeySafely:@"payCouponMoney"] integerValue];
                order.submitTime = [[obj valueForKey:@"orderSumitTime"] integerValue];
                order.submitTimeString = [[NSDate dateWithTimeIntervalSince1970:order.submitTime] stringWithDateFormat:@"yyyy-MM-dd HH:mm"];
                order.diagnosisID = [[obj valueForKey:@"diagnosisID"] longLongValue];
                order.diagnosisTime = [obj valueForKey:@"diagnosisTime"];
                order.orderNumber = [obj valueForKey:@"orderID"];
                order.obtainScore = [[obj valueForKey:@"obtainCouponID"] integerValue];
                order.obtainCouponMoney = [[obj valueForKey:@"obtainCouponMoney"] integerValue];
                
                result.parsedModelObject = order;
                
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

//没付款记录
- (void)getOrderNotPayListWithFilter:(OrderFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:0 require:@"orderNotPayListtrack"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];

    [dataParam setObjectSafely:@(filter.rows) forKey:@"rows"];
    [dataParam setObjectSafely:@(filter.total) forKey:@"total"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                
                NSMutableArray * dataList = [NSMutableArray array];
                
                NSDictionary * data = [result.responseObject dictionaryForKeySafely:@"data"];
                NSArray * tempList1 = [data arrayForKeySafely:@"orderList"];
                [tempList1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    CUOrder * order = [[CUOrder alloc] init];

                    order.diagnosisID = [obj longlongForKeySafely:@"orderno"];
                    
                    order.dealPrice = [obj longlongForKeySafely:@"currency"];
                    order.submitTimeString = [obj stringForKeySafely:@"verid"];
                    order.lefttime = [obj stringForKeySafely:@"lefttime"];
                    
                    order.service.patience.userId = (NSInteger)[obj longlongForKeySafely:@"accID"];
                    order.service.patience.name = [obj stringForKeySafely:@"userName"];
                    
                    order.service.doctor.name = [obj stringForKeySafely:@"doctorName"];
                    order.service.doctor.levelDesc = [obj stringForKeySafely:@"title"];
                    order.service.doctor.grade = [obj stringForKeySafely:@"gradeas"];
                    order.service.doctor.price = [obj integerForKeySafely:@"amount"];
                    order.service.doctor.avatar = [obj stringForKeySafely:@"icon"];

                    order.service.doctor.diagnosisTime = [[obj stringForKeySafely:@"ordertime"] integerValue];
                    order.service.doctor.address = [obj stringForKeySafely:@"address"];
                    [dataList addObjectSafely:order];
                }];
    
                
                SNBaseListModel * listModel = [[SNBaseListModel alloc] init];
                listModel.items = dataList;
                result.parsedModelObject = listModel;
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
        
    }forKey:@"orderNotPayList" forPageNameGroup:pageName];
    
}

//付款没看病记录
- (void)getOrderHasPayNotMeetListWithFilter:(OrderFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:0 require:@"orderHasPayNotMeetList"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
        [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];

    [dataParam setObjectSafely:@(filter.rows) forKey:@"rows"];
    [dataParam setObjectSafely:@(filter.total) forKey:@"total"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                
                NSMutableArray * dataList = [NSMutableArray array];
                
                NSDictionary * data = [result.responseObject dictionaryForKeySafely:@"data"];
                NSArray * tempList1 = [data arrayForKeySafely:@"orderList"];
                [tempList1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    CUOrder * order = [[CUOrder alloc] init];
                    order.service.patience.userId = (NSInteger)[obj longlongForKeySafely:@"accID"];
                    order.diagnosisID = [obj longlongForKeySafely:@"orderno"];
                    order.dealPrice = [obj longlongForKeySafely:@"amount"];
                    order.service.doctor.name = [obj stringForKeySafely:@"doctorName"];
                    order.service.doctor.levelDesc = [obj stringForKeySafely:@"title"];
                    order.service.doctor.grade = [obj stringForKeySafely:@"gradeas"];
                    order.submitTimeString = [obj stringForKeySafely:@"verid"];
                    order.service.doctor.avatar = [obj stringForKeySafely:@"icon"];
                    order.service.patience.name = [obj stringForKeySafely:@"userName"];
                    order.service.doctor.diagnosisTime = [[obj stringForKeySafely:@"ordertime"] integerValue];
                    order.service.doctor.address = [obj stringForKeySafely:@"address"];
                    [dataList addObjectSafely:order];
                }];
                SNBaseListModel * listModel = [[SNBaseListModel alloc] init];
                listModel.items = dataList;
                result.parsedModelObject = listModel;
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
        
    }forKey:@"orderHasPayNotMeetList" forPageNameGroup:pageName];
    
}

//看病了的记录
- (void)getOrderHasPayHasMeetListWithFilter:(OrderFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:0 require:@"orderHasPayHasMeetList"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
        [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];

    [dataParam setObjectSafely:@(filter.rows) forKey:@"rows"];
    [dataParam setObjectSafely:@(filter.total) forKey:@"total"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                
                NSMutableArray * dataList = [NSMutableArray array];
                
                NSDictionary * data = [result.responseObject dictionaryForKeySafely:@"data"];
                NSArray * tempList1 = [data arrayForKeySafely:@"orderList"];
                [tempList1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    CUOrder * order = [[CUOrder alloc] init];
                    order.service.patience.userId = (NSInteger)[obj longlongForKeySafely:@"accID"];
                    order.diagnosisID = [obj longlongForKeySafely:@"orderno"];
                    order.service.doctor.price = [obj integerForKeySafely:@"amount"];
                    order.service.doctor.name = [obj stringForKeySafely:@"doctorName"];
                    order.service.doctor.levelDesc = [obj stringForKeySafely:@"title"];
                    order.service.doctor.grade = [obj stringForKeySafely:@"gradeas"];
                    order.submitTimeString = [obj stringForKeySafely:@"verid"];
                    order.service.doctor.avatar = [obj stringForKeySafely:@"icon"];
                    order.service.patience.name = [obj stringForKeySafely:@"userName"];
                    order.service.doctor.diagnosisTime = [[obj stringForKeySafely:@"ordertime"] integerValue];
                    order.service.doctor.address = [obj stringForKeySafely:@"address"];
                    
                    NSInteger remarked = [[obj objectForKeySafely:@"remarked"] integerValue];
                    if (remarked == 1) {
                        order.orderStatus = ORDERSTATUS_COMMENT;
                    }else{
                        order.orderStatus = ORDERSTATUS_FINISHED;
                    }
                    [dataList addObjectSafely:order];
                }];
                SNBaseListModel * listModel = [[SNBaseListModel alloc] init];
                listModel.items = dataList;
                result.parsedModelObject = listModel;
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
        
    }forKey:@"orderHasPayNotMeetList" forPageNameGroup:pageName];}

//没付钱订单详情
- (void)getOrderNotPayDetailWithFilter:(OrderFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:0 require:@"orderNotPayDetail"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
        [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];

    [dataParam setObjectSafely:@(filter.diagnosisID) forKey:@"orderNo"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                
                NSDictionary * data = [result.responseObject dictionaryForKeySafely:@"data"];
                NSDictionary * orderDict = [data objectForKeySafely:@"order"];
                
                CUOrder * order = [[CUOrder alloc] init];
                order.service.patience.userId = (NSInteger)[orderDict longlongForKeySafely:@"accID"];
                order.diagnosisID = [orderDict longlongForKeySafely:@"orderno"];
                order.dealPrice = [orderDict longlongForKeySafely:@"currency"];
                order.service.doctor.price = [orderDict integerForKeySafely:@"amount"];
                order.service.doctor.name = [orderDict stringForKeySafely:@"doctorName"];
                order.service.doctor.levelDesc = [orderDict stringForKeySafely:@"title"];
                order.service.doctor.grade = [orderDict stringForKeySafely:@"gradeas"];
                order.service.doctor.clinicName = [orderDict stringForKeySafely:@"clinicName"];
                order.service.doctor.skillTreat = [orderDict stringForKeySafely:@"skilltreat"];
                order.submitTimeString = [orderDict stringForKeySafely:@"verid"];
                order.service.doctor.avatar = [orderDict stringForKeySafely:@"icon"];
                order.service.patience.name = [orderDict stringForKeySafely:@"userName"];
                order.service.doctor.diagnosisTime = [[orderDict stringForKeySafely:@"ordertime"] integerValue];
                order.service.doctor.address = [orderDict stringForKeySafely:@"address"];
                order.service.patience.age = [[orderDict valueForKeySafely:@"userAge"] integerValue];
                order.service.patience.cellPhone = [orderDict stringForKeySafely:@"userPhone"];
                order.service.doctor.price = [orderDict integerForKeySafely:@"amount"];
                order.dealPrice = [orderDict integerForKeySafely:@"currency"];
                order.coupon = [orderDict integerForKeySafely:@"coupon"];
                NSString * str = [orderDict stringForKeySafely:@"channel"];
                if ([str isEqualToString:@"wx"]) {
                    order.payment = ORDERPAYMENT_WeiXin;
                }
                if ([str isEqualToString:@"alipay"]) {
                    order.payment = ORDERPAYMENT_ZhiFuBao;
                }
                result.parsedModelObject = order;
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
        
    }forKey:@"orderNotPayDetail" forPageNameGroup:pageName];
    
}

//付钱还没看病订单详情
- (void)getOrderHasPayNotMeetDetailWithFilter:(OrderFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:0 require:@"orderHasPayHasMeetDetail"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
        [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];

    [dataParam setObjectSafely:@(filter.diagnosisID) forKey:@"orderNo"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                
                NSDictionary * data = [result.responseObject dictionaryForKeySafely:@"data"];
                
                NSDictionary * orderDict = [data objectForKeySafely:@"order"];
                
                CUOrder * order = [[CUOrder alloc] init];
                order.service.patience.userId = (NSInteger)[data longlongForKeySafely:@"accID"];
                order.diagnosisID = [orderDict longlongForKeySafely:@"orderno"];
                order.dealPrice = [orderDict longlongForKeySafely:@"amount"];
                order.service.doctor.name = [orderDict stringForKeySafely:@"doctorName"];
                order.service.doctor.levelDesc = [orderDict stringForKeySafely:@"title"];
                order.service.doctor.grade = [orderDict stringForKeySafely:@"gradeas"];
                order.service.doctor.skillTreat = [orderDict stringForKeySafely:@"skilltreat"];
                order.submitTimeString = [orderDict stringForKeySafely:@"verid"];
                order.service.doctor.avatar = [orderDict stringForKeySafely:@"icon"];
                order.service.patience.name = [orderDict stringForKeySafely:@"userName"];
                order.service.doctor.diagnosisTime = [[orderDict stringForKeySafely:@"ordertime"] integerValue];
                order.service.doctor.clinicName = [orderDict stringForKeySafely:@"clinicName"];
                order.service.doctor.address = [orderDict stringForKeySafely:@"address"];
                order.service.patience.age = [orderDict integerForKeySafely:@"userAge"];
                order.service.patience.cellPhone = [orderDict stringForKeySafely:@"userPhone"];
                order.service.doctor.price = [orderDict integerForKeySafely:@"amount"];
                order.dealPrice = [orderDict integerForKeySafely:@"currency"];
                order.coupon = [orderDict integerForKeySafely:@"coupon"];
                NSString * str = [orderDict stringForKeySafely:@"channel"];
                if ([str isEqualToString:@"wx"]) {
                    order.payment = ORDERPAYMENT_WeiXin;
                }
                if ([str isEqualToString:@"alipay"]) {
                    order.payment = ORDERPAYMENT_ZhiFuBao;
                }
                result.parsedModelObject = order;
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
        
    }forKey:@"orderHasPayNotMeetDetail" forPageNameGroup:pageName];
    
}

//付钱看病了订单详情
- (void)getOrderHasPayHasMeetDetailWithFilter:(OrderFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    
    NSMutableDictionary * param = [HFRequestHeaderDict initWithInterfaceID:0 require:@"orderHasPayHasMeetDetail"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
        [dataParam setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? @([CUUserManager sharedInstance].user.userId) : @(0) ) forKey:@"accID"];

    [dataParam setObjectSafely:@(filter.diagnosisID) forKey:@"orderNo"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:[NSString stringWithFormat:@"/baseFrame/base/%@.jmm",[param stringForKeySafely:@"require"]] parameters:param callbackRunInGlobalQueue:NO parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                
                NSDictionary * data = [result.responseObject dictionaryForKeySafely:@"data"];
                
                NSDictionary * orderDict = [data objectForKeySafely:@"order"];
                CUOrder * order = [[CUOrder alloc] init];
                order.service.patience.userId = (NSInteger)[orderDict longlongForKeySafely:@"accID"];
                order.service.doctor.clinicName = [orderDict stringForKeySafely:@"clinicName"];
                order.diagnosisID = [orderDict longlongForKeySafely:@"orderno"];
                order.dealPrice = [orderDict longlongForKeySafely:@"amount"];
                order.service.doctor.name = [orderDict stringForKeySafely:@"doctorName"];
                order.service.doctor.levelDesc = [orderDict stringForKeySafely:@"title"];
                order.service.doctor.grade = [orderDict stringForKeySafely:@"gradeas"];
                order.service.doctor.skillTreat = [orderDict stringForKeySafely:@"skilltreat"];
                order.submitTimeString = [orderDict stringForKeySafely:@"verid"];
                order.service.doctor.avatar = [orderDict stringForKeySafely:@"icon"];
                order.service.patience.name = [orderDict stringForKeySafely:@"userName"];
                order.service.doctor.diagnosisTime = [[orderDict stringForKeySafely:@"ordertime"] integerValue];
                order.finishedTimeStamp = [[orderDict stringForKeySafely:@"endtime"] integerValue];
                order.submitTimeStr = [orderDict stringForKeySafely:@"starttime"];
                order.service.doctor.address = [orderDict stringForKeySafely:@"address"];
                order.service.patience.age = [orderDict integerForKeySafely:@"userAge"];
                order.service.patience.cellPhone = [orderDict stringForKeySafely:@"userPhone"];
                order.service.doctor.price = [orderDict integerForKeySafely:@"amount"];
                order.dealPrice = [orderDict integerForKeySafely:@"currency"];
                order.coupon = [orderDict integerForKeySafely:@"coupon"];
                NSString * str = [orderDict stringForKeySafely:@"channel"];
                if ([str isEqualToString:@"wx"]) {
                    order.payment = ORDERPAYMENT_WeiXin;
                }
                if ([str isEqualToString:@"alipay"]) {
                    order.payment = ORDERPAYMENT_ZhiFuBao;
                }
                result.parsedModelObject = order;
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
        
    }forKey:@"orderHasPayHasMeetDetail" forPageNameGroup:pageName];
    
}


@end