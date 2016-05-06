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
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, (self.frameHeight - 14.5)/2 + 1, 11.5, 14.5)];
    leftView.layer.contents = (id)[UIImage imageNamed:@"main_icon_city@2x"].CGImage;
    [self addSubview:leftView];
    
    _cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftView.maxX + 3,(self.frameHeight-13.5)/2.f, self.frameWidth - (leftView.maxX), 13.5)];
    _cityLabel.font = [UIFont systemFontOfSize:13];
    _cityLabel.textAlignment = NSTextAlignmentCenter;
    _cityLabel.adjustsFontSizeToFitWidth = YES;
    _cityLabel.textColor = [UIColor whiteColor];
    [self addSubview:_cityLabel];
}

@end
