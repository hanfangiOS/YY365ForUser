//
//  BigButtonsInUser.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/21.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "BigButtonsInUser.h"

@interface BigButtonsInUser()

@property (strong,nonatomic)UIImageView * icon;
@property (strong,nonatomic)UIImageView * pointIcon;
@property (strong,nonatomic)UILabel * label;

@end

@implementation BigButtonsInUser

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat imageWidth = image.size.width;
        CGFloat imageHeight = image.size.height;
        
        self.icon = [[UIImageView alloc]initWithFrame:CGRectMake((self.frameWidth - imageWidth)/2, 6, imageWidth, imageHeight)];
        self.icon.image = image;
        [self addSubview:self.icon];
        
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.icon.maxY + 8, self.frameWidth, 20)];
        self.label.text = title;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont systemFontOfSize:14];
        self.label.textColor = [UIColor whiteColor];
        [self addSubview:self.label];
        
        self.pointIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.frameWidth - 20 -10, 6 , 20, 20)];
        [self addSubview:self.pointIcon];
    }
    return self;
}


@end
