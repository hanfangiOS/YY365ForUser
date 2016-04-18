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
    self.line.backgroundColor = [UIColor blackColor];
    
    self.beginTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 80, 18)];
    self.beginTimeLabel.text = @"接诊时间:";
    self.beginTimeLabel.backgroundColor = [UIColor redColor];
    self.beginTimeLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.beginTimeLabel];
    
    self.finishTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,self.beginTimeLabel.maxY + 12, 80, 18)];
    self.finishTimeLabel.text = @"完诊时间:";
    self.finishTimeLabel.backgroundColor = [UIColor redColor];
    self.finishTimeLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.finishTimeLabel];
    
    self.beiginTime = [[UILabel alloc] initWithFrame:CGRectMake(self.beginTimeLabel.maxX + 10, self.beginTimeLabel.frameY, kScreenWidth - self.beginTimeLabel.maxX - 10 - 20, 18)];
    self.beiginTime.textColor = [UIColor blueColor];
    self.beiginTime.backgroundColor = [UIColor redColor];
    self.beiginTime.font = [UIFont systemFontOfSize:15];
    self.beiginTime.textColor = [UIColor blueColor];
    [self addSubview:self.beiginTime];
    
    self.finishTime = [[UILabel alloc] initWithFrame:CGRectMake(self.finishTimeLabel.maxX + 10, self.finishTimeLabel.frameY, kScreenWidth - self.finishTimeLabel.maxX - 10 - 20, 18)];
    self.finishTime.textColor = [UIColor blueColor];
    self.finishTime.backgroundColor = [UIColor redColor];
    self.finishTime.font = [UIFont systemFontOfSize:15];
    self.finishTime.textColor = [UIColor blueColor];
    [self addSubview:self.finishTime];
}

- (void)setData:(CUOrder *)data{

    _data = data;
}

@end
