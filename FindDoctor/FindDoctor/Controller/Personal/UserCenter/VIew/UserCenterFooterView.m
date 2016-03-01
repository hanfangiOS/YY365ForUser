//
//  UserCenterFooterView.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/19.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "UserCenterFooterView.h"

#define kFooterViewHeight      110.0
#define kFooterItemViewHeight  80.0

@implementation UserCenterFooterView
{
    UIScrollView *contentView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews
{
    CGFloat headerHeight = 24.0;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, headerHeight / 2, self.frameWidth, kDefaultLineHeight)];
    lineView.backgroundColor = kLightLineColor;
    [self addSubview:lineView];
    
    CGFloat titleWidth = 75.0;
    CGFloat leftPadding = (kScreenWidth - titleWidth) / 2;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, 0, titleWidth, headerHeight)];
    titleLabel.backgroundColor = self.backgroundColor;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = kGreenColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我的";
    [self addSubview:titleLabel];
    
    contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, headerHeight + 5, self.frameWidth, kFooterItemViewHeight)];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.scrollEnabled = NO;
    [self addSubview:contentView];
    
    CGFloat imageOriginX = 14.0;
    CGFloat imageOriginY = 0.0;
    CGFloat imageWidth = 56.0;
    CGFloat imageHeight = imageWidth;
    
    CGFloat labelWidth = imageWidth;
    CGFloat labelHeight = 15.0;
    
    NSArray *titleArr = @[@"收藏", @"记录", @"咨询", @"账户"];
    NSArray *iconArr = @[@"uc_fav", @"uc_record", @"uc_consult", @"uc_account"];
    
    CGFloat imageSpace = (self.frameWidth - titleArr.count * imageWidth - imageOriginX * 2) / (titleArr.count - 1);
    CGFloat btnWidth = contentView.frameWidth / titleArr.count;
    
    for (NSInteger i = 0; i < titleArr.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageOriginX, imageOriginY, imageWidth, imageHeight)];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:iconArr[i]];
        [contentView addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageOriginX, CGRectGetMaxY(imageView.frame) + 4, labelWidth, labelHeight)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = kBlackColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = titleArr[i];
        [contentView addSubview:titleLabel];
        
        imageOriginX += (imageWidth + imageSpace);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * btnWidth, 0, btnWidth, contentView.frameHeight);
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
    }
}

+ (CGFloat)defaultHeight
{
    return kFooterViewHeight;
}

- (void)btnPress:(UIButton *)btn
{
    if (self.clickAction) {
        self.clickAction(btn.tag - 100);
    }
}

@end
