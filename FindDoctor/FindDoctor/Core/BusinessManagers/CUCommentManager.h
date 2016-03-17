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
//11901点评按钮接口
- (void)getDiagnosisComment:(DiagnosisCommentFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//11902用户提交点评
- (void)getCommitComment:(CommitCommentFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//11903用户空间-我的点评
- (void)getMyCommentList:(MyCommentFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//11905医生口碑接口
- (void)getDoctorFameList:(DoctorFameFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

@end
