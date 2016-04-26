//
//  SettingTextFeildView.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/20.
//  Copyright © 2016年 li na. All rights reserved.
//


#import "SettingTextFeildView.h"
@interface SettingTextFeildView (){
    NSString *_title;
}

@end

@implementation SettingTextFeildView

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    int imageViewWidth = 27;
    int textSize = 17;
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, ([self frameHeight] - imageViewWidth)/2, imageViewWidth, imageViewWidth)];
    self.imageView.contentMode = 1;
    self.imageView.layer.cornerRadius = imageViewWidth/2.f;
    self.imageView.clipsToBounds = YES;
    self.imageView.backgroundColor = [UIColor redColor];
    [self addSubview:self.imageView];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = _title;
    _titleLabel.textColor = UIColorFromHex(0x999999);
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(imageViewWidth + 10, (self.frameHeight - _titleLabel.frameHeight)/2,_titleLabel.frameWidth, _titleLabel.frameHeight);
    [self addSubview:_titleLabel];
    
    _contentTextFeild = [[UITextField alloc]initWithFrame:CGRectMake(_titleLabel.maxX+10,(self.frameHeight - textSize)/2, [self frameWidth] - _titleLabel.maxX -10, textSize)];
    _contentTextFeild.font = [UIFont systemFontOfSize:15];
    _contentTextFeild.textAlignment = NSTextAlignmentRight;
//    _contentTextFeild.placeholder = @"0";
//    [_contentTextFeild setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    _contentTextFeild.keyboardType = UIKeyboardTypeNumberPad;
//    _contentTextFeild.tintColor = [UIColor whiteColor];
//    _contentTextFeild.textColor = [UIColor whiteColor];
    [self addSubview:_contentTextFeild];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(imageViewWidth + 10, [self frameHeight], [self frameWidth], 2)];
    lineView.layer.backgroundColor = UIColorFromHex(0xeeeeee).CGColor;
    [self addSubview:lineView];
}

@end
