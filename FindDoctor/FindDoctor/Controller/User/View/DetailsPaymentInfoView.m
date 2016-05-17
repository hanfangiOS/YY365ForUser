//
//  DetailsPaymentInfoView.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/18.
//  Copyright © 2016年 li na. All rights reserved.
//
#define DetailsPaymentInfoViewHeight 138

#import "DetailsPaymentInfoView.h"
#import "HFTitleView.h"

@interface DetailsPaymentInfoView ()

@property (strong,nonatomic)HFTitleView * titleView;
@property (strong,nonatomic)UIView * line1;
@property (strong,nonatomic)UIView * line2;
@property (strong,nonatomic)UILabel * orderAmountLabel;
@property (strong,nonatomic)UILabel * orderDiscountLabel;
@property (strong,nonatomic)UILabel * cashLabel;
@property (strong,nonatomic)UILabel * orderAmount;
@property (strong,nonatomic)UILabel * orderDiscount;
@property (strong,nonatomic)UILabel * cash;

@end

@implementation DetailsPaymentInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        return self;
    }
    return nil;
}

+ (float)defaultHeight{
    
    return DetailsPaymentInfoViewHeight;
}

- (void)setDefaultValue{
    self.orderAmount.text = @"－－";
    
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString * strSymbol = [locale objectForKey:NSLocaleCurrencySymbol];
    self.orderDiscount.text = [NSString stringWithFormat:@"-%@%.2f",strSymbol,(float)0];
    
    self.cash.text = @"－－";
}

- (void)initSubViews{
    
    self.titleView = [[HFTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 27) titleText:@"支付信息" Style:HFTitleViewStyleLoadMore];
    self.titleView.pic.backgroundColor = UIColorFromHex(Color_Hex_NavBackground);
    self.titleView.loadMoreBtn.hidden = YES;
    self.titleView.title.font = [UIFont systemFontOfSize:12];
    self.titleView.title.textColor = [UIColor blackColor];
    [self addSubview:self.titleView];
    
    self.line1 = [[UIView alloc] initWithFrame:CGRectMake(8, 26, kScreenWidth - 10, 1)];
    self.line1.backgroundColor = kblueLineColor;
    [self addSubview:self.line1];
    
    self.orderAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.titleView.maxY + 15, 60, 12)];
    self.orderAmountLabel.text = @"订单总额 :";
    self.orderAmountLabel.textAlignment = NSTextAlignmentLeft;
    self.orderAmountLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.orderAmountLabel];
    
    self.orderDiscountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.orderAmountLabel.maxY + 11, 60, 12)];
    self.orderDiscountLabel.text = @"订  金  券 :";
    self.orderDiscountLabel.textAlignment = NSTextAlignmentLeft;
    self.orderDiscountLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.orderDiscountLabel];
    
    self.line2 = [[UIView alloc] initWithFrame:CGRectMake(8, self.orderDiscountLabel.maxY + 15, kScreenWidth - 8, 1)];
     self.line2.backgroundColor = kblueLineColor;
    [self addSubview:self.line2];
    
    self.cashLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.line2.maxY + 18, 60, 12)];
    self.cashLabel.text = @"现金支付 :";
    self.cashLabel.textAlignment = NSTextAlignmentLeft;
    self.cashLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.cashLabel];
    
    self.orderAmount = [[UILabel alloc] initWithFrame:CGRectMake(self.orderAmountLabel.maxX + 2, self.orderAmountLabel.frameY, kScreenWidth - self.orderAmountLabel.maxX - 2 - 10, self.orderAmountLabel.frameHeight)];
    self.orderAmount.textAlignment = NSTextAlignmentRight;
    self.orderAmount.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.orderAmount];
    
    self.orderDiscount = [[UILabel alloc] initWithFrame:CGRectMake(self.orderDiscountLabel.maxX + 2, self.orderDiscountLabel.frameY, kScreenWidth - self.orderDiscountLabel.maxX - 2 - 10, self.orderDiscountLabel.frameHeight)];
    self.orderDiscount.textAlignment = NSTextAlignmentRight;
    self.orderDiscount.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.orderDiscount];
    
    self.cash = [[UILabel alloc] initWithFrame:CGRectMake(self.cashLabel.maxX + 2, self.cashLabel.frameY - 7, kScreenWidth - self.cashLabel.maxX - 2 - 10, 18)];
    self.cash.textAlignment = NSTextAlignmentRight;
    self.cash.font = [UIFont systemFontOfSize:18];
    self.cash.textColor = UIColorFromHex(0xf1a80b);
    [self addSubview:self.cash];
    
    [self setDefaultValue];
}

- (void)setData:(CUOrder *)data{
    
    _data = data;
    
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString * strSymbol = [locale objectForKey:NSLocaleCurrencySymbol];
    
    if (_data.service.doctor.price) {
            self.orderAmount.text = [NSString stringWithFormat:@"%@%.2f",strSymbol,(float)_data.service.doctor.price];
    }

    if (_data.coupon) {
            self.orderDiscount.text = [NSString stringWithFormat:@"-%@%.2f",strSymbol,(float)_data.coupon];
    }
    if (_data.dealPrice) {
            self.cash.text = [NSString stringWithFormat:@"%@%.2f",strSymbol,(float)_data.dealPrice];
    }
    
}

@end
