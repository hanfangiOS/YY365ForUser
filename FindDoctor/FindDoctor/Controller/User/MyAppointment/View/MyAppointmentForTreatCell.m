//
//  MyAppointmentForTreatCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/29.
//  Copyright © 2016年 li na. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import "MyAppointmentForTreatCell.h"

#define MyAppointmentForTreatCellHeight 120



@interface MyAppointmentForTreatCell ()

@property (strong,nonatomic)UIView  * headerView;
@property (strong,nonatomic)UILabel * name;
@property (strong,nonatomic)UILabel * time;
@property (strong,nonatomic)UIView  * line;

@property (strong,nonatomic)UIView          * infoView;
@property (strong,nonatomic)UIImageView     * icon;
@property (strong,nonatomic)UILabel         * price;
@property (strong,nonatomic)UILabel         * info;
@property (strong,nonatomic)UILabel         * address;
@property (strong,nonatomic)UIImageView     * arrow;

@end

@implementation MyAppointmentForTreatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubViews];
        return self;
    }
    return nil;
}

+ (float)kDefaultHeight{
    return MyAppointmentForTreatCellHeight;
}

- (void)setDefaultValue{
    self.name.text = @"－－";
    self.price.text = @"－－";
    self.info.text = @"－－";
    self.address.text = @"－－";
}

- (void)initSubViews{
    //上面一块view
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 33)];
    [self addSubview:self.headerView];
    //朱军 教授 主治医生
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(10,0,180 , self.headerView.frameHeight)];
    self.name.textColor = kLightGrayColor;
    self.name.font = [UIFont systemFontOfSize:12];
    self.name.textAlignment = NSTextAlignmentLeft;
    [self.headerView addSubview:self.name];
    //线
    self.line = [[UIView alloc] initWithFrame:CGRectMake(8, self.headerView.frameHeight - 1, kScreenWidth - 8, 1)];
    self.line.backgroundColor = kLightLineColor;
    [self.headerView addSubview:self.line];
    //下面一块View 约诊人各种信息
    self.infoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.maxY, kScreenWidth, MyAppointmentForTreatCellHeight - self.headerView.frameHeight)];
    [self addSubview:self.infoView];
    //头像
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 58, 58)];
    self.icon.layer.cornerRadius = 5.0f;
    [self.infoView addSubview:self.icon];
    //¥100
    self.price = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.maxX + 15, self.icon.frameY + 4, kScreenWidth - self.icon.maxX - 15 - 30, 15)];
    self.price.textColor = UIColorFromHex(0xf1a90e);
    self.price.font = [UIFont systemFontOfSize:18];
    [self.infoView addSubview:self.price];
    //罗威 1111-11-11 11:11
    self.info = [[UILabel alloc] initWithFrame:CGRectMake(self.price.frameX, self.price.maxY + 9, kScreenWidth - self.price.frameX - 30, 12)];
    self.info.textColor = kLightGrayColor;
    self.info.font = [UIFont systemFontOfSize:12];
    [self.infoView addSubview:self.info];
    //成都市青羊区金阳路358号
    self.address = [[UILabel alloc] initWithFrame:CGRectMake(self.info.frameX, self.info.maxY + 6, self.info.frameWidth, self.info.frameHeight)];
    self.address.textColor = kLightGrayColor;
    self.address.font = [UIFont systemFontOfSize:12];
    [self.infoView addSubview:self.address];
    
    //箭头
    self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 9 - 4, (self.infoView.frameHeight - 15)/2, 9, 15)];
    self.arrow.image = [UIImage imageNamed:@"common_icon_grayArrow@2x"];
    [self.infoView addSubview:self.arrow];
    
    //上线
    UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    topLine.backgroundColor = kblueLineColor;
    [self addSubview: topLine];
    //下线
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    bottomLine.backgroundColor = kblueLineColor;
    [self addSubview: bottomLine];
    
    [self setDefaultValue];
}

- (void)setData:(CUOrder *)data{
    _data = data;
    
    if (_data.service.doctor.name && _data.service.doctor.levelDesc && _data.service.doctor.grade) {
        NSString * string = [NSString stringWithFormat:@"%@  %@  %@",_data.service.doctor.name,_data.service.doctor.levelDesc,_data.service.doctor.grade];
        NSMutableAttributedString * AtrStr = [[NSMutableAttributedString alloc] initWithString:string];
        NSInteger length = [_data.service.doctor.name length];
        [AtrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, length)];
        [AtrStr addAttribute:NSForegroundColorAttributeName
                       value:[UIColor blackColor]
                       range:NSMakeRange(0, length)];
        self.name.attributedText = AtrStr;
    }
    
    if (_data.submitTimeString) {
        self.time.text = _data.submitTimeString;
    }
    
    [self.icon setImageWithURL:[NSURL URLWithString:_data.service.doctor.avatar] placeholderImage:[UIImage imageNamed:@"temp_icon_doctor.jpg"]];
    
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString * strSymbol = [locale objectForKey:NSLocaleCurrencySymbol];
    
    if (_data.dealPrice) {
        self.price.text = [NSString stringWithFormat:@"%@%lld",strSymbol,_data.dealPrice];
    }
    
    if (_data.service.doctor.diagnosisTime) {
        NSString * diagnosisTimeStr = [[NSDate dateWithTimeIntervalSince1970:_data.service.doctor.diagnosisTime] stringWithDateFormat:@"yyyy-MM-dd HH:mm"];
        self.info.text = [NSString stringWithFormat:@"%@  %@",_data.service.patience.name,diagnosisTimeStr];
    }
    
    if (_data.service.doctor.address) {
        self.address.text = [NSString stringWithFormat:@"%@",_data.service.doctor.address];
    }
    
}


@end
