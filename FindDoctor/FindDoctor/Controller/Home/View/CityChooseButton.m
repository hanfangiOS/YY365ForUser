//
//  CityChooseButton.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/6.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "CityChooseButton.h"

@implementation CityChooseButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frameHeight/2.f - 39/4.f, 14, 39/2.f)];
    leftView.layer.contents = (id)[UIImage imageNamed:@"home_iconCity"].CGImage;
    [self addSubview:leftView];
    
    _cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(16,(self.frameHeight-14)/2.f, self.frameWidth - 18, 14)];
    _cityLabel.font = [UIFont systemFontOfSize:14];
    _cityLabel.textAlignment = NSTextAlignmentCenter;
    _cityLabel.adjustsFontSizeToFitWidth = YES;
    _cityLabel.textColor = [UIColor whiteColor];
    [self addSubview:_cityLabel];
}

@end
