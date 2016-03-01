//
//  UserCenterHeaderView.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/19.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "UserCenterHeaderView.h"
#import "UIImageView+WebCache.h"
#import "UILabel+Rect.h"
#import "AvatarHelper.h"

#define kHeaderViewHeight  80.0

@implementation UserCenterHeaderView
{
    UIImageView *imageView;
    UILabel     *nickLabel;
    UILabel     *levelLabel;
    UILabel     *accountLabel;
    
    UILabel     *blankLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = UIColorFromRGB(243, 251, 239);
        
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews
{
    CGFloat leftPadding = 15.0;
    CGFloat topPadding = 20.0;
    
    CGFloat imageWidth = 40.0;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftPadding, topPadding, imageWidth, imageWidth)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self addSubview:imageView];
    
    imageView.layer.cornerRadius = imageWidth / 2;
    
    CGFloat labelHeight = 15.0;
    
    CGFloat levelWidth = 70.0;
    CGRect levelRect = CGRectMake(self.frameWidth - leftPadding - levelWidth, topPadding, levelWidth, labelHeight);
    levelLabel = [[UILabel alloc] initWithFrame:levelRect];
    levelLabel.backgroundColor = [UIColor clearColor];
    levelLabel.font = [UIFont systemFontOfSize:labelHeight];
    levelLabel.textColor = kBlackColor;
    [self addSubview:levelLabel];
    
    levelLabel.frame = [UILabel textRectWithRect:levelLabel.frame withFontSize:labelHeight];
    
    CGFloat nickOriginX = CGRectGetMaxX(imageView.frame) + leftPadding;
    CGRect nickRect = CGRectMake(nickOriginX, topPadding, CGRectGetMinX(levelRect) - nickOriginX, labelHeight);
    nickLabel = [[UILabel alloc] initWithFrame:nickRect];
    nickLabel.backgroundColor = [UIColor clearColor];
    nickLabel.font = [UIFont systemFontOfSize:labelHeight];
    nickLabel.textColor = kBlackColor;
    [self addSubview:nickLabel];
    
    nickLabel.frame = [UILabel textRectWithRect:nickLabel.frame withFontSize:labelHeight];
    
    CGFloat accountOriginX = CGRectGetMaxX(imageView.frame) + leftPadding;
    CGFloat accountOriginY = CGRectGetMaxY(nickRect) + 10;
    CGRect accountRect = CGRectMake(accountOriginX, accountOriginY, self.frameWidth - leftPadding - accountOriginX, labelHeight);
    accountLabel = [[UILabel alloc] initWithFrame:accountRect];
    accountLabel.backgroundColor = [UIColor clearColor];
    accountLabel.font = [UIFont systemFontOfSize:labelHeight];
    accountLabel.textColor = kBlackColor;
    [self addSubview:accountLabel];
    
    accountLabel.frame = [UILabel textRectWithRect:accountLabel.frame withFontSize:labelHeight];
}

+ (CGFloat)defaultHeight
{
    return kHeaderViewHeight;
}

- (void)setUser:(CUUser *)user
{
    _user = user;
    
    [self reloadData];
}

- (void)reloadData
{
    if (self.user) {
        nickLabel.hidden = NO;
        levelLabel.hidden = NO;
        accountLabel.hidden = NO;
        blankLabel.hidden = YES;
        
        [imageView setImageWithURL:[NSURL URLWithString:self.user.profile] placeholderImage:[AvatarHelper defaultAvatar]];
        nickLabel.text = [NSString stringWithFormat:@"昵称：%@", self.user.nickName];
        levelLabel.text = [NSString stringWithFormat:@"等级：%@级", @(self.user.level)];
        accountLabel.text = [NSString stringWithFormat:@"账号：%@", self.user.accountNum];
    }
    else {
        nickLabel.hidden = YES;
        levelLabel.hidden = YES;
        accountLabel.hidden = YES;
        blankLabel.hidden = NO;
        
        imageView.image = [AvatarHelper defaultAvatar];
        nickLabel.text = nil;
        levelLabel.text = nil;
        accountLabel.text = nil;
    }
}

@end
