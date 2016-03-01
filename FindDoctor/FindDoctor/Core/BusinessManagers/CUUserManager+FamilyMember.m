//
//  CUUserManager+FamilyMember.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/9.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUUserManager+FamilyMember.h"

@implementation CUUserManager (FamilyMember)

- (void)addMember:(CUUser *)member resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    if (resultBlock) {
        member.userId = [@"9898" integerValue];
        
        SNServerAPIResultData *result = [[SNServerAPIResultData alloc] init];
        result.parsedModelObject = member;
        
        resultBlock(nil, result);
    }
}

- (void)deleteMember:(CUUser *)member resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    if (resultBlock) {
        SNServerAPIResultData *result = [[SNServerAPIResultData alloc] init];
        result.parsedModelObject = member;
        
        resultBlock(nil, result);
    }
}

- (void)editMember:(CUUser *)member resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    if (resultBlock) {
        SNServerAPIResultData *result = [[SNServerAPIResultData alloc] init];
        result.parsedModelObject = member;
        
        resultBlock(nil, result);
    }
}

@end
