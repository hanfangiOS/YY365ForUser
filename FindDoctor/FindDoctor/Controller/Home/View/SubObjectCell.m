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
    _iconView.frame = CGRectMake(0, 0, content_width, content_width);
//    _iconView.layer.borderColor = UIColorFromRGB(239, 239, 239).CGColor;
//    _iconView.layer.borderWidth = 1.f;
    [self.contentView addSubview:_iconView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = kCommonDescFont;
    _titleLabel.frame = CGRectMake(0, content_width, content_width, self.frame.size.height-content_width);
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
