//
//  HotSearchDoctorCollectionViewCell.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/14.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "HotSearchDoctorCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface HotSearchDoctorCollectionViewCell(){
    UIImageView *_imageView;
    UILabel     *_titleLabel;
    UILabel     *_detailLabel;
    
    UIView      *_lineView;
}
@end

@implementation HotSearchDoctorCollectionViewCell

+ (CGFloat)defaultHeight{
    return 84;
}

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
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(8,15, 53, 53)];
    _imageView.contentMode = 1;
    _imageView.layer.cornerRadius = 6.f;
    _imageView.clipsToBounds = YES;
    [self addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_imageView.maxX + 8, _imageView.frameY, self.frameWidth - 8*3 - _imageView.frameWidth, 17)];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(_imageView.maxX + 8, _imageView.maxY - 26, self.frameWidth - 8*3 - _imageView.frameWidth, 29)];
    _detailLabel.font = [UIFont systemFontOfSize:12];
    _detailLabel.textColor = UIColorFromHex(0x999999);
    _detailLabel.numberOfLines = 2;
    [self addSubview:_detailLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(_imageView.maxX + 8, [HotSearchDoctorCollectionViewCell defaultHeight], self.frameWidth - _imageView.maxX - 24, 1)];
    _lineView.backgroundColor = UIColorFromHex(0xdee6ef);
    [self addSubview:_lineView];
}

- (void)setData:(Doctor *)data{
    _data = data;
    [_imageView setImageWithURL:[NSURL URLWithString:_data.avatar] placeholderImage:[UIImage imageNamed:@"temp_icon_doctor"]];
    _titleLabel.text = _data.name;
    _detailLabel.text = _data.skillTreat;
}

- (void)setHasLine:(BOOL)hasLine{
    _hasLine = hasLine;
    _lineView.hidden = !_hasLine;
}


@end
