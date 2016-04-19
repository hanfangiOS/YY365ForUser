//
//  DetailsPaymentInfoView.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/18.
//  Copyright © 2016年 li na. All rights reserved.
//
#define DetailsPaymentInfoViewHeight 160

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

//@property (strong,nonatomic)HFTitleView * titleView;
//@property (strong,nonatomic)UIView * line1;
//@property (strong,nonatomic)UIView * line2;
//@property (strong,nonatomic)UILabel * orderAmountLabel;
//@property (strong,nonatomic)UILabel * orderDiscountLabel;
//@property (strong,nonatomic)UILabel * cashLabel;
//@property (strong,nonatomic)UILabel * orderAmount;
//@property (strong,nonatomic)UILabel * orderDiscount;
//@property (strong,nonatomic)UILabel * cash;

- (void)initSubViews{
    
    self.titleView = [[HFTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30) titleText:@"支付信息" Style:HFTitleViewStyleLoadMore];
    self.titleView.pic.backgroundColor = [UIColor blueColor];
    self.titleView.loadMoreBtn.hidden = YES;
    self.titleView.title.textColor = [UIColor blackColor];
    [self addSubview:self.titleView];
    
    self.line1 = [[UIView alloc] initWithFrame:CGRectMake(10, 30, kScreenWidth - 10, 0.5)];
    self.line1.backgroundColor = [UIColor blackColor];
    [self addSubview:self.line1];
    
    self.orderAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 42, 80, 18)];
    self.orderAmountLabel.text = @"订单总额:";
    self.orderAmountLabel.textAlignment = NSTextAlignmentLeft;
    self.orderAmountLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.orderAmountLabel];
    self.orderAmountLabel.backgroundColor = [UIColor redColor];
    
    self.orderDiscountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.orderAmountLabel.maxY + 10, 80, 18)];
    self.orderDiscountLabel.text = @"订  金  券:";
    self.orderDiscountLabel.textAlignment = NSTextAlignmentLeft;
    self.orderDiscountLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.orderDiscountLabel];
     self.orderDiscountLabel.backgroundColor = [UIColor brownColor];
    
    self.line2 = [[UIView alloc] initWithFrame:CGRectMake(10, self.orderDiscountLabel.maxY + 10, kScreenWidth - 10, 0.5)];
    self.line2.backgroundColor = [UIColor blackColor];
    [self addSubview:self.line2];
    
    self.cashLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.line2.maxY + 15, 80, 18)];
    self.cashLabel.text = @"现金支付:";
    self.cashLabel.textAlignment = NSTextAlignmentLeft;
    self.cashLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.cashLabel];
     self.cashLabel.backgroundColor = [UIColor grayColor];
    
    self.orderAmount = [[UILabel alloc] initWithFrame:CGRectMake(self.orderAmountLabel.maxX + 20, self.orderAmountLabel.frameY, kScreenWidth - self.orderAmountLabel.maxX - 20, self.orderAmountLabel.frameHeight)];
    self.orderAmount.textAlignment = NSTextAlignmentRight;
    self.orderAmount.font = [UIFont systemFontOfSize:18];
    [self addSubview:self.orderAmount];
     self.orderAmount.backgroundColor = [UIColor greenColor];
    
    self.orderDiscount = [[UILabel alloc] initWithFrame:CGRectMake(self.orderDiscountLabel.maxX + 20, self.orderDiscountLabel.frameY, kScreenWidth - self.orderDiscountLabel.maxX - 20, self.orderDiscountLabel.frameHeight)];
    self.orderDiscount.textAlignment = NSTextAlignmentRight;
    self.orderDiscount.font = [UIFont systemFontOfSize:18];
    [self addSubview:self.orderDiscount];
     self.orderDiscount.backgroundColor = [UIColor blueColor];
    
    self.cash = [[UILabel alloc] initWithFrame:CGRectMake(self.cashLabel.maxX + 20, self.cashLabel.frameY - 7, kScreenWidth - self.cashLabel.maxX - 20, 25)];
    self.cash.textAlignment = NSTextAlignmentRight;
    self.cash.font = [UIFont systemFontOfSize:21];
    self.cash.textColor = [UIColor orangeColor];
    [self addSubview:self.cash];
     self.cash.backgroundColor = [UIColor yellowColor];
    
}

- (void)setData:(CUOrder *)data{
    
}

@end
