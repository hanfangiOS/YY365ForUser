//
//  MapMerchantView.m
//  HuiYangChe
//
//  Created by zhouzhenhua on 14-9-21.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import "MapMerchantView.h"
#import "UIConstants.h"
#import "StarRatingView.h"
#import "Clinic.h"
#import "UIImageView+WebCache.h"

@implementation MapMerchantView
{
    UIImageView       *imageView;
    UILabel           *titleLabel;
    UILabel           *detailLabel;
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
    float padding = 13.0;
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_location_pop_background"]];
    [self addSubview:backgroundImage];
    
    // 18,16,70,53
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding, 16, 70, 53)];
    [self addSubview:imageView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, padding, 158, 15)];
    titleLabel.tag = 11;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:titleLabel];
    
    detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame) + 5, CGRectGetWidth(titleLabel.frame), self.frameHeight - (CGRectGetMaxY(titleLabel.frame) + 7) - 16)];
    detailLabel.tag = 12;
    detailLabel.font = [UIFont systemFontOfSize:10];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.numberOfLines = 0;
    detailLabel.clipsToBounds = YES;
    [self addSubview:detailLabel];
    
    ratingView =  [[StarRatingView alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(detailLabel.frame) + 7, 70, 14)];
    ratingView.rate = 4.5;
//    [self addSubview:ratingView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(turnToClinicAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    backgroundImage.userInteractionEnabled = YES;
    [backgroundImage addGestureRecognizer:tap];
}

- (void)turnToClinicAction{
    [self.delegate MapMerchantViewturnToClinicVCWithMerchant:self.merchant];
}

- (void)update
{
    titleLabel.text = self.merchant.name;
    detailLabel.text = self.merchant.breifInfo;
//    ratingView.rate = self.merchant.rate;
    
    [imageView setImageWithURL:[NSURL URLWithString:self.merchant.icon] placeholderImage:[UIImage imageNamed:@"image_default_merchantlist"]];
}

@end
