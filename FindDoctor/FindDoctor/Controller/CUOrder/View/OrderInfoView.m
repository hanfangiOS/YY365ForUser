//
//  OrderInfoView.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/24.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "OrderInfoView.h"
#import "UILabel+Rect.h"

#define kOrderInfoViewHeight  120.0

@implementation OrderInfoView
{
    UILabel *titleLabel;
    UILabel *priceLabel;
    UILabel *countLabel;
}

+ (CGFloat)defaultHeight
{
    return kOrderInfoViewHeight;
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
    CGFloat priceWidth = 130.0;
    CGFloat priceHeight = 18.0;
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.frameHeight - priceHeight - 13, priceWidth, priceHeight)];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:priceLabel];
    
//    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel.frame), CGRectGetMinY(priceLabel.frame), CGRectGetWidth(self.bounds) - CGRectGetMaxX(priceLabel.frame), 16.0)];
//    countLabel.backgroundColor = [UIColor clearColor];
//    countLabel.font = [UIFont systemFontOfSize:13];
//    [self addSubview:countLabel];
}

- (void)update
{
    NSString *price = [NSString stringWithFormat:@"%.2f", self.order.service.doctor.price/100.f];
    NSString *priceString = [NSString stringWithFormat:@"金额：%@ 元/次", price];
    NSMutableAttributedString *priceAttrString = [[NSMutableAttributedString alloc] initWithString:priceString];
    [priceAttrString addAttributes:@{NSForegroundColorAttributeName : kBlackColor} range:NSMakeRange(0, priceString.length)];
    [priceAttrString addAttributes:@{NSForegroundColorAttributeName : kYellowColor} range:[priceString rangeOfString:price]];
    priceLabel.attributedText = priceAttrString;
    
    NSString *count = @"20/10";//[NSString stringWithFormat:@"%.0f", _data.price];
    NSString *countString = [NSString stringWithFormat:@"已预约：%@", count];
    NSMutableAttributedString *countAttrString = [[NSMutableAttributedString alloc] initWithString:countString];
    [countAttrString addAttributes:@{NSForegroundColorAttributeName : kBlackColor} range:NSMakeRange(0, countString.length)];
    [countAttrString addAttributes:@{NSForegroundColorAttributeName : kYellowColor} range:[countString rangeOfString:count]];
    countLabel.attributedText = countAttrString;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat textOriginX = 15.0;
    CGFloat textOriginY = 15.0;
    CGFloat textSpace = 12.0;
    CGFloat textHeight = 14.0;
    
    [kBlackColor set];
    
    NSString *numString = [NSString stringWithFormat:@"单号：%lld", self.order.diagnosisID];
    
    CGRect numRect = CGRectMake(textOriginX, textOriginY, kScreenWidth - textOriginX, textHeight);
    [numString drawInRect:[UILabel textRectWithRect:numRect withFontSize:textHeight] withFont:[UIFont systemFontOfSize:textHeight]];
    
    NSString *descString = [NSString stringWithFormat:@"内容：约%@%@，%@", self.order.service.doctor.name, self.order.service.doctor.levelDesc, self.order.diagnosisTime];
    
    CGRect descRect = CGRectMake(CGRectGetMinX(numRect), CGRectGetMaxY(numRect) + textSpace, CGRectGetWidth(numRect), textHeight);
    [descString drawInRect:[UILabel textRectWithRect:descRect withFontSize:textHeight] withFont:[UIFont systemFontOfSize:textHeight]];
    
    NSString *addressString = [NSString stringWithFormat:@"地点：%@", self.order.service.doctor.address];
    
    CGRect addressRect = CGRectMake(CGRectGetMinX(descRect), CGRectGetMaxY(descRect) + textSpace, CGRectGetWidth(descRect), textHeight);
    [addressString drawInRect:[UILabel textRectWithRect:addressRect withFontSize:textHeight] withFont:[UIFont systemFontOfSize:textHeight]];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect lineRect = CGRectMake(0, CGRectGetHeight(self.bounds) - kDefaultLineHeight, CGRectGetWidth(self.bounds), kDefaultLineHeight);
    CGContextSetFillColorWithColor(context, kLightLineColor.CGColor);
    CGContextFillRect(context, lineRect);
}

@end
