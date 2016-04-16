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
    UIView  *_footerLine;
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
    float sign_width = 18;
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frameWidth, 2)];
    line.backgroundColor = UIColorFromHex(0xf3f6f9);
    [self addSubview:line];
    
    _footerLine = [[UIView alloc]initWithFrame:CGRectMake(8, self.frameHeight, self.frameWidth-16, 2)];
    _footerLine.backgroundColor = UIColorFromHex(0xf3f6f9);
    [self addSubview:_footerLine];
    
    _signView = [[UILabel alloc] init];
    _signView.backgroundColor = UIColorFromHex(Color_Hex_NavBackground);
    _signView.frame = (CGRect){8,(self.frameHeight - sign_width)/2,4,sign_width};
    [self addSubview:_signView];

    _titleLabel = [[UILabel alloc] init];
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

- (void)setHasLine:(BOOL)hasLine{
    _hasLine = hasLine;
    _footerLine.hidden = !hasLine;
}

@end
