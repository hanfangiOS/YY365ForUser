//
//  CUUserParser.m
//  CollegeUnion
//
//  Created by li na on 15/2/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUUserParser.h"
#import "CUServerAPIConstant.h"

@implementation CUUserParser

- (CUUser *)parseUserWithDict:(NSDictionary *)data
{
    CUUser * user = [[CUUser alloc] init];
    user.userId = [[data objectForKeySafely:@"id"] integerValue];
    user.token = [data objectForKeySafely:Key_Token];
    user.profile = [URL_ImageBase stringByAppendingPathComponent:[data objectForKeySafely:@"avatar"]];;
    user.nickName = [data objectForKeySafely:@"nickname"];
    user.points = [[data objectForKeySafely:@"points"] integerValue];
    user.cellPhone = [data objectForKeySafely:@"cellPhone"];
//    user.hiddenCellPhone = [data objectForKeySafely:@"pass_phone"];
    return user;
}

- (id)parseVerifyCodeRequirationWithDict:(NSDictionary *)dict
{
    [self parseBaseDataWithDict:dict];
    return nil;
}

- (CUUser*)parseLoginWithDict:(NSDictionary *)dict
{
    CUUser * user = nil;
    NSDictionary * data = [self parseBaseDataWithDict:dict];
    if (!self.hasError)
    {
        user= [self parseUserWithDict:data];
    }
    return user;
}
- (id)parseLogoutWithDict:(NSDictionary *)dict
{
    [self parseBaseDataWithDict:dict];
    return nil;
}

- (CUUser *)parseGetUserInfoWithDict:(NSDictionary *)dict
{
    CUUser * user = nil;
    NSDictionary * data = [self parseBaseDataWithDict:dict];
    if (!self.hasError)
    {
        user = [self parseUserWithDict:data];
    }
    return user;
}
- (CUUser *)parseUpdateUserInfoWithDict:(NSDictionary *)dict
{
    CUUser * user = nil;
    NSDictionary * data = [self parseBaseDataWithDict:dict];
    if (!self.hasError)
    {
        user = [self parseUserWithDict:data];
    }
    return user;
}

- (NSString *)parseUploadAvatarWithDict:(NSDictionary *)dict
{
    NSDictionary * data = [self parseBaseDataWithDict:dict];
    if (!self.hasError) {
        return [NSString stringWithFormat:@"%@/%@", URL_ImageBase, [data objectForKeySafely:@"url"]];
    }
    
    return nil;
}

@end
