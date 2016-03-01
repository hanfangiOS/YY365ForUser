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

- (void)getClinicNearbyListWithFilter:(ClinicFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

- (void)getClinicMainWithClinic:(Clinic *)clinic resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

@end
