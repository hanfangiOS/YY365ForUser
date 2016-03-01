//
//  ConsultationCell.m
//  FindDoctor
//
//  Created by chai on 15/9/8.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "ConsultationCell.h"

@implementation ConsultationCellFrame

- (void)setConsultationEntity:(Consultation *)consultationEntity
{
    _consultationEntity = consultationEntity;
    
    float left_width = 80;
    float right_width = 60.f;
    float icon_width = 60;
    float left_interval_y = 10;
    float interval_right = 20;
    
    float mid_start_y = 22.f;
    float mid_width = kScreenWidth-left_width-right_width-interval_right;
    float mid_interval_y = 6;
    
    float right_sign_height = 62;
    float right_sign_width = 40.f;
    float padding_right = 7.f;
    float right_padding_top = 7.f;
    
    NSString *content = @"咨询：头疼发热腿抽筋啊，头疼发热腿抽筋啊，头疼发热腿抽筋啊，头疼发热腿抽筋啊，头疼发热腿抽筋啊，头疼发热腿抽筋啊";
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize contentSize = [content boundingRectWithSize:CGSizeMake(mid_width, SystemFont_12.lineHeight*3)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:SystemFont_12,NSParagraphStyleAttributeName:paragraph}
                                               context:nil].size;
    
    _cellHeight = mid_start_y*2+contentSize.height+mid_interval_y*2+SystemFont_12.lineHeight*2;
    
    float left_start_y = (_cellHeight-kCommonTitleFont.lineHeight-icon_width-left_interval_y)/2.f;
    
    _headerViewFrame = CGRectMake((left_width-icon_width)/2.f, left_start_y, icon_width, icon_width);
    _doctorNameFrame = (CGRect){0,CGRectGetMaxY(_headerViewFrame)+left_interval_y,left_width,kCommonTitleFont.lineHeight};
    
    
    _userInfoFrame = (CGRect){left_width,mid_start_y,mid_width,SystemFont_12.lineHeight};
    
    _contentLabelFrame = (CGRect){CGRectGetMinX(_userInfoFrame),CGRectGetMaxY(_userInfoFrame)+mid_interval_y,contentSize};
    
    NSString *pointText = [NSString stringWithFormat:@"赠送积分：%d",100];
    
    CGSize pointSize = [pointText boundingRectWithSize:CGSizeMake(MAXFLOAT, SystemFont_12.lineHeight)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:SystemFont_12,NSParagraphStyleAttributeName:paragraph}
                                               context:nil].size;
    
    _pointLabelFrame = (CGRect){CGRectGetMinX(_userInfoFrame),CGRectGetMaxY(_contentLabelFrame)+mid_interval_y,pointSize};
    
    NSString *dateText = @"2014-01-01 12:12";
    
    CGSize dateSize = [dateText boundingRectWithSize:CGSizeMake(MAXFLOAT, SystemFont_12.lineHeight)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:SystemFont_12,NSParagraphStyleAttributeName:paragraph}
                                             context:nil].size;
    
    _dateLabelFrame = (CGRect){CGRectGetMinX(_contentLabelFrame)+mid_width-dateSize.width,CGRectGetMinY(_pointLabelFrame),dateSize};
    
    
    _rightSignFrame = (CGRect){kScreenWidth-padding_right-right_sign_width,right_padding_top,right_sign_width,right_sign_height};
    
    _signTipFrame = (CGRect){0, 10, right_sign_width, kCommonTitleFont.lineHeight};
}

@end

@interface ConsultationCell ()
{
    UIImageView *_headerView;
    UILabel *_doctorNameLabel;
    UILabel *_userInfoLabel;
    UILabel *_contentLabel;
    UILabel *_pointLabel;
    UILabel *_dateLabel;
    UIImageView *_rightSignView;
    UILabel *_signTipLabel;
}
@end

@implementation ConsultationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    _headerView = [[UIImageView alloc] init];
    [self.contentView addSubview:_headerView];
    
    _doctorNameLabel = [[UILabel alloc] init];
    _doctorNameLabel.textAlignment = NSTextAlignmentCenter;
    _doctorNameLabel.font = kCommonTitleFont;
    _doctorNameLabel.textColor = kBlackColor;
    [self.contentView addSubview:_doctorNameLabel];
    
    _userInfoLabel = [[UILabel alloc] init];
    _userInfoLabel.font = SystemFont_12;
    _userInfoLabel.textColor = kDarkGrayColor;
    [self.contentView addSubview:_userInfoLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = SystemFont_12;
    _contentLabel.textColor = kDarkGrayColor;
    [self.contentView addSubview:_contentLabel];
    
    _pointLabel = [[UILabel alloc] init];
    _pointLabel.font = SystemFont_12;
    _pointLabel.textColor = kDarkGrayColor;
    [self.contentView addSubview:_pointLabel];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.font = SystemFont_12;
    _dateLabel.textColor = kLightGrayColor;
    [self.contentView addSubview:_dateLabel];
    
    _rightSignView = [[UIImageView alloc] init];
    [self.contentView addSubview:_rightSignView];
    
    _signTipLabel = [[UILabel alloc] init];
    _signTipLabel.font = SystemFont_13;
    _signTipLabel.textColor = [UIColor whiteColor];
    _signTipLabel.textAlignment = NSTextAlignmentCenter;
    [_rightSignView addSubview:_signTipLabel];
}

- (void)setCellFrame:(ConsultationCellFrame *)cellFrame
{
    _cellFrame = cellFrame;
    _headerView.frame = _cellFrame.headerViewFrame;
    _headerView.layer.cornerRadius = _headerView.bounds.size.width/2.f;
    _headerView.layer.masksToBounds = YES;
    _doctorNameLabel.frame = _cellFrame.doctorNameFrame;
    _userInfoLabel.frame  =_cellFrame.userInfoFrame;
    _contentLabel.frame = _cellFrame.contentLabelFrame;
    _pointLabel.frame = _cellFrame.pointLabelFrame;
    _dateLabel.frame = _cellFrame.dateLabelFrame;
    _rightSignView.frame = _cellFrame.rightSignFrame;
    _signTipLabel.frame = _cellFrame.signTipFrame;
    
    _headerView.image = [UIImage imageNamed:@"login_header_circle_green"];
    _doctorNameLabel.text = @"华佗";
    _userInfoLabel.text = [NSString stringWithFormat:@"张三    男    54岁"];
    NSString *content = @"咨询：头疼发热腿抽筋啊，头疼发热腿抽筋啊，头疼发热腿抽筋啊，头疼发热腿抽筋啊，头疼发热腿抽筋啊，头疼发热腿抽筋啊";
    _contentLabel.text = content;
    _pointLabel.text = @"赠送：100分";
    _dateLabel.text = @"2015-09-09 12:12";
    _rightSignView.image = [UIImage imageNamed:@"doctor_tip_yellow"];
    _signTipLabel.text = @"发布中";
}

@end
