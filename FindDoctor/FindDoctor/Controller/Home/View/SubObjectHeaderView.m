//
//  SubObjectHeaderView.m
//  FindDoctor
//
//  Created by chai on 15/10/7.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "SubObjectHeaderView.h"

@interface SubObjectHeaderView ()
{
    UILabel *_titleLabel;
    UIView *_signView;
}
@end

@implementation SubObjectHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    float interval_x = 5.f;
    float sign_width = 18.f;
    float content_height = 55.f;
    float margin = 30*kScreenRatio;
    float padding_bottom = 10.f;
    
    _signView = [[UILabel alloc] init];
    _signView.backgroundColor = kGreenColor;
    _signView.frame = (CGRect){margin,content_height-sign_width-padding_bottom,sign_width,sign_width};
    [self addSubview:_signView];

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = kTableViewCellGrayColor;
    _titleLabel.textColor = kBlackColor;
    _titleLabel.font = SystemFont_14;
    _titleLabel.frame = (CGRect){CGRectGetMaxX(_signView.frame)+interval_x,CGRectGetMinY(_signView.frame),kScreenWidth-CGRectGetMaxX(_signView.frame)-interval_x,sign_width};
    [self addSubview:_titleLabel];
    
}

- (void)setHeaderTitle:(NSString *)headerTitle
{
    _headerTitle = headerTitle;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.firstLineHeadIndent = 3.f;
    
    NSMutableAttributedString *headerAttributedStr = [[NSMutableAttributedString alloc] initWithString:headerTitle];
    [headerAttributedStr addAttributes:@{NSParagraphStyleAttributeName:paragraph} range:NSMakeRange(0, headerTitle.length)];
    
    _titleLabel.attributedText = headerAttributedStr;
}

@end
