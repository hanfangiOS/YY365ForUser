//
//  CommonManager.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/20.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "SNBusinessMananger.h"
#import "SNServerAPIDefine.h"
#import "SubObject.h"
#import "Banner.h"

//其他类请求引擎管理类
@interface CommonManager : SNBusinessMananger

SINGLETON_DECLARE(CommonManager);

- (void)getSubjectListWithFilter:(SubObjectFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

- (void)getActivityBannerWithFilter:(BannerFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

@end
