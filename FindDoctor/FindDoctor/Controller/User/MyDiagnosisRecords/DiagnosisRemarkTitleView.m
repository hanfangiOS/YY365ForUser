//
//  DiagnosisRemarkTitleView.m
//  uyi365ForPatient
//
//  Created by ZhuHaoRan on 16/3/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "DiagnosisRemarkTitleView.h"

@implementation DiagnosisRemarkTitleView{
    UIView      * _leftLineView;
    UIView      * _rightLineView;
    UILabel     * _titleLabel;
    
    CGFloat       _labelWidth;
    CGFloat       _labelHeight;
    CGFloat       _leftLineWidth;
    CGFloat       _leftLineHeight;
    CGFloat       _rightLineWidth;
    CGFloat       _rightLineHeight;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title Style:(TitleViewStyle)style{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;
        self.style = style;
        if (self.style == TitleViewDefaultStyle) {
            [self initWithDefaultStyle];
        }
        [self initSubViews];
        [self resetData];
        return self;
    }
    return nil;
}

- (void)initWithDefaultStyle{
    self.titleFont = [UIFont systemFontOfSize:14];
    self.titleColor = UIColorFromHex(Color_Hex_NavBackground);
    self.leftLineColor = [UIColor lightGrayColor];
    self.rightLineColor = [UIColor lightGrayColor];
    self.leftPadding = 0;
    self.rightPadding = 0;
    self.PaddingInLeftLineAndTitle = 4;
    self.PaddingInRightLineAndTitle = 4;
    _leftLineHeight = 0.5;
    _rightLineHeight= 0.5;
}

- (void)resetData{
    CGSize size =[self.title sizeWithAttributes:@{NSFontAttributeName:self.titleFont}];
    _labelWidth = size.width;
    _labelHeight = self.frameHeight;
    _leftLineWidth = (self.frameWidth - self.PaddingInLeftLineAndTitle - self.PaddingInRightLineAndTitle - _labelWidth - self.leftPadding - self.rightPadding)/2;
    _rightLineWidth = _leftLineWidth;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)initSubViews{
    _leftLineView = [[UIView alloc] initWithFrame:CGRectMake(1, 1, 1, 1)];
    
    _rightLineView = [[UIView alloc] initWithFrame:CGRectMake(1, 1, 1, 1)];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 1, 1)];
    _titleLabel.text = self.title;
    _titleLabel.backgroundColor = [UIColor clearColor];
    if (self.style == TitleViewDefaultStyle) {
        _leftLineView.backgroundColor = [UIColor grayColor];
        _rightLineView.backgroundColor = [UIColor grayColor];
        _titleLabel.textColor = self.titleColor;
        _titleLabel.font = self.titleFont;
        _leftLineView.backgroundColor = self.leftLineColor;
        _rightLineView.backgroundColor = self.rightLineColor;
    }
    [self addSubview:_leftLineView];
    [self addSubview:_rightLineView];
    [self addSubview:_titleLabel];
}

- (void)layoutSubviews{
    
    _titleLabel.frame = CGRectMake((self.frameWidth - _labelWidth)/2, 0, _labelWidth, _labelHeight);
    
    _leftLineView.frame = CGRectMake(self.leftPadding, (self.frameHeight - _leftLineHeight)/2, _leftLineWidth, _leftLineHeight);
    
    _rightLineView.frame = CGRectMake(self.frameWidth - self.rightPadding - _rightLineWidth, (self.frameHeight - _rightLineHeight)/2, _rightLineWidth, _rightLineHeight);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
