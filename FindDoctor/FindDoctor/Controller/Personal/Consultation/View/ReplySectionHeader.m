//
//  ReplySectionHeader.m
//  FindDoctor
//
//  Created by chai on 15/9/15.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "ReplySectionHeader.h"

@interface ReplySectionHeader ()
{
    UILabel *_headerNameLabel;
    UIView *_lineView;
}

@end

@implementation ReplySectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = kLightLineColor;
    [self.contentView addSubview:_lineView];
    
    _headerNameLabel = [[UILabel alloc] init];
    _headerNameLabel.textColor = kGreenColor;
    _headerNameLabel.font = SystemFont_12;
    _headerNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_headerNameLabel];
}

- (void)setTitle:(NSString *)titleText
{
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    
    float padding_x = 10;
    
    CGSize nameSize = [titleText boundingRectWithSize:CGSizeMake(MAXFLOAT, SystemFont_14.lineHeight)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:SystemFont_14,NSParagraphStyleAttributeName:paragraph}
                                             context:nil].size;

    _headerNameLabel.frame = (CGRect){(kScreenWidth-nameSize.width-padding_x*2)/2.f,0,nameSize.width+padding_x*2,30.f};
    _headerNameLabel.backgroundColor = [UIColor whiteColor];
    _headerNameLabel.text = titleText;
    _lineView.frame = (CGRect){0,CGRectGetMidY(_headerNameLabel.frame)-0.4f,kScreenWidth,0.8f};
}

@end
