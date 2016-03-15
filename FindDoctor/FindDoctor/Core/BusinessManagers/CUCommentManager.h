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

- (void)getMyCommentList:(MyCommentFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

@end
