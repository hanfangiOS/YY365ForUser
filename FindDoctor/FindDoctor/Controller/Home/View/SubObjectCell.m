//
//  SubObjectCell.m
//  FindDoctor
//
//  Created by chai on 15/8/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "SubObjectCell.h"
#import "UIImageView+WebCache.h"

@interface SubObjectCell ()
{
    UIImageView *_iconView;
    UILabel *_titleLabel;
}

@end

@implementation SubObjectCell

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
    float content_width = self.frame.size.width;

    
    _iconView = [[UIImageView alloc] init];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    CGFloat side = 50;
    _iconView.frame = CGRectMake((content_width - side)/2,(content_width - side)/2 - 8, side, side);

    [self.contentView addSubview:_iconView];
    
    CGFloat padding = 8;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.frame = CGRectMake(0, _iconView.maxY + padding, self.frameWidth, 12);
    _titleLabel.textColor = kGrayTextColor;
    [self.contentView addSubview:_titleLabel];
}

- (void)setSubobject:(SubObject *)subobject
{
    _subobject = subobject;
    [_iconView setImageWithURL:[NSURL URLWithString:_subobject.imageURL] placeholderImage:[UIImage imageNamed:_subobject.localImageName]];
    _titleLabel.text = subobject.name;
}



@end
