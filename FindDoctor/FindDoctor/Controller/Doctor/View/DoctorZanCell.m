//
//  DoctorZanCell.m
//  FindDoctor
//
//  Created by chai on 15/8/31.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "DoctorZanCell.h"

@interface DoctorZanCell ()
{
    UIImageView *_zanIconView;
    UILabel *_zanCountLabel;
    UILabel *_zanNameLabel;
}

@end

@implementation DoctorZanCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    float repair_interval = 5;
    
    float icon_width = 40.f;
    
    _zanIconView = [[UIImageView alloc] init];
    _zanIconView.frame = CGRectMake(0, repair_interval, icon_width, icon_width);
    [self.contentView addSubview:_zanIconView];
    
    float count_width = 20.f;
    
    _zanCountLabel = [[UILabel alloc] init];
    _zanCountLabel.textColor = [UIColor whiteColor];
    _zanCountLabel.font = kAnnotationFont;
    _zanCountLabel.textAlignment = NSTextAlignmentCenter;
    _zanCountLabel.frame = CGRectMake(self.bounds.size.width-count_width, 0, count_width, count_width);
    _zanCountLabel.backgroundColor = kYellowColor;
    _zanCountLabel.layer.cornerRadius = count_width/2.f;
    _zanCountLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_zanCountLabel];
    
    _zanNameLabel = [[UILabel alloc] init];
    _zanNameLabel.textAlignment = NSTextAlignmentCenter;
    _zanNameLabel.frame = CGRectMake(0, CGRectGetMaxY(_zanIconView.frame), self.bounds.size.width, self.frame.size.height-CGRectGetMaxY(_zanIconView.frame));
    _zanNameLabel.font = kCommonDescFont;
    _zanNameLabel.textColor = kBlackColor;
    [self.contentView addSubview:_zanNameLabel];
    
    [self setContentView];
}

- (void)setContentView
{
    _zanIconView.image = [UIImage imageNamed:@"praise_zan_pic.png"];
    _zanCountLabel.text = @"12";
    _zanNameLabel.text = @"风之子";
}

@end
