//
//  CUUser.h
//  CollegeUnion
//
//  Created by li na on 15/2/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//
// 注：也能当做是FamilyMember来使用

#import <Foundation/Foundation.h>
#import "HFFilter.h"

typedef NS_ENUM(NSInteger, CUUserGender) {
    CUUserGenderFemale = 0, // 女
    CUUserGenderMale   = 1, // 男
};

@interface CUUser : NSObject<NSCoding>

@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSString *codetoken;
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *profile;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *cellPhone;
@property (nonatomic,strong) NSString *icon;


@property (nonatomic,copy) NSMutableArray *favoriteDoctorList;
@property (nonatomic,copy) NSMutableArray *expressAddressList;
@property (nonatomic,copy) NSMutableArray *orderDiagnosis;

@property NSInteger points;  // 积分
@property CUUserGender gender;
@property NSInteger age;
@property NSInteger level;
@property NSInteger memberId;  // 成员ID

- (NSString *)genderDesc;

@end

@interface UserFilter : HFFilter

@property (nonatomic,strong) NSString * listType;//member-仅成员；all-包含我自己
@property (nonatomic,assign) NSInteger  pageSrc;//0-约诊界面添加，1-成员列表添加
@property (nonatomic,strong) CUUser   * user;

@end
