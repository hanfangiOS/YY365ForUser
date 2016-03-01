//
//  FamilyMemberDetailController.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/8.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUViewController.h"
#import "CUUser.h"

typedef void(^FamilyMemberAction)(CUUser *user);

typedef NS_ENUM(NSInteger, FamilyMemberEditType) {
    FamilyMemberEditTypeNone   = 0,  // 查看
    FamilyMemberEditTypeAdd    = 1,  // 添加
    FamilyMemberEditTypeModify = 2   // 修改
};

@interface FamilyMemberDetailController : CUViewController
{
    UIImageView       *_avatarView;
}

@property (nonatomic, strong) CUUser *user;
@property (nonatomic, strong) CUUser *tempMember;

@property FamilyMemberEditType editType;
@property (nonatomic, copy) FamilyMemberAction addBlock;
@property (nonatomic, copy) FamilyMemberAction deleteBlock;
@property (nonatomic, copy) FamilyMemberAction editBlock;

@property BOOL isUploadingArvartar; // 正在传头像，则不更新头像

@end
