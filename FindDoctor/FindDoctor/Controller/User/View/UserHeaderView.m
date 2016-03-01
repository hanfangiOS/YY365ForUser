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

@implementation UserHeaderView{
    UIImageView *headImageView;
    UILabel *label1;
    UILabel *label2;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)initSubViews{
    headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 16, 67, 67)];
    headImageView.layer.cornerRadius = 67 / 2.f;
    headImageView.clipsToBounds = YES;
    headImageView.layer.borderColor = UIColorFromHex(0xbbdaff).CGColor;
    headImageView.layer.borderWidth = 1.5;
    [headImageView setImageWithURL:[CUUserManager sharedInstance].user.icon placeholderImage:[UIImage imageNamed:@"DefaultHeaderImage"]];
    [self addSubview:headImageView];
    
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(105, 28, self.frameWidth - 105, 14)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.textColor = UIColorFromHex(0x000000);
    label1.text = [NSString stringWithFormat:@"%@",[CUUserManager sharedInstance].user.nickName];
    [self addSubview:label1];
    
    label2 = [[UILabel alloc]initWithFrame:CGRectMake([label1 frameX], CGRectGetMaxY(label1.frame)+12, label1.frameWidth, label1.frameHeight)];
    label2.font = [UIFont systemFontOfSize:12];
    label2.textColor = UIColorFromHex(0x454545);
    label2.textAlignment = NSTextAlignmentLeft;
    label2.text = [NSString stringWithFormat:@"ID : %ld",[CUUserManager sharedInstance].user.userId];
    [self addSubview:label2];
}

- (void)resetUserInfo{
    [headImageView setImageWithURL:[CUUserManager sharedInstance].user.icon placeholderImage:[UIImage imageNamed:@"DefaultHeaderImage"]];
    label1.text = [NSString stringWithFormat:@"%@",[CUUserManager sharedInstance].user.nickName];
    label2.text = [NSString stringWithFormat:@"ID : %ld",[CUUserManager sharedInstance].user.userId];
}

@end
