//
//  CUUserManager+FamilyMember.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/9.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUUserManager.h"

@interface CUUserManager (FamilyMember)

- (void)addMember:(CUUser *)member resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

- (void)deleteMember:(CUUser *)member resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

- (void)editMember:(CUUser *)member resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

@end
