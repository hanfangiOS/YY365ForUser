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
    //上半块背景View
    UIImage *image = [UIImage imageNamed:@"mySpace_topBackground"];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.frameHeight -  kScreenWidth * image.size.height/image.size.width, kScreenWidth, kScreenWidth * image.size.height/image.size.width)];
    view.layer.contents = (id)image.CGImage;
    [self addSubview:view];
    
    self.userInfoBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 76)];
    [self addSubview:self.userInfoBackgroundView];
    //用户头像
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(28, 6, 64, 64)];
    self.icon.layer.cornerRadius = 64 / 2.f;
    self.icon.clipsToBounds = YES;
    [self.icon setImageWithURL:[NSURL URLWithString:[CUUserManager sharedInstance].user.icon] placeholderImage:[UIImage imageNamed:@"temp_userDefaultAvatar"]];
    [self.userInfoBackgroundView addSubview:self.icon];
    //箭头
    self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 9 - 16, self.icon.frameY + 10, 9, 16)];
    self.arrow.image = [UIImage imageNamed:@"mySpace_icon_arrow@2x"];
    [self.userInfoBackgroundView addSubview:self.arrow];
    //用户名
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.maxX + 20, self.icon.frameY + 10, kScreenWidth - (self.icon.maxX + 16 + self.arrow.frameWidth + 4 + 8), 24)];
    self.name.font = [UIFont systemFontOfSize:17];
    self.name.textColor = [UIColor whiteColor];
    [self.userInfoBackgroundView addSubview:self.name];
    //优医号
    self.userID = [[UILabel alloc] initWithFrame:CGRectMake(self.name.frameX, self.name.maxY + 6, self.name.frameWidth, 15)];
    self.userID.font = [UIFont systemFontOfSize:12];
    self.userID.textColor = [UIColor whiteColor];
    [self.userInfoBackgroundView addSubview:self.userID];
    //下半块背景view 放了3个btn
    self.btnBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 148, kScreenWidth, 88)];
    self.btnBackgroundView.userInteractionEnabled = YES;
    [self addSubview:self.btnBackgroundView];
    
    CGFloat padding = 2;
    CGFloat btnWidth = (kScreenWidth - padding * 4)/3;
    //我的医生
    self.myDoctorBtn = [[BigButtonsInUser alloc] initWithFrame:CGRectMake(padding, 0, btnWidth, self.btnBackgroundView.frameHeight) image:[UIImage imageNamed:@"mySpace_myDoctor@2x"] title:@"我的医生"];
    [self.btnBackgroundView addSubview:self.myDoctorBtn];
    //白线1
    UIView * lineView1 = [[UIView alloc] initWithFrame:CGRectMake(self.myDoctorBtn.maxX, self.myDoctorBtn.frameY, 2, self.myDoctorBtn.frameHeight - 22)];
    lineView1.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
    [self.btnBackgroundView addSubview:lineView1];
    //我的诊所
    self.myClinicBtn = [[BigButtonsInUser alloc] initWithFrame:CGRectMake(self.myDoctorBtn.maxX + padding, 0, btnWidth, self.btnBackgroundView.frameHeight) image:[UIImage imageNamed:@"mySpace_myClinic@2x"] title:@"我的诊所"];
    [self.btnBackgroundView addSubview:self.myClinicBtn];
    //白线2
    UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectMake(self.myClinicBtn.maxX, self.myClinicBtn.frameY, 2, self.myClinicBtn.frameHeight - 22)];
    lineView2.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
    [self.btnBackgroundView addSubview:lineView2];
    //我的点评
    self.myCommentBtn = [[BigButtonsInUser alloc] initWithFrame:CGRectMake(self.myClinicBtn.maxX + padding, 0, btnWidth, self.btnBackgroundView.frameHeight) image:[UIImage imageNamed:@"mySpace_myComment@2x"] title:@"我的点评"];
    [self.btnBackgroundView addSubview:self.myCommentBtn];
}

- (void)resetUserInfo{
    [self.icon setImageWithURL:[NSURL URLWithString:[CUUserManager sharedInstance].user.icon] placeholderImage:[UIImage imageNamed:@"temp_userDefaultAvatar"]];
    
    if ([CUUserManager sharedInstance].isLogin == YES) {
        self.name.text = [[CUUserManager sharedInstance].user.nickname length] > 0?[CUUserManager sharedInstance].user.nickname:@"优医用户";
        self.userID.text = [NSString stringWithFormat:@"优医号：%ld",(long)[CUUserManager sharedInstance].user.userId];
    }else{
        self.name.text = @"未登录";
        self.userID.text = [NSString stringWithFormat:@"优医号：%ld",(long)[CUUserManager sharedInstance].user.userId];
        self.userID.hidden = YES;
    }
}

@end
