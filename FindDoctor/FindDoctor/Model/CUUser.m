//
//  CUUser.m
//  CollegeUnion
//
//  Created by li na on 15/2/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUUser.h"

#define Key_CUUser_Token @"token"
#define Key_CUUser_UserId @"userId"
#define Key_CUUser_profile @"profile"
#define Key_CUUser_nickName @"nickName"
#define Key_CUUser_points @"points"
#define Key_CUUser_cellPhone @"cellPhone"
#define Key_CUUser_hiddenCellPhone @"hiddenCellPhone"
#define Key_CUUser_AccountNum @"AccountNum"
#define Key_CUUser_Email @"User_Email"
#define Key_CUUser_Age @"User_Age"
#define Key_CUUser_Gender @"User_Gender"
#define Key_CUUser_Level @"User_Level"
#define Key_CUUser_Name @"User_Name"

@implementation CUUser

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.token forKey:Key_CUUser_Token];
    [aCoder encodeInteger:self.userId forKey:Key_CUUser_UserId];
    [aCoder encodeObject:self.profile forKey:Key_CUUser_profile];
    [aCoder encodeObject:self.nickname forKey:Key_CUUser_nickName];
    [aCoder encodeObject:self.name forKey:Key_CUUser_Name];
    [aCoder encodeObject:self.cellPhone forKey:Key_CUUser_cellPhone];

    [aCoder encodeInteger:self.points forKey:Key_CUUser_points];
    [aCoder encodeInteger:self.age forKey:Key_CUUser_Age];
    [aCoder encodeInteger:self.gender forKey:Key_CUUser_Gender];
    [aCoder encodeInteger:self.level forKey:Key_CUUser_Level];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        self.token = [aDecoder decodeObjectForKey:Key_CUUser_Token];
        self.userId = [aDecoder decodeIntegerForKey:Key_CUUser_UserId];
        self.profile = [aDecoder decodeObjectForKey:Key_CUUser_profile];
        self.nickname = [aDecoder decodeObjectForKey:Key_CUUser_nickName];
        self.name = [aDecoder decodeObjectForKey:Key_CUUser_Name];
        self.points = [aDecoder decodeIntegerForKey:Key_CUUser_points];
        self.cellPhone = [aDecoder decodeObjectForKey:Key_CUUser_cellPhone];
        self.age = [aDecoder decodeIntegerForKey:Key_CUUser_Age];
        self.gender = [aDecoder decodeIntegerForKey:Key_CUUser_Gender];
        self.level = [aDecoder decodeIntegerForKey:Key_CUUser_Level];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"userId=%d,token=%@,ponint=%d,profile=%@,nickName=%@,,cellPhone=%@",self.userId,self.token,self.points,self.profile,self.nickname,self.cellPhone];
}

- (BOOL)isEqual:(CUUser *)object
{
    if ([object isKindOfClass:[CUUser class]] && object.userId == self.userId) {
        return YES;
    }
    
    return NO;
}

- (NSUInteger)hash
{
    return self.userId;
}

- (NSString *)genderDesc
{
    if (self.gender == CUUserGenderMale) {
        return @"男";
    }
    else if (self.gender == CUUserGenderFemale) {
        return @"女";
    }
    
    return nil;
}

@end

@implementation UserFilter

@end
