//
//  ReplyHeader.m
//  FindDoctor
//
//  Created by chai on 15/9/10.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "ReplyHeader.h"

@interface ReplyHeader ()
{
    UIImageView *_headerView;
    UILabel *_nameLabel;
    UILabel *_infoLabel;
    UILabel *_pointLabel;
    UILabel *_dateLabel;
}
@end

@implementation ReplyHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
        self.backgroundColor = kLightGreenColor;
    }
    return self;
}

- (void)createSubViews
{
    _headerView = [[UIImageView alloc] init];
    [self addSubview:_headerView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = SystemFont_14;
    _nameLabel.textColor = kBlackColor;
    [self addSubview:_nameLabel];
    
    _infoLabel = [[UILabel alloc] init];
    _infoLabel.font = SystemFont_12;
    _infoLabel.textColor = kLightGrayColor;
    [self addSubview:_infoLabel];
    
    _pointLabel = [[UILabel alloc] init];
    _pointLabel.font = SystemFont_12;
    _pointLabel.textColor = kOrangeColor;
    [self addSubview:_pointLabel];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.font = SystemFont_10;
    _dateLabel.textColor = kLightGrayColor;
    [self addSubview:_dateLabel];
}

- (void)setAccount
{
    float header_width = 40.f*kScreenRatio;
    float content_height = self.frame.size.height;
    float margin_x = (content_height-header_width)/2.f;
    float margin_y = (content_height-header_width)/2.f;
    float interval_x = 10.f;
    float interval_y = 10.f;
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    
    _headerView.frame = (CGRect){margin_x,margin_y,header_width,header_width};
    _headerView.layer.cornerRadius = header_width/2.f;
    _headerView.layer.masksToBounds = YES;
    _headerView.image = [UIImage imageNamed:@"login_header_circle_green"];
    
    NSString *nameText = @"张三";
    CGSize nameSize = [nameText boundingRectWithSize:CGSizeMake(MAXFLOAT, SystemFont_14.lineHeight)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:SystemFont_14,NSParagraphStyleAttributeName:paragraph}
                                             context:nil].size;
    _nameLabel.frame = (CGRect){CGRectGetMaxX(_headerView.frame)+interval_x+margin_x,CGRectGetMinY(_headerView.frame),nameSize};
    _nameLabel.text = nameText;
    
    NSString *infoText = @"男   40岁";
    CGSize infoSize = [infoText boundingRectWithSize:CGSizeMake(MAXFLOAT, SystemFont_12.lineHeight)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:SystemFont_12,NSParagraphStyleAttributeName:paragraph}
                                             context:nil].size;
    _infoLabel.frame = (CGRect){CGRectGetMaxX(_nameLabel.frame)+interval_x,CGRectGetMinY(_nameLabel.frame)+SystemFont_14.lineHeight-SystemFont_12.lineHeight,infoSize};
    _infoLabel.text = infoText;
    
    NSString *pointText = @"赠送100分";
    
    CGSize pointSize = [pointText boundingRectWithSize:CGSizeMake(MAXFLOAT, SystemFont_12.lineHeight)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:SystemFont_12,NSParagraphStyleAttributeName:paragraph}
                                               context:nil].size;
    
    _pointLabel.frame = (CGRect){CGRectGetMaxX(_infoLabel.frame)+interval_x,CGRectGetMinY(_infoLabel.frame),pointSize};
    
    _pointLabel.text = pointText;
    
    NSString *dateText = @"咨询时间：2014-12-12 12:12";
    
    CGSize dateSize = [dateText boundingRectWithSize:CGSizeMake(MAXFLOAT, SystemFont_10.lineHeight)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:SystemFont_10,NSParagraphStyleAttributeName:paragraph}
                                             context:nil].size;
    _dateLabel.frame = (CGRect){CGRectGetMinX(_nameLabel.frame),CGRectGetMaxY(_nameLabel.frame)+interval_y,dateSize};
    
    _dateLabel.text  = dateText;
}

@end
