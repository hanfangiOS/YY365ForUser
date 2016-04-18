//
//  DetailsOrderInfoView.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/18.
//  Copyright © 2016年 li na. All rights reserved.
//

#define DetailsOrderInfoViewHeight 165

#import "DetailsOrderInfoView.h"
#import "HFTitleView.h"

@interface DetailsOrderInfoView ()

@property (strong,nonatomic)HFTitleView * titleView;
@property (strong,nonatomic)UIView      * line;
@property (strong,nonatomic)UILabel     * orderNumLabel;
@property (strong,nonatomic)UILabel     * orderTimeLabel;
@property (strong,nonatomic)UILabel     * orderStatusLabel;
@property (strong,nonatomic)UILabel     * paymentLabel;
@property (strong,nonatomic)UILabel     * orderNum;
@property (strong,nonatomic)UILabel     * orderTime;
@property (strong,nonatomic)UILabel     * orderStatus;
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
    self.titleView.pic.backgroundColor = [UIColor blueColor];
    self.titleView.loadMoreBtn.hidden = YES;
    self.titleView.title.textColor = [UIColor blackColor];
    [self addSubview:self.titleView];
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(10, 30, kScreenWidth - 10, 0.5)];
    self.line.backgroundColor = [UIColor blackColor];
    [self addSubview:self.line];
    
    self.orderNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 42, 80, 18)];
    self.orderNumLabel.text = @"订  单  号:";
    self.orderNumLabel.textAlignment = NSTextAlignmentLeft;
    self.orderNumLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.orderNumLabel];
    self.orderNumLabel.backgroundColor = [UIColor redColor];
    
    self.orderTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.orderNumLabel.maxY + 10, 80, 18)];
    self.orderTimeLabel.text = @"订单时间:";
    self.orderTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.orderTimeLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.orderTimeLabel];
    self.orderTimeLabel.backgroundColor = [UIColor brownColor];
    
    self.orderStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.orderTimeLabel.maxY + 10, 80, 18)];
    self.orderStatusLabel.text = @"订单状态:";
    self.orderStatusLabel.textAlignment = NSTextAlignmentLeft;
    self.orderStatusLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.orderStatusLabel];
    self.orderStatusLabel.backgroundColor = [UIColor brownColor];
    
    self.paymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.orderStatusLabel.maxY + 10, 80, 18)];
    self.paymentLabel.text = @"支付方式:";
    self.paymentLabel.textAlignment = NSTextAlignmentLeft;
    self.paymentLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.paymentLabel];
    self.paymentLabel.backgroundColor = [UIColor brownColor];
    
    self.orderNum = [[UILabel alloc] initWithFrame:CGRectMake(self.orderNumLabel.maxX + 10, self.orderNumLabel.frameY, kScreenWidth - self.orderNumLabel.maxX - 20, 18)];
    self.orderNum.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.orderNum];
    
    self.orderTime = [[UILabel alloc] initWithFrame:CGRectMake(self.orderTimeLabel.maxX + 10, self.orderTimeLabel.frameY, kScreenWidth - self.orderTimeLabel.maxX - 20, 18)];
    self.orderTime.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.orderTime];
    
    self.orderStatus = [[UILabel alloc] initWithFrame:CGRectMake(self.orderStatusLabel.maxX + 10, self.orderStatusLabel.frameY, kScreenWidth - self.orderStatusLabel.maxX - 20, 18)];
    self.orderStatus.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.orderStatus];
    self.orderStatus.textColor = [UIColor orangeColor];
    
    self.payment = [[UILabel alloc] initWithFrame:CGRectMake(self.paymentLabel.maxX + 10, self.paymentLabel.frameY, kScreenWidth - self.paymentLabel.maxX - 20, 18)];
    self.payment.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.payment];
    self.payment.textColor = [UIColor orangeColor];
}

- (void)setData:(CUOrder *)data{
    
    _data = data;
    
    self.orderNum.text = [NSString stringWithFormat:@"%lld",_data.diagnosisID];
    
    self.orderTime.text = [[NSDate dateWithTimeIntervalSince1970: _data.submitTime]stringWithDateFormat:@"yyyy-MM-dd HH:mm"];
    
    switch (_data.orderStatus) {
        case ORDERSTATUS_UNPAID:
        {
            self.orderStatus.text = @"未支付";
        }
            break;
        case ORDERSTATUS_PAID:
        {
            self.orderStatus.text = @"已支付";
        }
            break;
        case ORDERSTATUS_FINISHED:
        {
            self.orderStatus.text = @"已开方";
        }
            break;
        case ORDERSTATUS_CANCELED:
        {
            self.orderStatus.text = @"已打印";
        }
            break;
        case ORDERSTATUS_REFUNDED:
        {
            self.orderStatus.text = @"已评论";
        }
            break;
        default:
            break;
    }
    
    if (_data.payment == ORDERPAYMENT_ZhiFuBao) {
        self.payment.text = @"支付宝";
    }else if (_data.payment == ORDERPAYMENT_WeiXin){
        self.payment.text = @"微信";
    }else if (_data.payment == ORDERPAYMENT_YinLian){
        self.payment.text = @"银联";
    }else if (!_data.payment){
        self.payment.text = @"未支付";
    }
    
}

@end
