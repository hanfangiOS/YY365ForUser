//
//  SelectCityCollectionViewCell.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/5/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "SelectCityCollectionViewCell.h"
@interface SelectCityCollectionViewCell(){
    UILabel *_label;
}

@end

@implementation SelectCityCollectionViewCell

+ (CGFloat)defaultHeight{
    return 20;
}

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
    _label = [[UILabel alloc]init];
    _label.layer.borderColor = UIColorFromHex(0x333333).CGColor;
    _label.textColor = UIColorFromHex(0x333333);
    _label.layer.borderWidth = 0.5f;
    _label.font = [UIFont systemFontOfSize:14];
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
}

- (void)setString:(NSString *)string{
    _string = string;
    _label.text = _string;
    [_label sizeToFit];
    _label.frame = CGRectMake(_label.frameX, _label.frameY, _label.frameWidth + 20, _label.frameHeight + 15);
}

- (void)setIsValue:(BOOL *)isValue{
    if (isValue) {
        _label.layer.borderColor = UIColorFromHex(0x333333).CGColor;
        _label.textColor = UIColorFromHex(0x333333);
    }
    else{
        _label.layer.borderColor = UIColorFromHex(0xcccccc).CGColor;
        _label.textColor = UIColorFromHex(0xcccccc);
    }
}

@end
