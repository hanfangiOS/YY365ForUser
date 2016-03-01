//
//  CUUserParser.h
//  CollegeUnion
//
//  Created by li na on 15/2/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUServerAPIDataBaseParser.h"
#import "CUUser.h"

@interface CUUserParser : CUServerAPIDataBaseParser

@property (nonatomic,strong) NSString * token;
@property (nonatomic,assign) NSInteger userId;

// 验证码
- (id)parseVerifyCodeRequirationWithDict:(NSDictionary *)dict;

// 登录
- (CUUser*)parseLoginWithDict:(NSDictionary *)dict;

// 登出
- (id)parseLogoutWithDict:(NSDictionary *)dict;

// 获取用户信息
- (CUUser *)parseGetUserInfoWithDict:(NSDictionary *)dict;

// 修改用户信息
- (CUUser *)parseUpdateUserInfoWithDict:(NSDictionary *)dict;

// 上传头像
- (NSString *)parseUploadAvatarWithDict:(NSDictionary *)dict;

@end
