//
//  CUClinicManager.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/2/26.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "SNBusinessMananger.h"
#import "SNServerAPIDefine.h"
#import "Doctor.h"
#import "Clinic.h"
#import "SubObject.h"
#import "CUService.h"

@interface CUClinicManager : SNBusinessMananger

SINGLETON_DECLARE(CUClinicManager);

//地图上的附近诊所
- (void)getClinicNearbyListWithFilter:(ClinicFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//诊所主页
- (void)getClinicMainWithClinic:(Clinic *)clinic resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//诊所关注
- (void)clinicConcernWithClinic:(Clinic *)clinic resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//获取我的诊所
- (void)getMyClinicWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//好评诊所
- (void)getGoodRemarkClinicListWithFilter:(ClinicFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

@end
