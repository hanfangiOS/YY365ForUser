//
//  ReplyCell.m
//  FindDoctor
//
//  Created by chai on 15/9/10.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "ReplyCell.h"

@implementation ReplyCellFrame

- (void)setReplyEntity:(ConsultationReply *)replyEntity
{
    _replyEntity = replyEntity;
    
    float margin_left = 20.f;
    float margin_top = 15;
    float interval_y = 10;
    float interval_x = 10;
    NSString *contentText = [NSString stringWithFormat:@"我最近头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼"];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize contentSize = [contentText boundingRectWithSize:CGSizeMake(kScreenWidth-margin_left*2, MAXFLOAT)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSParagraphStyleAttributeName:paragraph,NSFontAttributeName:SystemFont_12}
                                                   context:nil].size;
    
    _contentFrame = (CGRect){margin_left,margin_top,contentSize};
    
    _isSelf = arc4random() % 2;
    
    NSString *dateText = @"2015-01-01 00:00";
    
    CGSize dateSize = [dateText boundingRectWithSize:CGSizeMake(MAXFLOAT, SystemFont_12.lineHeight)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSParagraphStyleAttributeName:paragraph,NSFontAttributeName:SystemFont_12}
                                             context:nil].size;
    
    NSString *nameText = @"张全胜";
    
    CGSize nameSize = [nameText boundingRectWithSize:CGSizeMake(MAXFLOAT, SystemFont_12.lineHeight)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSParagraphStyleAttributeName:paragraph,NSFontAttributeName:SystemFont_12}
                                             context:nil].size;
    
    if (_isSelf) {
        _dateFrame = (CGRect){kScreenWidth-margin_left-dateSize.width,CGRectGetMaxY(_contentFrame)+interval_y,dateSize};
        _nameFrame = (CGRect){CGRectGetMinX(_dateFrame)-interval_x-nameSize.width,CGRectGetMinY(_dateFrame),nameSize};
    }else{
        _nameFrame = (CGRect){margin_left,CGRectGetMaxY(_contentFrame)+interval_y,nameSize};
        _dateFrame = (CGRect){CGRectGetMaxX(_nameFrame)+interval_x,CGRectGetMinY(_nameFrame),dateSize};
    }
    
    _cellHeight = CGRectGetMaxY(_dateFrame)+margin_top;
}

@end


@interface ReplyCell ()
{
    UILabel *_contentLabel;
    UILabel *_nameLabel;
    UILabel *_dateLabel;
}
@end

@implementation ReplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createSubViews
{
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = SystemFont_12;
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = kDarkGrayColor;
    [self.contentView addSubview:_contentLabel];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = SystemFont_12;
    [self.contentView addSubview:_nameLabel];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.font = SystemFont_12;
    _dateLabel.textColor = kLightGrayColor;
    [self.contentView addSubview:_dateLabel];
}

- (void)setCellFrame:(ReplyCellFrame *)cellFrame
{
    _cellFrame = cellFrame;
    _contentLabel.frame = _cellFrame.contentFrame;
    _nameLabel.frame = _cellFrame.nameFrame;
    _dateLabel.frame = _cellFrame.dateFrame;
    if (_cellFrame.isSelf) {
        _nameLabel.textColor = kOrangeColor;
    }else{
        _nameLabel.textColor = kBlueColor;
    }
    
    NSString *contentText = [NSString stringWithFormat:@"我最近头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼头疼"];
    _contentLabel.text = contentText;
    
    NSString *dateText = @"2015-01-01 00:00";
    _dateLabel.text = dateText;
    
    NSString *nameText = @"张全胜";
    _nameLabel.text = nameText;

}

@end
