//
//  OrderCellContentView.m
//  EShiJia
//
//  Created by zhouzhenhua on 15-4-24.
//  Copyright (c) 2015年 zhouzhenhua. All rights reserved.
//

#import "OrderCellContentView.h"
#import "UILabel+Rect.h"
#import "StarRatingView.h"
#import "UIImageView+WebCache.h"

@implementation OrderCellContentView
{
    UIImageView     *imageView;
    StarRatingView  *ratingView;
    UIImageView     *tipImageView;
    UILabel         *tipLabel;
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
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 25, 40, 40)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self addSubview:imageView];
    
    imageView.layer.cornerRadius = 20;
    
    CGFloat tipWidth = 40.0;
    CGFloat tipHeight = 57.0;
    tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - tipWidth - 7, 0, tipWidth, tipHeight)];
    [self addSubview:tipImageView];
    
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tipImageView.frameWidth, tipImageView.frameHeight - 10)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.font = [UIFont systemFontOfSize:10];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor whiteColor];
    [tipImageView addSubview:tipLabel];
}

- (void)setData:(CUOrder *)data
{
    _data = data;
    
//    ratingView.rate = self.data.service.doctor.rate;
    
    [imageView setImageWithURL:[NSURL URLWithString:self.data.service.doctor.avatar] placeholderImage:nil];
    
    tipLabel.text = self.data.orderStatusStr;
    if (self.data.orderStatus == ORDERSTATUS_FINISHED) {
        tipImageView.image = [UIImage imageNamed:@"doctor_tip_green"];
    }
    else {
        tipImageView.image = [UIImage imageNamed:@"doctor_tip_red"];
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat nameHeight = 14.0;
    CGFloat nameWidth = 60.0;
    CGFloat nameOriginX = CGRectGetMidX(imageView.frame) - nameWidth / 2;
    CGFloat nameOriginY = CGRectGetMaxY(imageView.frame) + 15;
    
    [kBlackColor set];
    
    CGRect nameRect = CGRectMake(nameOriginX, nameOriginY, nameWidth, nameHeight);
    [self.data.service.doctor.name drawInRect:[UILabel textRectWithRect:nameRect withFontSize:nameHeight] withFont:[UIFont systemFontOfSize:nameHeight] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    
    [kDarkGrayColor set];
    
    CGFloat textSpace = 8.0;
    CGFloat textOriginX = CGRectGetMaxX(imageView.frame) + 20;
    CGFloat textHeight = 10.0;
    CGFloat textWidth = kScreenWidth - tipImageView.frameWidth - 7 * 2 - nameOriginX;
    
    NSString *numString = [NSString stringWithFormat:@"单号：%@", self.data.diagnosisID];
    
    CGRect numRect = CGRectMake(textOriginX, 15, textWidth, textHeight);
    [numString drawInRect:[UILabel textRectWithRect:numRect withFontSize:textHeight] withFont:[UIFont systemFontOfSize:textHeight] lineBreakMode:NSLineBreakByTruncatingTail];
    
    NSString *patientString = [self.data userDesc];
    
    CGRect patientRect = CGRectMake(textOriginX, CGRectGetMaxY(numRect) + textSpace, textWidth, textHeight);
    [patientString drawInRect:[UILabel textRectWithRect:patientRect withFontSize:textHeight] withFont:[UIFont systemFontOfSize:textHeight] lineBreakMode:NSLineBreakByTruncatingTail];
    
    // TODO:
    NSString *statusString = @"已完成";
    
    CGRect statusRect = CGRectMake(textOriginX, CGRectGetMaxY(patientRect) + textSpace, textWidth, textHeight);
    [statusString drawInRect:[UILabel textRectWithRect:statusRect withFontSize:textHeight] withFont:[UIFont systemFontOfSize:textHeight]];
    
    CGFloat timeWidth = kScreenWidth - 7 - nameOriginX;
    NSString *timeString = [NSString stringWithFormat:@"时间：%@", self.data.service.doctor.availableTime];
    
    CGRect timeRect = CGRectMake(textOriginX, CGRectGetMaxY(statusRect) + textSpace, timeWidth, textHeight);
    [timeString drawInRect:[UILabel textRectWithRect:timeRect withFontSize:textHeight] withFont:[UIFont systemFontOfSize:textHeight] lineBreakMode:NSLineBreakByTruncatingTail];
    
    NSString *addressString = [NSString stringWithFormat:@"地点：%@", self.data.service.doctor.address];
    
    CGRect addressRect = CGRectMake(CGRectGetMinX(timeRect), CGRectGetMaxY(timeRect) + textSpace, CGRectGetWidth(timeRect), textHeight);
    [addressString drawInRect:[UILabel textRectWithRect:addressRect withFontSize:textHeight] withFont:[UIFont systemFontOfSize:textHeight] lineBreakMode:NSLineBreakByTruncatingTail];
}

- (void)hilight
{
    
}

- (void)normal
{
    
}

@end