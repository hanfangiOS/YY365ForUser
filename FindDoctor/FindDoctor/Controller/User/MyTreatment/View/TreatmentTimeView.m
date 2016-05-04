//
//  TreatmentTimeView.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/19.
//  Copyright © 2016年 li na. All rights reserved.
//

#define TreatmentTimeViewHeight 75

#import "TreatmentTimeView.h"

@interface TreatmentTimeView ()

@property (strong,nonatomic)UIView   * line;
@property (strong,nonatomic)UILabel  * beginTimeLabel;
@property (strong,nonatomic)UILabel  * finishTimeLabel;
@property (strong,nonatomic)UILabel  * beiginTime;
@property (strong,nonatomic)UILabel  * finishTime;


@end

@implementation TreatmentTimeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        return self;
    }
    return nil;
}

+ (float)defaultHeight{
    
    return TreatmentTimeViewHeight;
}

- (void)initSubViews{
    self.line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 10, 0.5)];
    [self addSubview:self.line];
    self.line.backgroundColor = kLightLineColor;
    
    self.beginTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 60, 18)];
    self.beginTimeLabel.text = @"接诊时间:";
    self.beginTimeLabel.textColor = kLightGrayColor;
    self.beginTimeLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.beginTimeLabel];
    
    self.finishTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,self.beginTimeLabel.maxY + 12, 60, 18)];
    self.finishTimeLabel.text = @"完诊时间:";
    self.finishTimeLabel.textColor = kLightGrayColor;
    self.finishTimeLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.finishTimeLabel];
    
    self.beiginTime = [[UILabel alloc] initWithFrame:CGRectMake(self.beginTimeLabel.maxX + 10, self.beginTimeLabel.frameY, kScreenWidth - self.beginTimeLabel.maxX - 10 - 12, 18)];
    self.beiginTime.font = [UIFont systemFontOfSize:12];
    self.beiginTime.textColor = kLightGrayColor;
    [self addSubview:self.beiginTime];
    
    self.finishTime = [[UILabel alloc] initWithFrame:CGRectMake(self.finishTimeLabel.maxX + 10, self.finishTimeLabel.frameY, kScreenWidth - self.finishTimeLabel.maxX - 10 - 12, 18)];
    self.finishTime.font = [UIFont systemFontOfSize:12];
    self.finishTime.textColor = kLightGrayColor;
    [self addSubview:self.finishTime];
}

- (void)setData:(CUOrder *)data{

    _data = data;
    
    self.beiginTime.text = [[NSDate dateWithTimeIntervalSince1970:_data.service.doctor.diagnosisTime] stringWithDateFormat:@"yyyy-mm-dd hh:mm"];
    
    self.finishTime.text = [[NSDate dateWithTimeIntervalSince1970:_data.finishedTimeStamp] stringWithDateFormat:@"yyyy-mm-dd hh:mm"];
}

@end
