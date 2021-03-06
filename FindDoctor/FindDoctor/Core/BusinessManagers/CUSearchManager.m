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
                NSMutableArray * list1 = [result.responseObject valueForKeySafely:@"data"];
                NSMutableArray * searchResultList = [NSMutableArray new];
                [list1 enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * stop) {
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
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject valueForKey:@"data"]];
            }
        }
        else {
            NSLog(@"连接服务器失败，请检查网络");
            [TipHandler showTipOnlyTextWithNsstring:@"连接服务器失败，请检查网络"];
        }
        
        resultBlock(request, result);
        
    }forKey:@"get_subject_doctor_list" forPageNameGroup:pageName];
    
}


@end
