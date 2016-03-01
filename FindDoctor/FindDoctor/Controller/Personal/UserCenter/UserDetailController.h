//
//  UserDetailController.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/19.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CUViewController.h"
#import "CUUser.h"
#import "UserDetailHeaderView.h"

@interface UserDetailController : CUViewController

@property (nonatomic, strong) CUUser *user;
@property (nonatomic, strong) CUUser *tempUser;

@property (nonatomic, strong) UserDetailHeaderView *header;

@property BOOL isUploadingArvartar; // 正在传头像，则不更新头像

@end
