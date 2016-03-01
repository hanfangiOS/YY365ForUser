//
//  MapMechanicView.m
//  HuiYangChe
//
//  Created by zhouzhenhua on 14-12-13.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import "MapMechanicView.h"
#import "UIConstants.h"
#import "StarRatingView.h"
#import "Doctor.h"
#import "UIImageView+WebCache.h"

@implementation MapMechanicView
{
    UIImageView       *imageView;
    UILabel           *titleLabel;
    UILabel           *levelLabel;
    UILabel           *detailLabel;
    UILabel           *appointmentLabel;
    UILabel           *mileLabel;

    UIImageView       *mileIcon;
    StarRatingView    *ratingView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self initSubview];
    }
    return self;
}

+ (float)defaultWidth
{
    return 268.0;
}

+ (float)defaultHeight
{
    return 98.0;
}

- (void)initSubview
{
    float paopaoWidth = [self.class defaultWidth];
    float padding = 18.0;
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_location_pop_background"]];
    [self addSubview:backgroundImage];
    
    // 18,16,70,53
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding, 16, 70, 53)];
    [self addSubview:imageView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 6, 16, 158, 14)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = kBlackColor;
    [self addSubview:titleLabel];
    
    levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(titleLabel.frame) + 3, 0, 12)];
    levelLabel.font = [UIFont systemFontOfSize:12];
    levelLabel.backgroundColor = [UIColor clearColor];
    levelLabel.textColor = UIColorFromHex(0x929292);
    [self addSubview:levelLabel];
    
    appointmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(levelLabel.frame), 100, 12)];
    appointmentLabel.font = [UIFont systemFontOfSize:12];
    appointmentLabel.backgroundColor = [UIColor clearColor];
    appointmentLabel.textAlignment = NSTextAlignmentRight;
    appointmentLabel.textColor = kLightGrayColor;
    [self addSubview:appointmentLabel];
    
    detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame) + 7, CGRectGetWidth(titleLabel.frame), 12)];
    detailLabel.font = [UIFont systemFontOfSize:12];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.textColor = kLightGrayColor;
    [self addSubview:detailLabel];
    
    ratingView =  [[StarRatingView alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), 54, 70, 14)];
    ratingView.rate = 4.5;
    [self addSubview:ratingView];
    
    float mileOriginX = CGRectGetMaxX(ratingView.frame);
    mileLabel = [[UILabel alloc] initWithFrame:CGRectMake(mileOriginX, CGRectGetMinY(ratingView.frame) + 2, paopaoWidth - mileOriginX - padding, 12)];
    mileLabel.font = [UIFont systemFontOfSize:12];
    mileLabel.backgroundColor = [UIColor clearColor];
    mileLabel.textAlignment = NSTextAlignmentRight;
    mileLabel.textColor = kLightGrayColor;
    [self addSubview:mileLabel];
    
    mileIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_small_icon_location"]];
    mileIcon.frameY = mileLabel.frameY;
    [self addSubview:mileIcon];
}

- (void)update
{
    titleLabel.text = self.mechanic.name;
    detailLabel.text = self.mechanic.name;
    ratingView.rate = self.mechanic.rate;
    
    if (self.mechanic.levelDesc.length) {
        NSString *level = [NSString stringWithFormat:@"(%@)", self.mechanic.levelDesc];
        levelLabel.text = level;
    }
    else {
        levelLabel.text = nil;
    }
    
    float paopaoWidth = [self.class defaultWidth];
    float padding = 18.0;
    
    CGSize titleSize = [titleLabel.text sizeWithFont:titleLabel.font];
    titleLabel.frameWidth = ceilf(titleSize.width);
    
    CGSize levelSize = [levelLabel.text sizeWithFont:levelLabel.font];
    levelLabel.frameX = CGRectGetMaxX(titleLabel.frame);
    levelLabel.frameWidth = ceilf(levelSize.width);
    
    CGRect appointmentFrame = appointmentLabel.frame;
    appointmentFrame.origin.x = CGRectGetMaxX(levelLabel.frame);
    appointmentFrame.size.width = paopaoWidth - padding - appointmentFrame.origin.x;
    appointmentLabel.frame = appointmentFrame;
    
    float miles = 10.0/1000;
    if (miles > 0) {
        NSString *mileString = [NSString stringWithFormat:@"%.1fkm", miles];
        mileLabel.text = mileString;
        
        mileIcon.hidden = NO;
        
        CGSize mileSize = [mileLabel.text sizeWithFont:mileLabel.font];
        mileIcon.frameX = CGRectGetMaxX(mileLabel.frame) - ceilf(mileSize.width) - 2 - mileIcon.frameWidth;
    }else{
        mileLabel.text = nil;
        mileIcon.hidden = YES;
    }
    
    [imageView setImageWithURL:[NSURL URLWithString:self.mechanic.avatar] placeholderImage:[UIImage imageNamed:@"image_default_merchantlist"]];
}

@end
