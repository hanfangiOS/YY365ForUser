//
//  HomeTipView.m
//  FindDoctor
//
//  Created by chai on 15/9/16.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "HomeTipView.h"

@interface HomeTipView ()
{
    UIImageView *_signView;
    UIImageView *_footerLineView;
    UILabel *_contentLabel;
}
@end

@implementation HomeTipView

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
    _signView = [[UIImageView alloc] init];
//    [self addSubview:_signView];
    
    _footerLineView = [[UIImageView alloc] init];
    [self addSubview:_footerLineView];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = SystemFont_14;
    _contentLabel.textColor = [UIColor whiteColor];
    [self addSubview:_contentLabel];
}

- (void)setContentTitle:(NSString *)title
{
    float margin_left = 15;
    float interval_x = 30;
    float sign_width = 40.f;
//    _signView.frame = (CGRect){margin_left,0,sign_width,sign_width};
//    _signView.image = [UIImage imageNamed:@"home_tip_sign"];
    
    UIImage *footer_line = [UIImage imageNamed:@"home_tip_footer_line"];
    
    _footerLineView.frame = (CGRect){(kScreenWidth-footer_line.size.width)/2.f,CGRectGetMaxY(_signView.frame),footer_line.size};
    _footerLineView.image = footer_line;
    
    _contentLabel.frame = (CGRect){(footer_line.size.width-margin_left)/2.f,0,footer_line.size.width-margin_left*2,sign_width};
    _contentLabel.text = title;
}

- (void)hiddenLine
{
    _footerLineView.hidden = YES;
}

@end
