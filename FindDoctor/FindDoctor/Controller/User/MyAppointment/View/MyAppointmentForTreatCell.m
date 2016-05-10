//
//  MyAppointmentForTreatCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/29.
//  Copyright © 2016年 li na. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import "MyAppointmentForTreatCell.h"

#define MyAppointmentForTreatCellHeight 135



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

- (void)initSubViews{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    [self addSubview:self.headerView];
    
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(10,0,180 , self.headerView.frameHeight)];
    self.name.textColor = kLightGrayColor;
    self.name.font = [UIFont systemFontOfSize:12];
    self.name.textAlignment = NSTextAlignmentLeft;
    [self.headerView addSubview:self.name];
    
    self.time = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 40 - 60, 0, 40, self.headerView.frameHeight)];
    self.time.font = [UIFont systemFontOfSize:12];
    self.time.textAlignment = NSTextAlignmentRight;
    self.time.textColor = kLightGrayColor;
    [self.headerView addSubview:self.time];
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(10, self.headerView.frameHeight - 0.5, kScreenWidth - 10, 0.5)];
    self.line.backgroundColor = kLightLineColor;
    [self.headerView addSubview:self.line];
    
    self.infoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.maxY, kScreenWidth, MyAppointmentForTreatCellHeight - self.headerView.frameHeight)];
    [self addSubview:self.infoView];
    
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 72, 72)];
    self.icon.layer.cornerRadius = 5.0f;
    [self.infoView addSubview:self.icon];
    self.icon.backgroundColor = [UIColor blueColor];
    
    self.price = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.maxX + 15, 14, kScreenWidth - self.icon.maxX - 15 - 30, 22)];
    self.price.textColor = [UIColor orangeColor];
    self.price.font = [UIFont systemFontOfSize:20];
    [self.infoView addSubview:self.price];
    
    self.info = [[UILabel alloc] initWithFrame:CGRectMake(self.price.frameX, self.price.maxY + 4, kScreenWidth - self.price.frameX - 30, 20)];
    self.info.textColor = kLightGrayColor;
    self.info.font = [UIFont systemFontOfSize:12];
    [self.infoView addSubview:self.info];
    
    self.address = [[UILabel alloc] initWithFrame:CGRectMake(self.info.frameX, self.info.maxY + 2, self.info.frameWidth, self.info.frameHeight)];
    self.address.textColor = kLightGrayColor;
    self.address.font = [UIFont systemFontOfSize:12];
    [self.infoView addSubview:self.address];
    
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


@end
