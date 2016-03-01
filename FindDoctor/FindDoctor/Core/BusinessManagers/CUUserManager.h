//
//  CUUser CUUserManager.h
//  CollegeUnion
//
//  Created by li na on 15/2/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNBusinessMananger.h"
#import "SNServerAPIDefine.h"
#import "CUUser.h"

@interface CUUserManager : SNBusinessMananger

@property (nonatomic,strong) CUUser * user;

- (BOOL)isLogin;


SINGLETON_DECLARE(CUUserManager);

@end

@interface CUUserManager (Network)

// 获取手机验证码
- (void)requireVerifyCodeWithCellPhone:(NSString *)cellPhone resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//注册
- (void)registerWithCellPhone:(NSString *)cellPhone verifyCode:(NSInteger)verifyCode resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 手机号+验证码登录
- (void)loginWithCellPhone:(NSString *)cellPhone code:(NSString *)code codetoken:(NSString *)codetoken resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 手机号+密码登录
- (void)loginWithCellPhone:(NSString *)name password:(NSString *)password resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 登出
- (void)logoutWithUser:(CUUser *)user resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 获取用户信息
- (void)getUserInfo:(NSString *)token resultBlock:(SNServerAPIResultBlock)resultBlock;// pageName:(NSString *)pageName;

// 修改用户信息
- (void)updateUserInfo:(CUUser *)user resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 上传头像
- (void)uploadAvatar:(UIImage *)image resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 上传图片
- (void)uploadImageArray:(NSMutableArray *)imageArray resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName progressBlock:(SNServerAPIProgressBlock)progressBlock;

// 修改密码 旧密码+新密码
- (void)updateUser:(CUUser *)user oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 修改密码 新密码+验证码
- (void)updateUser:(CUUser *)user password:(NSString *)password verifyCode:(NSString *)code resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 直接设置密码，第一次登录设置密码
- (void)updateUser:(CUUser *)user password:(NSString *)password resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 修改/设置邮箱
- (void)updateUser:(CUUser *)user emailAddress:(NSString *)emailAddress resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//添加成员
- (void)AddDiagnosisMemberWithDiagnosisID:(long long)diagnosisID name:(NSString *)name sex:(NSInteger)sex age:(NSInteger)age phone:(long long)phone resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

@end