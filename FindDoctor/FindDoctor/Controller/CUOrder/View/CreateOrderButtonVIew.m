//
//  CreateOrderButtonView.m
//  EShiJia
//
//  Created by zhouzhenhua on 15-4-19.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CreateOrderButtonView.h"
#import "UIConstants.h"
#import "UIImage+Stretch.h"
#import "UIImage+Color.h"

#define kDefaultHeight     64.0

#define kViewWidth         CGRectGetWidth(self.bounds)
#define kRPadding          10.0

#define kIconWidth         20.0
#define kIconHeight        20.0
#define kIconOriginX       20.0
#define kIconOriginY       ((CGRectGetHeight(self.bounds) - kIconHeight) / 2)

#define kButtonWidth       128.0
#define kButtonHeight      44.0
#define kButtonOriginX     (kViewWidth - kButtonWidth - kRPadding)
#define kButtonOriginY     ((CGRectGetHeight(self.bounds) - kButtonHeight) / 2)

#define kLabelOriginX      15.0
#define kLabelWidth        (kButtonOriginX - kLabelOriginX)
#define kLabelHeight       30.0
#define kLabelOriginY      ((CGRectGetHeight(self.bounds) - kLabelHeight) / 2)

#define kPriceColor        kYellowColor
#define kLineColor         UIColorFromHex(0xc8cacc)

@implementation CreateOrderButtonView
{
    UIImageView *iconView;
    UILabel     *orderLabel;
    UIButton    *orderButton;
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

+ (float)defaultHeight
{
    return kDefaultHeight;
}

- (void)initSubviews
{
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0.5)];
    topLine.backgroundColor = kLineColor;
    [self addSubview:topLine];
    
    orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelOriginX, kLabelOriginY, kLabelWidth, kLabelHeight)];
    orderLabel.backgroundColor = [UIColor clearColor];
    orderLabel.textColor = kPriceColor;
    orderLabel.font = [UIFont boldSystemFontOfSize:24];
    [self addSubview:orderLabel];
    
    orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    orderButton.frame = CGRectMake(kButtonOriginX, kButtonOriginY, kButtonWidth, kButtonHeight);
    [orderButton setBackgroundImage:[[UIImage createImageWithColor:kPayBtnColor] stretchableImageByCenter] forState:UIControlStateNormal];
    [orderButton setBackgroundImage:[[UIImage createImageWithColor:kDarkPayBtnColor] stretchableImageByCenter] forState:UIControlStateHighlighted];
    orderButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [orderButton addTarget:self action:@selector(buttonPress) forControlEvents:UIControlEventTouchUpInside];
    [orderButton setTitle:@"预约" forState:UIControlStateNormal];
    orderButton.clipsToBounds = YES;
    [self addSubview:orderButton];
}

- (void)setTitle:(NSString *)title
{
    [orderButton setTitle:title.length ? title : @"预约" forState:UIControlStateNormal];
}

- (void)setAmount:(double)amount
{
    _amount = amount;
    
    [self updateOrderLabel];
}

- (void)setAmountTitle:(NSString *)amountTitle
{
    _amountTitle = amountTitle;
    
    [self updateOrderLabel];
}

- (void)setAmountFont:(UIFont *)amountFont
{
    orderLabel.font = amountFont;
}

- (void)updateOrderLabel
{
    if (_amountTitle.length) {
        orderLabel.text = [NSString stringWithFormat:@"%@：￥%.0f", _amountTitle, _amount];
    }
    else {
        orderLabel.text = [NSString stringWithFormat:@"￥%.0f", _amount];
    }
}

- (void)setShowAmount:(BOOL)showAmount
{
    if (showAmount) {
        orderLabel.hidden = NO;
        iconView.hidden = NO;
        
        orderButton.frame = CGRectMake(kViewWidth - kButtonWidth, 0, kButtonWidth, CGRectGetHeight(self.bounds));
        orderButton.layer.cornerRadius = 0;
    }
    else {
        orderLabel.hidden = YES;
        iconView.hidden = YES;
        
        orderButton.frame = CGRectMake(kRPadding, kButtonOriginY, CGRectGetWidth(self.bounds) - kRPadding * 2, kButtonHeight);
        orderButton.layer.cornerRadius = 5;
    }
}

- (void)setEnable:(BOOL)enable
{
    orderButton.enabled = enable;
}

- (void)buttonPress
{
    if (self.onClickAction) {
        self.onClickAction();
    }
}

@end
