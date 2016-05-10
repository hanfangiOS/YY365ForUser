//
//  MyInfoAvatarCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#define MyInfoAvatarCellHeight 86

#import "MyInfoAvatarCell.h"

@implementation MyInfoAvatarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        return self;
    }
    return nil;
}

+ (float)cellDefaultHeight{
    return MyInfoAvatarCellHeight;
}

- (void)initSubViews{
    //整个cell的容器view，主要是为了响应点击事件，之前在selectcell时发生了bug
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, MyInfoAvatarCellHeight)];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BackgroundAction)];
    [self.containerView addGestureRecognizer:tap];
    [self addSubview:self.containerView];
    //左1
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, (MyInfoAvatarCellHeight - 20)/2, 100, 20)];
    self.label.textAlignment = NSTextAlignmentLeft;
    self.label.font = [UIFont systemFontOfSize:12];
    [self.containerView addSubview:self.label];
    //箭头
    self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 4 - 9, (MyInfoAvatarCellHeight - 15)/2, 9, 15)];
    self.arrow.image = [UIImage imageNamed:@"common_icon_grayArrow"];
    [self.containerView addSubview:self.arrow];
    //右1
    self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 4 - 9 - 60 - 12, (MyInfoAvatarCellHeight - 60)/2, 60, 60)];
    self.avatar.layer.cornerRadius = 64 / 2.f;
    self.avatar.clipsToBounds = YES;
    [self.containerView addSubview:self.avatar];
    self.avatar.backgroundColor = [UIColor yellowColor];

}

- (void)BackgroundAction{
    if (self.clickMyInfoAvatarCellBlock) {
        self.clickMyInfoAvatarCellBlock();
    }
}

@end
