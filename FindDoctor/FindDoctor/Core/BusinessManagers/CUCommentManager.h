//
//  CUCommentManager.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/3/14.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "SNBusinessMananger.h"
#import "SNServerAPIDefine.h"
#import "Comment.h"

@interface CUCommentManager : SNBusinessMananger

SINGLETON_DECLARE(CUCommentManager);

//11903用户空间-我的点评
- (void)getMyCommentList:(MyCommentFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//11905医生口碑接口
- (void)getDoctorFameList:(DoctorFameFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

@end
