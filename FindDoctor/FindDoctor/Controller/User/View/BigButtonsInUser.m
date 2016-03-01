//
//  BigButtonsInUser.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/21.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "BigButtonsInUser.h"

@implementation BigButtonsInUser

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.frameWidth - image.size.width)/2, (self.frameHeight - 88)/2, image.size.width, image.size.height)];
        imageView.image = image;
        [self addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+9, self.frameWidth, 15)];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = UIColorFromHex(0x858585);
        [self addSubview:label];
    }
    return self;
}


@end
