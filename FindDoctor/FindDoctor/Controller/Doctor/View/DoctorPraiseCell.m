//
//  DoctorPraiseCell.m
//  FindDoctor
//
//  Created by chai on 15/8/28.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "DoctorPraiseCell.h"

@interface DoctorPraiseCell ()
{
    UIImageView *_iconView;
    UILabel *_contentLabel;
    UILabel *_doctorLabel;
    UILabel *_dateLabel;
}

@end

@implementation DoctorPraiseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    float margin_left = 12;
    float margin_top = 12;
    float icon_width = 35.f;
    float interval_x = 12;
    float interval_y = 8.f;
    
    _iconView = [[UIImageView alloc] init];
    _iconView.frame = CGRectMake(margin_left, margin_top, icon_width, icon_width);
    [self.contentView addSubview:_iconView];
    
    _doctorLabel = [[UILabel alloc] init];
    _doctorLabel.textColor = kBlackColor;
    _doctorLabel.font = SystemFont_14;
    _doctorLabel.textAlignment = NSTextAlignmentCenter;
    _doctorLabel.frame = (CGRect){margin_left,CGRectGetMaxY(_iconView.frame)+interval_y,icon_width,SystemFont_14.lineHeight};
    [self.contentView addSubview:_doctorLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.frame = CGRectMake(CGRectGetMaxX(_iconView.frame)+interval_x, CGRectGetMinY(_iconView.frame), kScreenWidth-CGRectGetMaxX(_iconView.frame)-margin_left-interval_x, 40.f);
    _contentLabel.numberOfLines = 2;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.font = kAnnotationFont;
    _contentLabel.textColor = kBlackColor;
    [self.contentView addSubview:_contentLabel];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.frame = CGRectMake(CGRectGetMinX(_contentLabel.frame), CGRectGetMaxY(_contentLabel.frame), CGRectGetWidth(_contentLabel.frame), 20);
    _dateLabel.font = kAnnotationFont;
    _dateLabel.textColor = kLightGrayColor;
    [self.contentView addSubview:_dateLabel];
    
    [self setContentView];
}

- (void)setContentView
{
    _iconView.image = [UIImage imageNamed:@"praise_comment_sign.png"];
    _contentLabel.text = @"华佗[1]  （约公元145年－公元208年），字元化，一名旉，沛国谯县人，东汉末年著名的医学家。华佗与董奉、张仲景并称为“建安三神医”。少时曾在外游学，行医足迹遍及安徽、河南、山东、江苏等地，钻研医术而不求仕途。他医术全面，尤其擅长外科，精于手术。并精通内、妇、儿、针灸各科。[2-4]  晚年因遭曹操怀疑，下狱被拷问致死。";
    _dateLabel.text = @"2015-08-30 12:50";
    _doctorLabel.text = @"华佗";
}

@end
