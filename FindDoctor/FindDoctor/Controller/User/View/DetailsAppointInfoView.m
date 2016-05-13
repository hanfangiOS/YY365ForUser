//
//  DetailsAppointInfoView.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/18.
//  Copyright © 2016年 li na. All rights reserved.
//

#define DetailsAppointInfoViewHeight 145

#import "DetailsAppointInfoView.h"
#import "HFTitleView.h"

@interface DetailsAppointInfoView()

@property (strong,nonatomic)HFTitleView * titleView;
@property (strong,nonatomic)UIView      * line;
@property (strong,nonatomic)UILabel     * clinic;
@property (strong,nonatomic)UILabel     * timeLabel;
@property (strong,nonatomic)UILabel     * personLabel;
@property (strong,nonatomic)UILabel     * addressLabel;
@property (strong,nonatomic)UILabel     * time;
@property (strong,nonatomic)UILabel     * person;
@property (strong,nonatomic)UILabel     * address;
@property (strong,nonatomic)UIImageView * arrow;

@end

@implementation DetailsAppointInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        return self;
    }
    return nil;
}

+ (float)defaultHeight{
    
    return DetailsAppointInfoViewHeight;
}

- (void)setDefaultValue{
    self.clinic.text = @"－－";
    self.time.text = @"－－";
    self.person.text = @"－－";
    self.address.text = @"－－";
}

- (void)initSubViews{
    self.titleView = [[HFTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 27) titleText:@"约诊信息" Style:HFTitleViewStyleLoadMore];
    self.titleView.pic.backgroundColor = UIColorFromHex(Color_Hex_NavBackground);
    self.titleView.loadMoreBtn.hidden = YES;
    self.titleView.title.font = [UIFont systemFontOfSize:12];
    self.titleView.title.textColor = [UIColor blackColor];
    [self addSubview:self.titleView];
    //线
    self.line = [[UIView alloc] initWithFrame:CGRectMake(8, 26, kScreenWidth - 10, 1)];
    self.line.backgroundColor = kblueLineColor;
    [self addSubview:self.line];
    //三仙堂诊所
    self.clinic = [[UILabel alloc] initWithFrame:CGRectMake(10, self.titleView.maxY + 14, kScreenWidth - 30, 15)];
    self.clinic.font = [UIFont systemFontOfSize:17];
    self.clinic.textColor = [UIColor blackColor];
    self.clinic.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.clinic];
    //就诊时间
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.clinic.frameX, self.clinic.maxY + 18, 60, 12)];
    self.timeLabel.text = @"就诊时间 :";
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.timeLabel];
    //就诊人
    self.personLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.timeLabel.frameX, self.timeLabel.maxY + 12, 60, 12)];
    self.personLabel.text = @"就  诊  人 :";
    self.personLabel.textAlignment = NSTextAlignmentLeft;
    self.personLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.personLabel];
    //就诊地址
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.personLabel.frameX, self.personLabel.maxY + 12, 60, 12)];
    self.addressLabel.text = @"就诊地址 :";
    self.addressLabel.textAlignment = NSTextAlignmentLeft;
    self.addressLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.addressLabel];
    //1111-11-11 11:11
    self.time = [[UILabel alloc] initWithFrame:CGRectMake(self.timeLabel.maxX + 2, self.timeLabel.frameY, kScreenWidth - self.timeLabel.maxX - 2 - 20, self.timeLabel.frameHeight)];
    self.time.font = [UIFont systemFontOfSize:12];
    self.time.textColor = kGrayTextColor;
    self.time.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.time];
    //罗威
    self.person = [[UILabel alloc] initWithFrame:CGRectMake(self.personLabel.maxX + 2, self.personLabel.frameY, kScreenWidth - self.personLabel.maxX - 2 - 20, self.personLabel.frameHeight)];
    self.person.font = [UIFont systemFontOfSize:12];
    self.person.textColor = kGrayTextColor;
    self.person.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.person];
    //成都市青羊区金阳路358号
    self.address = [[UILabel alloc] initWithFrame:CGRectMake(self.addressLabel.maxX + 2, self.addressLabel.frameY, kScreenWidth - self.addressLabel.maxX - 2 - 20, self.addressLabel.frameHeight)];
    self.address.font = [UIFont systemFontOfSize:12];
    self.address.textColor = kGrayTextColor;
    self.address.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.address];
    //箭头
    self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 9 - 4, self.clinic.frameY - 1, 9, 15)];
    self.arrow.image = [UIImage imageNamed:@"common_icon_grayArrow@2x"];
    [self addSubview:self.arrow];
    
    [self setDefaultValue];
}

- (void)setData:(CUOrder *)data{
    _data = data;
    
    if (_data.service.doctor.clinicName) {
        self.clinic.text = _data.service.doctor.clinicName;
    }
    
    if (_data.service.doctor.diagnosisTime) {
        self.time.text = [[NSDate dateWithTimeIntervalSince1970:_data.service.doctor.diagnosisTime] stringWithDateFormat:@"yyyy-mm-dd hh:mm"];
    }
    
    if (_data.service.patience.age && _data.service.patience.cellPhone) {
        self.person.text = [NSString stringWithFormat:@"%@  %ld岁  %@",_data.service.patience.name,(long)_data.service.patience.age,_data.service.patience.cellPhone];
    }
    
    if (_data.service.doctor.address) {
        self.address.text = [NSString stringWithFormat:@"%@",_data.service.doctor.address];
    }
    
}

@end
