//
//  DoctorCellContentView.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "DoctorCellContentView.h"
#import "UILabel+Rect.h"
#import "StarRatingView.h"
#import "UIImageView+WebCache.h"

@implementation DoctorCellContentView
{
    UIImageView     *imageView;
    StarRatingView  *ratingView;
    UIImageView     *tipImageView;
    UIImageView     *zhenLiaoAmountImageView;
    UILabel         *zhenLiaoAmountLabel;
    
    UILabel         *jianJieLabel;
    UILabel         *shanChangLabel;
    
    UILabel         *label1;
    UILabel         *label2;
    UILabel         *label3;
    UILabel         *label4;
    UILabel         *label5;
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
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12,15, 60 , 60)];
    imageView.layer.cornerRadius = imageView.frameHeight/2.f;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self addSubview:imageView];
    
    CGFloat tipWidth = 57.0;
    CGFloat tipHeight = 57.0;
    tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - tipWidth, 0, tipWidth, tipHeight)];
    [self addSubview:tipImageView];
    
    CGFloat nameOriginX = CGRectGetMaxX(imageView.frame) + 20;
    CGFloat textWidth = kScreenWidth - tipImageView.frameWidth*0.2 - 7 * 2 - nameOriginX;
    
    jianJieLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 50, textWidth,30)];
    jianJieLabel.backgroundColor = [UIColor clearColor];
    jianJieLabel.font = [UIFont systemFontOfSize:10];
//    jianJieLabel.textAlignment = NSTextAlignmentCenter;
    jianJieLabel.textColor = kDarkGrayColor;
    jianJieLabel.numberOfLines = 2;
    [self addSubview:jianJieLabel];
    
    shanChangLabel = [[UILabel alloc] initWithFrame:CGRectMake(90,80, textWidth, 30)];
    shanChangLabel.backgroundColor = [UIColor clearColor];
    shanChangLabel.font = [UIFont systemFontOfSize:10];
//    shanChangLabel.textAlignment = NSTextAlignmentCenter;
    shanChangLabel.textColor = kDarkGrayColor;
    shanChangLabel.numberOfLines = 2;
    [self addSubview:shanChangLabel];
    
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(90,15, textWidth, 14)];
    label1.backgroundColor = [UIColor clearColor];
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = kDarkGrayColor;
    [self addSubview:label1];
    
    label2 = [[UILabel alloc] initWithFrame:CGRectMake(90,CGRectGetMaxY(label1.frame)+12, textWidth, 14)];
    label2.backgroundColor = [UIColor clearColor];
    label2.font = [UIFont systemFontOfSize:10];
    label2.textColor = kDarkGrayColor;
    [self addSubview:label2];
    
    label3 = [[UILabel alloc] initWithFrame:CGRectMake(90,CGRectGetMaxY(label2.frame)+10, textWidth, 14)];
    label3.backgroundColor = [UIColor clearColor];
    label3.font = [UIFont systemFontOfSize:10];
    label3.textColor = kDarkGrayColor;
    [self addSubview:label3];
    
    label4 = [[UILabel alloc] initWithFrame:CGRectMake(90,CGRectGetMaxY(label3.frame)+10, textWidth, 14)];
    label4.backgroundColor = [UIColor clearColor];
    label4.font = [UIFont systemFontOfSize:14];
    label4.textColor = kYellowColor;
    [self addSubview:label4];
    
    label5 = [[UILabel alloc] initWithFrame:CGRectMake(90,CGRectGetMaxY(label4.frame)+10, textWidth, 14)];
    label5.backgroundColor = [UIColor clearColor];
    label5.font = [UIFont systemFontOfSize:14];
    label5.textColor = kDarkGrayColor;
    [self addSubview:label5];
    
    zhenLiaoAmountImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhenLiaoAmount"]];
    zhenLiaoAmountImageView.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 15, 13, 13);
    [self addSubview:zhenLiaoAmountImageView];
    
    zhenLiaoAmountLabel = [[UILabel alloc]init];
    zhenLiaoAmountLabel.font = [UIFont systemFontOfSize:14];
    zhenLiaoAmountLabel.textColor = UIColorFromHex(0xfc8a03);
    [self addSubview:zhenLiaoAmountLabel];
//    ratingView = [[StarRatingView alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(imageView.frame) + 12, 70, 15)];
//    [self addSubview:ratingView];
}

- (void)setData:(Doctor *)data
{
    _data = data;
    
//    ratingView.rate = self.data.rate;
    
    [imageView setImageWithURL:[NSURL URLWithString:self.data.avatar] placeholderImage:nil];
    
    NSString *str = [NSString stringWithFormat:@"%@      %@",self.data.name,self.data.levelDesc];
    NSMutableAttributedString *atrStr = [[NSMutableAttributedString alloc]initWithString:str];
    [atrStr addAttributes:@{NSFontAttributeName:SystemFont_14,NSForegroundColorAttributeName:kBlackColor} range:[str rangeOfString:self.data.name]];
    label1.attributedText = atrStr;
    
    if (_data.doctorState != -1) {
        if ([self.data isAvailable]) {
            tipImageView.image = [UIImage imageNamed:@"keYueZhen"];
        }
        else {
            tipImageView.image = [UIImage imageNamed:@"yueZhenMan"];
        }
        jianJieLabel.text = nil;
        shanChangLabel.text = nil;
        
        str = [NSString stringWithFormat:@"就诊时间:%@",self.data.availableTime];
        atrStr = [[NSMutableAttributedString alloc]initWithString:str];
        [atrStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromHex(Color_Hex_NavBackground)} range:[str rangeOfString:@"就诊时间:"]];
        label2.attributedText = atrStr;
        
        str = [NSString stringWithFormat:@"就诊地点:%@",self.data.address];
        atrStr = [[NSMutableAttributedString alloc]initWithString:str];
        [atrStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromHex(Color_Hex_NavBackground)} range:[str rangeOfString:@"就诊地点:"]];
        label3.attributedText = atrStr;
        
        str = [NSString stringWithFormat:@"诊金: ￥%.2f",self.data.price/100.f];
        atrStr = [[NSMutableAttributedString alloc]initWithString:str];
        [atrStr addAttributes:@{NSFontAttributeName:SystemFont_10,NSForegroundColorAttributeName:UIColorFromHex(Color_Hex_NavBackground)} range:[str rangeOfString:@"诊金: "]];
        label4.attributedText = atrStr;

    }
    else{
        jianJieLabel.text = [NSString stringWithFormat:@"简介: %@",self.data.background];
        shanChangLabel.text = [NSString stringWithFormat:@"擅长: %@",self.data.skilledSubject];
        label2.text = nil;
        label3.text = nil;
        label4.text = nil;
        label5.text = nil;
        
        tipImageView.image = nil;
    }
    [self setZhenLiaoAmount];
    [self setNeedsDisplay];
}

- (void)setZhenLiaoAmount{
    zhenLiaoAmountLabel.text =[NSString stringWithFormat:@"%ld", _data.zhenLiaoAmount];
    [zhenLiaoAmountLabel sizeToFit];
    CGFloat width = zhenLiaoAmountLabel.frameWidth + zhenLiaoAmountImageView.frameWidth + 5;
    zhenLiaoAmountImageView.frame = CGRectMake(imageView.frameX+imageView.frameWidth*0.5 - width*0.5, zhenLiaoAmountImageView.frameY, zhenLiaoAmountImageView.frameWidth, zhenLiaoAmountImageView.frameHeight);
    zhenLiaoAmountLabel.frame = CGRectMake(CGRectGetMaxX(zhenLiaoAmountImageView.frame)+5, zhenLiaoAmountImageView.frameY - 1, zhenLiaoAmountLabel.frameWidth, zhenLiaoAmountLabel.frameHeight);
}
//
//- (void)drawRect:(CGRect)rect
//{
//    [kBlackColor set];
//    
//    CGFloat nameOriginX = CGRectGetMaxX(imageView.frame) + 20;
//    CGFloat nameHeight = 14.0;
//    CGFloat nameWidth = 50.0;
//    
//    CGRect nameRect = CGRectMake(90, 15, nameWidth, nameHeight);
//    [self.data.name drawInRect:[UILabel textRectWithRect:nameRect withFontSize:nameHeight] withFont:[UIFont systemFontOfSize:nameHeight]];
//    
//    [kDarkGrayColor set];
//    
//    CGFloat levelHeight = 12.0;
//    CGRect levelRect = CGRectMake(CGRectGetMaxX(nameRect), CGRectGetMaxY(nameRect) - levelHeight, kScreenWidth - 54 - CGRectGetMaxX(nameRect), levelHeight);
//    [self.data.levelDesc drawInRect:[UILabel textRectWithRect:levelRect withFontSize:levelHeight] withFont:[UIFont systemFontOfSize:levelHeight] lineBreakMode:NSLineBreakByTruncatingTail];
//    
//    CGFloat textSpace = 8.0;
//    CGFloat textHeight = 10.0;
//    CGFloat textWidth = kScreenWidth - tipImageView.frameWidth*0.2 - 7 * 2 - nameOriginX;
//    
////    if (_data.doctorState != -1) {
//        NSString *timeString = [NSString stringWithFormat:@"就诊时间：%@", self.data.availableTime];
//        
//        CGRect timeRect = CGRectMake(CGRectGetMinX(nameRect), CGRectGetMaxY(nameRect) + 28, textWidth, textHeight);
//        [timeString drawInRect:[UILabel textRectWithRect:timeRect withFontSize:textHeight] withFont:[UIFont systemFontOfSize:textHeight] lineBreakMode:NSLineBreakByTruncatingTail];
//        
//        NSString *addressString = [NSString stringWithFormat:@"地点：%@", self.data.address];
//        
//        CGRect addressRect = CGRectMake(CGRectGetMinX(timeRect), CGRectGetMaxY(timeRect) + textSpace, CGRectGetWidth(timeRect), textHeight);
//        [addressString drawInRect:[UILabel textRectWithRect:addressRect withFontSize:textHeight] withFont:[UIFont systemFontOfSize:textHeight] lineBreakMode:NSLineBreakByTruncatingTail];
//        
//        NSString *subjectString = [NSString stringWithFormat:@"科目：%@", self.data.subject];
//        
//        CGFloat subjectWidth = kScreenWidth - 7 - nameOriginX;
//        CGRect subjectRect = CGRectMake(CGRectGetMinX(addressRect), CGRectGetMaxY(addressRect) + textSpace, subjectWidth, textHeight);
//        //    [subjectString drawInRect:[UILabel textRectWithRect:subjectRect withFontSize:textHeight] withFont:[UIFont systemFontOfSize:textHeight] lineBreakMode:NSLineBreakByTruncatingTail];
//        
//        NSString *priceTitle = @"诊金：";
//        
//        CGRect priceTitleRect = CGRectMake(CGRectGetMinX(addressRect), CGRectGetMaxY(addressRect) + textSpace, 32, textHeight);
//        [priceTitle drawInRect:[UILabel textRectWithRect:priceTitleRect withFontSize:textHeight] withFont:[UIFont systemFontOfSize:textHeight]];
//        
//        [kYellowColor set];
//        
//        CGFloat priceHeight = 15.0;
//        NSString *priceString = [NSString stringWithFormat:@"￥%.2f", self.data.price/100.f];
//        
//        CGRect priceRect = CGRectMake(CGRectGetMaxX(priceTitleRect), CGRectGetMaxY(priceTitleRect) - priceHeight, kScreenWidth - CGRectGetMaxX(priceTitleRect), priceHeight);
//        CGRect adaptedPriceRect = [UILabel textRectWithRect:priceRect withFontSize:priceHeight];
//        adaptedPriceRect.origin.y += 3; // 纯数字偏小，需微调
//        [priceString drawInRect:adaptedPriceRect withFont:[UIFont systemFontOfSize:priceHeight]];
////    }
//}

- (void)hilight
{
    
}

- (void)normal
{
    
}

@end
