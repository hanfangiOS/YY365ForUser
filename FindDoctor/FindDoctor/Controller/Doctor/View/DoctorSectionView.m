//
//  DoctorSectionView.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "DoctorSectionView.h"
#import "UILabel+Rect.h"

#define kDoctorSectionViewHeight  228.0

@implementation DoctorSectionView
{
    UILabel *titleLabel;
    UILabel *priceLabel;
    UILabel *countLabel;
}

+ (CGFloat)defaultHeight
{
    return kDoctorSectionViewHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];//UIColorFromRGB(246, 252, 245);
        
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews
{
    CGFloat titleWidth = 75.0;
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleWidth, 18.0)];
    titleLabel.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, 45.0 / 2);
    titleLabel.backgroundColor = self.backgroundColor;
    titleLabel.text = @"可预约";
    titleLabel.textColor = kGreenColor;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    CGFloat labelHeight = 17.0;
    CGFloat labelFontSize = 14.0;

    CGFloat priceWidth = 130.0;
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 45 + 24 - 1.5, priceWidth, labelHeight)];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.font = [UIFont systemFontOfSize:labelFontSize];
    [self addSubview:priceLabel];
    
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel.frame), CGRectGetMinY(priceLabel.frame), CGRectGetWidth(self.bounds) - CGRectGetMaxX(priceLabel.frame), labelHeight)];
    countLabel.backgroundColor = [UIColor clearColor];
    countLabel.font = [UIFont systemFontOfSize:labelFontSize];
    [self addSubview:countLabel];
    
    CGFloat btnWidth = 250.0;
    CGFloat btnHeight = 40.0;
    CGFloat btnOriginX = (CGRectGetWidth(self.bounds) - btnWidth) / 2;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(btnOriginX, CGRectGetHeight(self.bounds) - btnHeight - 30, btnWidth, btnHeight);
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn setTitle:@"约    诊" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[[UIImage imageNamed:kButtonGreenNor] stretchableImageByCenter] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[[UIImage imageNamed:kButtonGreenSel] stretchableImageByCenter] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnPress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    btn.backgroundColor = kGreenColor;
    btn.layer.cornerRadius = 3;
    btn.clipsToBounds = YES;
}

- (void)setData:(Doctor *)data
{
    _data = data;
    
    NSString *price = [NSString stringWithFormat:@"%.0f", _data.price];
    NSString *priceString = [NSString stringWithFormat:@"约诊费：%@ 元/次", price];
    NSMutableAttributedString *priceAttrString = [[NSMutableAttributedString alloc] initWithString:priceString];
    [priceAttrString addAttributes:@{NSForegroundColorAttributeName : kDarkGrayColor} range:NSMakeRange(0, priceString.length)];
    [priceAttrString addAttributes:@{NSForegroundColorAttributeName : kYellowColor} range:[priceString rangeOfString:price]];
    priceLabel.attributedText = priceAttrString;
    
    NSString *count = @"20/10";//[NSString stringWithFormat:@"%.0f", _data.price];
    NSString *countString = [NSString stringWithFormat:@"已预约：%@", count];
    NSMutableAttributedString *countAttrString = [[NSMutableAttributedString alloc] initWithString:countString];
    [countAttrString addAttributes:@{NSForegroundColorAttributeName : kDarkGrayColor} range:NSMakeRange(0, countString.length)];
    [countAttrString addAttributes:@{NSForegroundColorAttributeName : kYellowColor} range:[countString rangeOfString:count]];
    countLabel.attributedText = countAttrString;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat textOriginX = 20.0;
    CGFloat textOriginY = 45.0;
    CGFloat textSpace = 10.0;
    CGFloat textHeight = 14.0;
    
    [kDarkGrayColor set];

    NSString *subjectString = [NSString stringWithFormat:@"科目：%@", self.data.subject];
    
    CGRect subjectRect = CGRectMake(textOriginX, textOriginY, kScreenWidth - textOriginX, textHeight);
    [subjectString drawInRect:[UILabel textRectWithRect:subjectRect withFontSize:textHeight] withFont:[UIFont systemFontOfSize:textHeight]];
    
    NSString *timeString = [NSString stringWithFormat:@"就诊时间：%@", self.data.availableTime];
    
    CGRect timeRect = CGRectMake(CGRectGetMinX(subjectRect), CGRectGetMaxY(subjectRect) + textSpace * 4 - 3, CGRectGetWidth(subjectRect), textHeight);
    [timeString drawInRect:[UILabel textRectWithRect:timeRect withFontSize:textHeight] withFont:[UIFont systemFontOfSize:textHeight]];
    
    NSString *addressString = [NSString stringWithFormat:@"地点：%@", self.data.address];
    
    CGRect addressRect = CGRectMake(CGRectGetMinX(timeRect), CGRectGetMaxY(timeRect) + textSpace, CGRectGetWidth(timeRect), textHeight);
    [addressString drawInRect:[UILabel textRectWithRect:addressRect withFontSize:textHeight] withFont:[UIFont systemFontOfSize:textHeight]];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect lineRect = CGRectMake(0, textOriginY / 2, CGRectGetWidth(self.bounds), kDefaultLineHeight);
    CGContextSetFillColorWithColor(context, kLightLineColor.CGColor);
    CGContextFillRect(context, lineRect);
}

- (void)btnPress
{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end
