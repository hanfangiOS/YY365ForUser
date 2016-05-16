//
//  SubjectOfClinicMainCollectionViewCell.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/2/29.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "SubjectOfClinicMainCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@interface SubjectOfClinicMainCollectionViewCell()

{
    UIImageView *_iconView;
    UILabel *_nameLabel;
    UILabel *_titleLabel;
}

@end

@implementation SubjectOfClinicMainCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView
{
    float content_width = self.frame.size.width * 0.7;
    
    _iconView = [[UIImageView alloc] init];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    _iconView.frame = CGRectMake(self.frame.size.width * 0.15, 0, content_width, content_width);
    _iconView.layer.cornerRadius = _iconView.frameWidth/2.f;
    _iconView.clipsToBounds = YES;
    [self.contentView addSubview:_iconView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:12];
    _nameLabel.frame = CGRectMake(0, content_width+5, self.frameWidth, 12);
    _nameLabel.textColor = UIColorFromHex(Color_Hex_Text_Normal);
    [self.contentView addSubview:_nameLabel];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:10];
    _titleLabel.frame = CGRectMake(0, CGRectGetMaxY(_nameLabel.frame) + 3 , self.frameWidth, 10);
    _titleLabel.textColor = UIColorFromHex(Color_Hex_Text_gray);
    [self.contentView addSubview:_titleLabel];
}

- (void)setData:(Doctor *)data{
    _data = data;
    [_iconView setImageWithURL:[NSURL URLWithString:_data.avatar] placeholderImage:[UIImage imageNamed:@"temp_icon_doctor"]];
    _nameLabel.text = _data.name;
    _titleLabel.text = _data.levelDesc;

}


@end
