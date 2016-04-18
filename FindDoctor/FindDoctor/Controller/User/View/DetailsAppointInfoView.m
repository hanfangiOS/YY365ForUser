//
//  DetailsAppointInfoView.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/18.
//  Copyright © 2016年 li na. All rights reserved.
//

#define DetailsAppointInfoViewHeight 168

#import "DetailsAppointInfoView.h"
#import "HFTitleView.h"

@interface DetailsAppointInfoView()

@property (strong,nonatomic)HFTitleView * titleView;
@property (strong,nonatomic)UIView      * line;
@property (strong,nonatomic)UILabel     * clinicLabel;
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

//@property (strong,nonatomic)UIImageView * line;
//@property (strong,nonatomic)UILabel     * ClinicLabel;
//@property (strong,nonatomic)UILabel     * timeLabel;
//@property (strong,nonatomic)UILabel     * personLabel;
//@property (strong,nonatomic)UILabel     * addressLabel;
//@property (strong,nonatomic)UILabel     * time;
//@property (strong,nonatomic)UILabel     * person;
//@property (strong,nonatomic)UILabel     * address;
//@property (strong,nonatomic)UIImageView * arrow;

- (void)initSubViews{
    self.titleView = [[HFTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30) titleText:@"约诊信息" Style:HFTitleViewStyleLoadMore];
    self.titleView.pic.backgroundColor = [UIColor blueColor];
    self.titleView.loadMoreBtn.hidden = YES;
    self.titleView.title.textColor = [UIColor blackColor];
    [self addSubview:self.titleView];
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(10, 30, kScreenWidth - 10, 0.5)];
    self.line.backgroundColor = [UIColor blackColor];
    [self addSubview:self.line];
    
    self.clinicLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 42, 80, 20)];
    self.clinicLabel.text = @"爱心诊所";
    self.clinicLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.clinicLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.clinicLabel.frameX, self.clinicLabel.maxY + 15, 90, 18)];
    self.timeLabel.text = @"就诊时间:";
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.timeLabel];
    
    self.personLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.timeLabel.frameX, self.timeLabel.maxY + 15, 90, 18)];
    self.personLabel.text = @"就  诊  人:";
    self.personLabel.textAlignment = NSTextAlignmentLeft;
    self.personLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.personLabel];
    
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.personLabel.frameX, self.personLabel.maxY + 15, 90, 18)];
    self.addressLabel.text = @"就诊地址:";
    self.addressLabel.textAlignment = NSTextAlignmentLeft;
    self.addressLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.addressLabel];
    
    self.time = [[UILabel alloc] initWithFrame:CGRectMake(self.timeLabel.maxX + 4, self.timeLabel.frameY, kScreenWidth - self.timeLabel.maxX - 4 - 20, self.timeLabel.frameHeight)];
    self.time.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.time];
    
    self.time = [[UILabel alloc] initWithFrame:CGRectMake(self.timeLabel.maxX + 4, self.timeLabel.frameY, kScreenWidth - self.timeLabel.maxX - 4 - 20, self.timeLabel.frameHeight)];
    self.time.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.time];
    
    self.person = [[UILabel alloc] initWithFrame:CGRectMake(self.personLabel.maxX + 4, self.personLabel.frameY, kScreenWidth - self.personLabel.maxX - 4 - 20, self.personLabel.frameHeight)];
    self.person.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.person];
    
    self.address = [[UILabel alloc] initWithFrame:CGRectMake(self.addressLabel.maxX + 4, self.addressLabel.frameY, kScreenWidth - self.addressLabel.maxX - 4 - 20, self.addressLabel.frameHeight)];
    self.address.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.address];
    
    self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 20, self.clinicLabel.frameY, 20, 25)];
    self.arrow.image = [UIImage imageNamed:@""];
    [self addSubview:self.arrow];
    self.arrow.backgroundColor = [UIColor blackColor];
}

- (void)setData:(CUOrder *)data{
    _data = data;
    
//    self.time.text =
    self.person.text = [NSString stringWithFormat:@"%@      %d岁     %@",_data.service.patience.name,_data.service.patience.age,_data.service.patience.cellPhone];
    
    self.address.text = [NSString stringWithFormat:@"%@",_data.service.doctor.address];
}

@end
