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

- (void)getDoctorSearchResultListWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize filter:(SearchFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

@end
