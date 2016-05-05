//
//  UserDetailHeaderView.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/19.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "UserDetailHeaderView.h"
#import "UIImageView+WebCache.h"
#import "UILabel+Rect.h"
#import "AvatarHelper.h"

#define kHeaderViewHeight  180.0

#define kTextTitleColor kDarkGrayColor
#define kTextColor      kBlackColor
#define kTextGrayColor  UIColorFromHex(0xc6c6c6)

#define kLineColor      UIColorFromRGB(200,200,200)

#define kTextFont       [UIFont systemFontOfSize:14]

@implementation UserDetailHeaderView
{
    UIImageView *imageView;
    UILabel     *nameLabel;
    UILabel     *pointsLabel;
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
    
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarPress)];
    imageTap.numberOfTapsRequired = 1;
    [imageView addGestureRecognizer:imageTap];
    
    CGFloat labelTopPadding = topPadding + 3;
    CGFloat labelHeight = 12.0;
    
    CGFloat pointsWidth = 120.0;
    CGRect pointsRect = CGRectMake(self.frameWidth - leftPadding - pointsWidth, labelTopPadding, pointsWidth, labelHeight);
    pointsLabel = [[UILabel alloc] initWithFrame:pointsRect];
    pointsLabel.backgroundColor = [UIColor clearColor];
    pointsLabel.font = [UIFont systemFontOfSize:labelHeight];
    pointsLabel.textColor = kBlackColor;
    [self addSubview:pointsLabel];
    
    pointsLabel.frame = [UILabel textRectWithRect:pointsLabel.frame withFontSize:labelHeight];
    
    CGFloat nameOriginX = CGRectGetMaxX(imageView.frame) + leftPadding;
    CGRect nameRect = CGRectMake(nameOriginX, labelTopPadding, CGRectGetMinX(pointsRect) - nameOriginX, labelHeight);
    nameLabel = [[UILabel alloc] initWithFrame:nameRect];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont systemFontOfSize:labelHeight];
    nameLabel.textColor = kBlackColor;
    [self addSubview:nameLabel];
    
    nameLabel.frame = [UILabel textRectWithRect:nameLabel.frame withFontSize:labelHeight];
    
    CGFloat passwordBtnWidth = 60.0;
    UIButton *passwordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    passwordBtn.frame = CGRectMake(self.frameWidth - 40 - passwordBtnWidth, CGRectGetMaxY(nameRect) + 11, passwordBtnWidth, labelHeight);
    passwordBtn.titleLabel.font = [UIFont systemFontOfSize:labelHeight];
    [passwordBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    [passwordBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
    [passwordBtn addTarget:self action:@selector(passwordBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:passwordBtn];
    
    CGFloat accountOriginX = CGRectGetMaxX(imageView.frame) + leftPadding;
    CGFloat accountOriginY = CGRectGetMaxY(nameRect) + 10;
    CGRect accountRect = CGRectMake(accountOriginX, accountOriginY, CGRectGetMinX(passwordBtn.frame) - accountOriginX, labelHeight);
    accountLabel = [[UILabel alloc] initWithFrame:accountRect];
    accountLabel.backgroundColor = [UIColor clearColor];
    accountLabel.font = [UIFont systemFontOfSize:labelHeight];
    accountLabel.textColor = kBlackColor;
    [self addSubview:accountLabel];
    
    accountLabel.frame = [UILabel textRectWithRect:accountLabel.frame withFontSize:labelHeight];
    
    _nickField = [[UITextField alloc] init];
    _emailField = [[UITextField alloc] init];
    
    NSArray *titleArray = @[@"昵称",@"邮箱"];
    NSArray *viewArray = @[_nickField,_emailField];
    
    CGFloat filedOriginX = CGRectGetMaxX(imageView.frame);
    CGFloat filedOriginY = CGRectGetMaxY(imageView.frame) + topPadding;
    CGFloat filedWidth = self.frameWidth - filedOriginX * 2;
    CGFloat filedHeight = 34.0;
    
    CGFloat padding = 20.0;
    CGFloat originX = filedOriginX;
    CGFloat originY = filedOriginY;
    CGFloat titleWidth = 56.0;
    CGFloat cellHeight = filedHeight;
    
    for (int i = 0; i < titleArray.count; i ++) {
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY, filedWidth, cellHeight)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.clipsToBounds = YES;
        [self addSubview:bgView];
        
        bgView.layer.cornerRadius = 3;
        bgView.layer.borderColor = kLightLineColor.CGColor;
        bgView.layer.borderWidth = kDefaultLineHeight;
        
        CGRect labelRect = CGRectMake(originX, originY, titleWidth, cellHeight);
        UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
        label.text = [titleArray objectAtIndex:i];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = kTextTitleColor;
        label.font = kTextFont;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 0, kDefaultLineHeight, 14)];
        lineView.centerY = label.centerY;
        lineView.backgroundColor = kTextTitleColor;
        [self addSubview:lineView];
        
        CGFloat filedX = CGRectGetMaxX(labelRect) + padding;
        UITextField *textField = [viewArray objectAtIndex:i];
        textField.frame = CGRectMake(filedX, originY, filedWidth - filedX, cellHeight);
        textField.borderStyle = UITextBorderStyleNone;
        textField.textColor = kTextColor;
        textField.font = kTextFont;
        //textField.delegate = self;
        textField.tag = i + 100;
        textField.returnKeyType = UIReturnKeyDone;
        [self addSubview:textField];
        
        //[textField addTarget:self action:@selector(textFieldEndEdit) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        originY += (cellHeight + padding);
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)tapBackground
{
    [self endEditing:YES];
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
        nameLabel.hidden = NO;
        pointsLabel.hidden = NO;
        accountLabel.hidden = NO;
        blankLabel.hidden = YES;
        
        [imageView setImageWithURL:[NSURL URLWithString:self.user.profile] placeholderImage:[AvatarHelper defaultAvatar]];
        nameLabel.text = [NSString stringWithFormat:@"ID：%@", @(self.user.userId)];
        pointsLabel.text = [NSString stringWithFormat:@"积分：%@", @(self.user.points)];
        accountLabel.text = [NSString stringWithFormat:@"优医账号：%d", self.user.userId];
        
        _nickField.text = self.user.nickname;
    }
    else {
        nameLabel.hidden = YES;
        pointsLabel.hidden = YES;
        accountLabel.hidden = YES;
        blankLabel.hidden = NO;
        
        imageView.image = [AvatarHelper defaultAvatar];
        nameLabel.text = nil;
        pointsLabel.text = nil;
        accountLabel.text = nil;
    }
}

- (void)setImage:(UIImage *)image
{
    [imageView setImage:image];
}

- (void)passwordBtnPress
{
    if (self.clickPasswordBlock) {
        self.clickPasswordBlock();
    }
}

- (void)avatarPress
{
    [self endEditing:YES];
    
    if (self.clickAvatarBlock) {
        self.clickAvatarBlock();
    }
}

@end
