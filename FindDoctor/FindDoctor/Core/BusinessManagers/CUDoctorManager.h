//
//  CUDoctorManager.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/13.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "SNBusinessMananger.h"
#import "SNServerAPIDefine.h"
#import "Doctor.h"
#import "Clinic.h"
#import "SubObject.h"
#import "CUService.h"

@interface CUDoctorManager : SNBusinessMananger

SINGLETON_DECLARE(CUDoctorManager);

- (void)getDoctorListWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize filter:(DoctorFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

- (void)getSubObjectListWithResultBlock:(SNServerAPIResultBlock)resultBlock;

- (void)updateDoctorInfo:(Doctor *)doctor date:(NSInteger)date resultBlock:(SNServerAPIResultBlock)resultBlock;

- (void)getCommentListWithDoctor_id:(NSString *)doctor_id resultBlock:(SNServerAPIResultBlock)resultBlock;

- (void)getOrderTimeSegmentWithReleaseID:(long long)releaseID resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

- (void)getMyDoctorWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//关注医生
- (void)doctorConcernWithDoctorID:(NSInteger)doctorID isConcern:(NSInteger)isConcern resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//好评医生
- (void)getGoodRemarkDoctorListWithFilter:(DoctorFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//优医馆
- (void)getFamousDoctorClinicWithFilter:(DoctorFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//#warning 测试数据
- (NSMutableArray *)fakeDoctorList;

@end
