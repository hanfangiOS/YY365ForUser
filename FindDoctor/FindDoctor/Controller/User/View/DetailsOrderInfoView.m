//
//  DetailsOrderInfoView.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/18.
//  Copyright © 2016年 li na. All rights reserved.
//

#define DetailsOrderInfoViewHeight 150

#import "DetailsOrderInfoView.h"
#import "HFTitleView.h"

@interface DetailsOrderInfoView ()

@property (strong,nonatomic)HFTitleView * titleView;
@property (strong,nonatomic)UIView      * line;
@property (strong,nonatomic)UILabel     * orderNumLabel;
@property (strong,nonatomic)UILabel     * orderTimeLabel;
@property (strong,nonatomic)UILabel     * orderStateLabel;
@property (strong,nonatomic)UILabel     * paymentLabel;
@property (strong,nonatomic)UILabel     * orderNum;
@property (strong,nonatomic)UILabel     * orderTime;
@property (strong,nonatomic)UILabel     * orderState;
@property (strong,nonatomic)UILabel     * payment;

@end

@implementation DetailsOrderInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        return self;
    }
    return nil;
}

+ (float)defaultHeight{
    
    return DetailsOrderInfoViewHeight;
}

- (void)initSubViews{
    self.titleView = [[HFTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30) titleText:@"订单信息" Style:HFTitleViewStyleLoadMore];
    self.titleView.pic.backgroundColor = UIColorFromHex(Color_Hex_NavBackground);
    self.titleView.loadMoreBtn.hidden = YES;
    self.titleView.title.font = [UIFont systemFontOfSize:12];
    self.titleView.title.textColor = [UIColor blackColor];
    [self addSubview:self.titleView];
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(10, 30, kScreenWidth - 10, 0.5)];
    self.line.backgroundColor = kLightLineColor;
    [self addSubview:self.line];
    
    self.orderNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 42, 60, 18)];
    self.orderNumLabel.text = @"订  单  号:";
    self.orderNumLabel.textAlignment = NSTextAlignmentLeft;
    self.orderNumLabel.font = [UIFont systemFontOfSize:12];
    self.orderNumLabel.textColor = kLightGrayColor;
    [self addSubview:self.orderNumLabel];
    
    self.orderTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.orderNumLabel.maxY + 10, 60, 18)];
    self.orderTimeLabel.text = @"订单时间:";
     self.orderTimeLabel.textColor = kLightGrayColor;
    self.orderTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.orderTimeLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.orderTimeLabel];
    
    self.orderStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.orderTimeLabel.maxY + 10, 60, 18)];
    self.orderStateLabel.text = @"订单状态:";
     self.orderStateLabel.textColor = kLightGrayColor;
    self.orderStateLabel.textAlignment = NSTextAlignmentLeft;
    self.orderStateLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.orderStateLabel];
    
    self.paymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.orderStateLabel.maxY + 10, 60, 18)];
    self.paymentLabel.text = @"支付方式:";
     self.paymentLabel.textColor = kLightGrayColor;
    self.paymentLabel.textAlignment = NSTextAlignmentLeft;
    self.paymentLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.paymentLabel];
    
    self.orderNum = [[UILabel alloc] initWithFrame:CGRectMake(self.orderNumLabel.maxX + 2, self.orderNumLabel.frameY, kScreenWidth - self.orderNumLabel.maxX - 2 - 12, 18)];
    self.orderNum.textAlignment = NSTextAlignmentLeft;
        self.orderNum.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.orderNum];
    
    self.orderTime = [[UILabel alloc] initWithFrame:CGRectMake(self.orderTimeLabel.maxX + 2, self.orderTimeLabel.frameY, kScreenWidth - self.orderTimeLabel.maxX - 2 -12, 18)];
        self.orderTime.font = [UIFont systemFontOfSize:12];
    self.orderTime.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.orderTime];
    
    self.orderState = [[UILabel alloc] initWithFrame:CGRectMake(self.orderStateLabel.maxX + 2, self.orderStateLabel.frameY, kScreenWidth - self.orderStateLabel.maxX - 2 - 12, 18)];
        self.orderState.font = [UIFont systemFontOfSize:12];
    self.orderState.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.orderState];
    self.orderState.textColor = [UIColor orangeColor];
    
    self.payment = [[UILabel alloc] initWithFrame:CGRectMake(self.paymentLabel.maxX + 2, self.paymentLabel.frameY, kScreenWidth - self.paymentLabel.maxX - 2 - 12, 18)];
    self.payment.textAlignment = NSTextAlignmentLeft;
        self.payment.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.payment];
    self.payment.textColor = [UIColor orangeColor];
}

- (void)setData:(CUOrder *)data{
    
    _data = data;
    
    self.orderNum.text = [NSString stringWithFormat:@"%lld",_data.diagnosisID];
    
    self.orderTime.text = [[NSDate dateWithTimeIntervalSince1970: _data.submitTime]stringWithDateFormat:@"yyyy-MM-dd  HH:mm"];
    
    self.orderState.text = [_data orderStatusStr];

    self.payment.text = [_data orderPaymentStr];
    
}

@end
