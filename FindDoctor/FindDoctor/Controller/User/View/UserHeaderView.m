//
//  UserHeaderView.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/21.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "UserHeaderView.h"
#import "UIImageView+WebCache.h"
#import "CUUserManager.h"


@implementation UserHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)initSubViews{
    self.userInfoBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 75)];
    [self addSubview:self.userInfoBackgroundView];
    self.userInfoBackgroundView.backgroundColor  = [UIColor purpleColor];
    
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(28, 6, 64, 64)];
    self.icon.layer.cornerRadius = 64 / 2.f;
    self.icon.clipsToBounds = YES;
    [self.icon setImageWithURL:[NSURL URLWithString:[CUUserManager sharedInstance].user.icon] placeholderImage:[UIImage imageNamed:@"DefaultHeaderImage"]];
    [self.userInfoBackgroundView addSubview:self.icon];
    self.icon.backgroundColor = [UIColor redColor];
    
    self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 28 - 4, 16, 28, 28)];
    self.arrow.image = [UIImage imageNamed:@""];
    self.arrow.backgroundColor = [UIColor redColor];
    [self.userInfoBackgroundView addSubview:self.arrow];
    
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.maxX + 16, self.icon.frameY + 12, kScreenWidth - (self.icon.maxX + 16 + self.arrow.frameWidth + 4 + 8), 24)];

    self.name.backgroundColor = [UIColor yellowColor];
    [self.userInfoBackgroundView addSubview:self.name];
    
    self.userID = [[UILabel alloc] initWithFrame:CGRectMake(self.name.frameX, self.name.maxY + 6, self.name.frameWidth, 15)];
    self.userID.font = [UIFont systemFontOfSize:12];
    self.userID.backgroundColor = [UIColor blueColor];
    [self.userInfoBackgroundView addSubview:self.userID];
    
    self.btnBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 140, kScreenWidth, 83)];
    self.btnBackgroundView.userInteractionEnabled = YES;
    [self addSubview:self.btnBackgroundView];
    
    CGFloat padding = 2;
    CGFloat btnWidth = (kScreenWidth - padding * 4)/3;
    
    self.myDoctorBtn = [[BigButtonsInUser alloc] initWithFrame:CGRectMake(padding, 0, btnWidth, self.btnBackgroundView.frameHeight) image:[UIImage imageNamed:@""] title:@"我的医生"];
    [self.btnBackgroundView addSubview:self.myDoctorBtn];
    
    self.myClinicBtn = [[BigButtonsInUser alloc] initWithFrame:CGRectMake(self.myDoctorBtn.maxX + padding, 0, btnWidth, self.btnBackgroundView.frameHeight) image:[UIImage imageNamed:@""] title:@"我的诊所"];
    [self.btnBackgroundView addSubview:self.myClinicBtn];
    
    self.myCommentBtn = [[BigButtonsInUser alloc] initWithFrame:CGRectMake(self.myClinicBtn.maxX + padding, 0, btnWidth, self.btnBackgroundView.frameHeight) image:[UIImage imageNamed:@""] title:@"我的点评"];
    [self.btnBackgroundView addSubview:self.myCommentBtn];
}

- (void)resetUserInfo{
    [self.icon setImageWithURL:[NSURL URLWithString:[CUUserManager sharedInstance].user.icon] placeholderImage:[UIImage imageNamed:@"DefaultHeaderImage"]];
    
    
    if ([CUUserManager sharedInstance].isLogin == YES) {
        self.name.text = [[CUUserManager sharedInstance].user.name length] > 0?[CUUserManager sharedInstance].user.name:@"优医用户";
        self.userID.text = [NSString stringWithFormat:@"优医号：%ld",(long)[CUUserManager sharedInstance].user.userId];
    }else{
        self.name.text = @"未登录";
    }
}

@end
