//
//  DoctorCellContentView.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "MyClinicCellContentView.h"
#import "UILabel+Rect.h"
#import "StarRatingView.h"
#import "UIImageView+WebCache.h"

@implementation MyClinicCellContentView
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
    tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - tipWidth - 7, 0, tipWidth, tipHeight)];
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
//    
//    label2 = [[UILabel alloc] initWithFrame:CGRectMake(90,CGRectGetMaxY(label1.frame)+12, textWidth, 14)];
//    label2.backgroundColor = [UIColor clearColor];
//    label2.font = [UIFont systemFontOfSize:10];
//    label2.textColor = kDarkGrayColor;
//    [self addSubview:label2];
//    
//    label3 = [[UILabel alloc] initWithFrame:CGRectMake(90,CGRectGetMaxY(label2.frame)+10, textWidth, 14)];
//    label3.backgroundColor = [UIColor clearColor];
//    label3.font = [UIFont systemFontOfSize:10];
//    label3.textColor = kDarkGrayColor;
//    [self addSubview:label3];
//    
//    label4 = [[UILabel alloc] initWithFrame:CGRectMake(90,CGRectGetMaxY(label3.frame)+10, textWidth, 14)];
//    label4.backgroundColor = [UIColor clearColor];
//    label4.font = [UIFont systemFontOfSize:14];
//    label4.textColor = kYellowColor;
//    [self addSubview:label4];
//    
//    label5 = [[UILabel alloc] initWithFrame:CGRectMake(90,CGRectGetMaxY(label4.frame)+10, textWidth, 14)];
//    label5.backgroundColor = [UIColor clearColor];
//    label5.font = [UIFont systemFontOfSize:14];
//    label5.textColor = kDarkGrayColor;
//    [self addSubview:label5];
    
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

- (void)setData:(Clinic *)data
{
    _data = data;
    
    [imageView setImageWithURL:self.data.icon placeholderImage:nil];
    
    NSString *str = [NSString stringWithFormat:@"%@",self.data.name];
    NSMutableAttributedString *atrStr = [[NSMutableAttributedString alloc]initWithString:str];
    [atrStr addAttributes:@{NSFontAttributeName:SystemFont_14,NSForegroundColorAttributeName:kBlackColor} range:[str rangeOfString:self.data.name]];
    label1.attributedText = atrStr;
    
    jianJieLabel.text = [NSString stringWithFormat:@"简介: %@",self.data.breifInfo];
    shanChangLabel.text = [NSString stringWithFormat:@"擅长: %@",self.data.skillTreat];

    [self setZhenLiaoAmount];
    [self setNeedsDisplay];
}

- (void)setZhenLiaoAmount{
//    zhenLiaoAmountLabel.text =[NSString stringWithFormat:@"%ld", _data.zhenLiaoAmount];
    [zhenLiaoAmountLabel sizeToFit];
    CGFloat width = zhenLiaoAmountLabel.frameWidth + zhenLiaoAmountImageView.frameWidth + 5;
    zhenLiaoAmountImageView.frame = CGRectMake(imageView.frameX+imageView.frameWidth*0.5 - width*0.5, zhenLiaoAmountImageView.frameY, zhenLiaoAmountImageView.frameWidth, zhenLiaoAmountImageView.frameHeight);
    zhenLiaoAmountLabel.frame = CGRectMake(CGRectGetMaxX(zhenLiaoAmountImageView.frame)+5, zhenLiaoAmountImageView.frameY - 1, zhenLiaoAmountLabel.frameWidth, zhenLiaoAmountLabel.frameHeight);
}

- (void)hilight
{
    
}

- (void)normal
{
    
}

@end
