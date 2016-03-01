//
//  YYZhenDanLineView.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/27.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "YYZhenDanLineView.h"

@implementation YYZhenDanLineView

    int lineInterval = 20;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView{

    int diamater = 8;
    int textSize = 14;
    int titleWidth = 75;
    
    UIView *cornerView = [[UIView alloc]initWithFrame:CGRectMake(0, (textSize - diamater)/2 +lineInterval/2 , diamater, diamater)];
    cornerView.layer.backgroundColor = UIColorFromHex(Color_Hex_NavBackground).CGColor;
    cornerView.layer.cornerRadius = diamater/2.f;
    [self addSubview:cornerView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(3 + diamater, lineInterval/2, titleWidth , textSize)];
    _titleLabel.font = [UIFont systemFontOfSize:textSize];
    _titleLabel.textColor = UIColorFromHex(Color_Hex_Text_Normal);
    _titleLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_titleLabel];
    
    _contentTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame) + 5, lineInterval/2 - 1.5, [self frameWidth]-titleWidth , 0)];
    _contentTextLabel.font = [UIFont systemFontOfSize:textSize];
    _contentTextLabel.textColor = UIColorFromHex(Color_Hex_Text_Normal);
    _contentTextLabel.textAlignment = NSTextAlignmentLeft;
    _contentTextLabel.numberOfLines = 0;
    [self addSubview:_contentTextLabel];
}

- (void)setTitle:(NSString *)title{
    _titleLabel.text = title;
}

- (void)setContentText:(NSString *)contentText{
    if ([[NSString stringWithFormat:@"%@",contentText] isEmpty]) {
        _contentTextLabel.text = [NSString stringWithFormat:@"测试"];
        [_contentTextLabel sizeToFit];
        _contentTextLabel.text = [NSString stringWithFormat:@"%@",contentText];
    }
    else{
        _contentTextLabel.text = [NSString stringWithFormat:@"%@",contentText];
        [_contentTextLabel sizeToFit];
    }
}

- (CGFloat)getframeHeight{
    return _contentTextLabel.frameHeight + lineInterval;
}
@end
