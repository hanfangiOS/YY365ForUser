//
//  BlueDotLabelInDoctorHeaderView.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/1/11.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "BlueDotLabelInDoctorHeaderView.h"

@interface BlueDotLabelInDoctorHeaderView(){
    NSString *_title;
    NSString *_contents;
    NSString *_unit;
    BOOL _hasDot;

    UILabel *titleLabel;
    UILabel *contentsLabel;
    UILabel *unitLabel;
    
    UIView *dotView;
}

@end

@implementation BlueDotLabelInDoctorHeaderView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title contents:(NSString *)contents unit:(NSString *)unit hasDot:(BOOL)hasDot{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        _contents = contents;
        _unit = unit;
        _hasDot = hasDot;
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    int fontSize = 12;
    int fontSize_contents = 12;
    int leftPaddig = 0;
    if (_hasDot) {
        dotView = [[UIView alloc]init];
        dotView.frame = CGRectMake(0, 0 ,DotWidth, DotWidth);
        [self addSubview:dotView];
        leftPaddig = DotWidth + 5;
    }
//    CGSize titleSize = [_title sizeWithAttributes: @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];
    titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:fontSize];
    titleLabel.textColor = UIColorFromHex(Color_Hex_Text_gray);
    [self addSubview:titleLabel];
    
    contentsLabel = [[UILabel alloc]init];
    contentsLabel.font = [UIFont systemFontOfSize:fontSize_contents];
    contentsLabel.textColor = UIColorFromHex(Color_Hex_Text_Highlighted);
    [self addSubview:contentsLabel];
    
    unitLabel = [[UILabel alloc]init];
    unitLabel.font = [UIFont systemFontOfSize:fontSize];
    unitLabel.textColor = UIColorFromHex(Color_Hex_Text_gray);
    [self addSubview:unitLabel];
}

- (void)setTitle:(NSString *)title contents:(NSString *)contents unit:(NSString *)unit{
    int fontSize = 12;
    int fontSize_contents = 12;
    int leftPaddig = 0;
    
    if (_hasDot) {
//        dotView.frame = CGRectMake(0, ([self frameHeight])/2 - DotWidth/2,DotWidth, DotWidth);
        dotView.frame = CGRectMake(0, 0 ,DotWidth, DotWidth);
        dotView.layer.cornerRadius = DotWidth/2.f;
        dotView.layer.backgroundColor = UIColorFromHex(Color_Hex_NavBackground).CGColor;
        leftPaddig = DotWidth + 5;
    }
    
    _title = title;
    _contents = contents;
    _unit = unit;
    titleLabel.text = _title;
    CGSize titleSize = [_title sizeWithAttributes: @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];
    titleLabel.frame = CGRectMake(leftPaddig, 0, titleSize.width, titleSize.height);
    
    contentsLabel.text = _contents;
    [contentsLabel sizeToFit];
//    CGSize contentsSize = [_contents sizeWithAttributes: @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize_contents]}];
    contentsLabel.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame) + 5, (fontSize - fontSize_contents)/2, contentsLabel.frameWidth, contentsLabel.frameHeight);
    
    unitLabel.text = _unit;
    [unitLabel sizeToFit];
//    CGSize unitSize = [_contents sizeWithAttributes: @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];
    unitLabel.frame = CGRectMake(CGRectGetMaxX(contentsLabel.frame) + 5,0, unitLabel.frameWidth, unitLabel.frameHeight);
    
    CGFloat height = titleLabel.frameHeight > unitLabel.frameHeight ? titleLabel.frameHeight : unitLabel.frameHeight;
    self.frame = CGRectMake(self.frameX,self.frameY, CGRectGetMaxX(unitLabel.frame),height);
    dotView.frame = CGRectMake(0, ([self frameHeight])/2,DotWidth, DotWidth);

    [self setNeedsDisplay];
}

@end
