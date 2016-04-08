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
    CGFloat side = 52 * HFixRatio6;
    _iconView.frame = CGRectMake((content_width - side)/2,(content_width - side)/2 - 7 * VFixRatio6, side, side);
//    _iconView.layer.borderColor = UIColorFromRGB(239, 239, 239).CGColor;
//    _iconView.layer.borderWidth = 1.f;
    [self.contentView addSubview:_iconView];
    
    CGFloat padding = -1 * VFixRatio6;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = kCommonDescFont;
    _titleLabel.frame = CGRectMake(0, _iconView.maxY + padding, self.frameWidth, self.frameHeight-(_iconView.maxY + padding));
    _titleLabel.textColor = UIColorFromHex(Color_Hex_NavBackground);
    [self.contentView addSubview:_titleLabel];
}

- (void)setSubobject:(SubObject *)subobject
{
    _subobject = subobject;
//    [_iconView setImageWithURL:[NSURL URLWithString:_subobject.imageURL] placeholderImage:[UIImage imageNamed:_subobject.localImageName]];
    [_iconView setImage:[UIImage imageNamed:_subobject.localImageName]];
    _titleLabel.text = subobject.name;
}

@end
