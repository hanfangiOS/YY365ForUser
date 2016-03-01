//
//  LoginTextFeildView.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/1/9.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "LoginTextFeildView.h"
@interface LoginTextFeildView (){
    UIImage *_image;
}


@end

@implementation LoginTextFeildView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image{
    self = [super initWithFrame:frame];
    if (self) {
        _image = image;
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, [self frameHeight] - 1, [self frameWidth], 1)];
    lineView.layer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3].CGColor;
    [self addSubview:lineView];
    
    int imageViewWidth = 40;
    int imageWidth = _image.size.width/_image.size.height * ([self frameHeight] - 9);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((imageViewWidth - imageWidth)/2, 0, imageWidth, [self frameHeight] - 9)];
    imageView.contentMode = 1;
    imageView.image = _image;
    [self addSubview:imageView];
    
    _contentTextFeild = [[UITextField alloc]initWithFrame:CGRectMake(imageViewWidth, 0, [self frameWidth] - imageViewWidth, [self frameHeight] - 9)];
    _contentTextFeild.placeholder = @"0";
    [_contentTextFeild setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    _contentTextFeild.keyboardType = UIKeyboardTypeNumberPad;
    _contentTextFeild.tintColor = [UIColor whiteColor];
    _contentTextFeild.textColor = [UIColor whiteColor];
    [self addSubview:_contentTextFeild];
}

@end
