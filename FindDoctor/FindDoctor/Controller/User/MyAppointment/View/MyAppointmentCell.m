//
//  MyAppointmentCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/18.
//  Copyright © 2016年 li na. All rights reserved.
//

#define MyAppointmentCellHeight 170

#import "MyAppointmentCell.h"
#import "UIImageView+WebCache.h"

@interface MyAppointmentCell ()

@property (strong,nonatomic)UIView  * headerView;
@property (strong,nonatomic)UILabel * name;
@property (strong,nonatomic)UILabel * time;
@property (strong,nonatomic)UIView  * line;

@property (strong,nonatomic)UIView          * infoView;
@property (strong,nonatomic)UIImageView     * icon;
@property (strong,nonatomic)UILabel         * price;
@property (strong,nonatomic)UILabel         * info;
@property (strong,nonatomic)UILabel         * address;
@property (strong,nonatomic)UIButton        * payBtn;
@property (strong,nonatomic)UIImageView     * arrow;

@end

@implementation MyAppointmentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubViews];
        return self;
    }
    return nil;
}

+ (float)defaultHeight{
    return MyAppointmentCellHeight;
}

- (void)initSubViews{
    //上面一块view
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    [self addSubview:self.headerView];
    //朱军 教授 主治医生
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(10,0,180 , self.headerView.frameHeight)];
    self.name.textColor = kLightGrayColor;
    self.name.font = [UIFont systemFontOfSize:12];
    self.name.textAlignment = NSTextAlignmentLeft;
    [self.headerView addSubview:self.name];
    //就诊完成
    self.time = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 40 - 60, 0, 40, self.headerView.frameHeight)];
    self.time.font = [UIFont systemFontOfSize:12];
    self.time.textAlignment = NSTextAlignmentRight;
    self.time.textColor = kLightGrayColor;
    [self.headerView addSubview:self.time];
    //线
    self.line = [[UIView alloc] initWithFrame:CGRectMake(10, self.headerView.frameHeight - 0.5, kScreenWidth - 10, 0.5)];
    self.line.backgroundColor = kLightLineColor;
    [self.headerView addSubview:self.line];
    //下面一块View 约诊人各种信息
    self.infoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.maxY, kScreenWidth, MyAppointmentCellHeight - self.headerView.frameHeight)];
    [self addSubview:self.infoView];
    //头像
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 72, 72)];
    self.icon.layer.cornerRadius = 5.0f;
    [self.infoView addSubview:self.icon];
    self.icon.backgroundColor = [UIColor blueColor];
    //¥100
    self.price = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.maxX + 15, 14, kScreenWidth - self.icon.maxX - 15 - 30, 22)];
    self.price.textColor = [UIColor orangeColor];
    self.price.font = [UIFont systemFontOfSize:20];
    [self.infoView addSubview:self.price];
    //罗威 1111-11-11 11:11
    self.info = [[UILabel alloc] initWithFrame:CGRectMake(self.price.frameX, self.price.maxY + 4, kScreenWidth - self.price.frameX - 30, 20)];
    self.info.textColor = kLightGrayColor;
    self.info.font = [UIFont systemFontOfSize:12];
    [self.infoView addSubview:self.info];
    //成都市青羊区金阳路358号
    self.address = [[UILabel alloc] initWithFrame:CGRectMake(self.info.frameX, self.info.maxY + 2, self.info.frameWidth, self.info.frameHeight)];
    self.address.textColor = kLightGrayColor;
    self.address.font = [UIFont systemFontOfSize:12];
    [self.infoView addSubview:self.address];
    //立即支付
    self.payBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.address.frameX, self.address.maxY + 10, 80, 25)];
    [self.payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    self.payBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    self.payBtn.backgroundColor = [UIColor orangeColor];
    [self.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.payBtn.layer.cornerRadius = 2.0f;
    [self.infoView addSubview:self.payBtn];
    //箭头
    self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 25 - 2, (self.infoView.frameHeight - 25)/2, 20, 25)];
    self.arrow.image = [UIImage imageNamed:@""];
    [self.infoView addSubview:self.arrow];
    self.arrow.backgroundColor = [UIColor greenColor];
    
}

- (void)setData:(CUOrder *)data{
    _data = data;
  
    NSString * string = [NSString stringWithFormat:@"%@  %@  %@",_data.service.doctor.name,_data.service.doctor.levelDesc,_data.service.doctor.grade];
    NSMutableAttributedString * AtrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSInteger length = [_data.service.doctor.name length];
    [AtrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, length)];
    [AtrStr addAttribute:NSForegroundColorAttributeName
                   value:[UIColor blackColor]
                   range:NSMakeRange(0, length)];
    self.name.attributedText = AtrStr;
    
    self.time.text = _data.submitTimeString;
    
    [self.icon setImageWithURL:[NSURL URLWithString:_data.service.doctor.avatar]];
    
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString * strSymbol = [locale objectForKey:NSLocaleCurrencySymbol];
    self.price.text = [NSString stringWithFormat:@"%@%lld",strSymbol,_data.dealPrice];
    
    NSString * diagnosisTimeStr = [[NSDate dateWithTimeIntervalSince1970:_data.service.doctor.diagnosisTime] stringWithDateFormat:@"yyyy-MM-dd HH:mm"];
    self.info.text = [NSString stringWithFormat:@"%@  %@",_data.service.patience.name,diagnosisTimeStr];
    
    self.address.text = [NSString stringWithFormat:@"%@",_data.service.doctor.address];
}

- (void)payAction{
    if (self.clickPayBtn) {
        self.clickPayBtn();
    }
}


@end
