//
//  CUSearchManager.h
//  FindDoctor
//
//  Created by zhuhaoran on 16/3/2.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "SNBusinessMananger.h"
#import "SNServerAPIDefine.h"
#import "Search.h"

@interface CUSearchManager : SNBusinessMananger

SINGLETON_DECLARE(CUSearchManager);

- (void)getSearchResultListWithFilter:(SearchFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//热搜诊所
- (void)gethotSearchClinicListWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//热搜病症
- (void)gethotSearchSymptomListWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//热搜医师
- (void)gethotSearchDoctorListWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

@end
