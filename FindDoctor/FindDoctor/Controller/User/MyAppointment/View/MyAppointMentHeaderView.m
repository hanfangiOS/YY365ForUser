//
//  MyAppointMentHeaderView.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/18.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "MyAppointMentHeaderView.h"

@implementation MyAppointMentHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        self.userInteractionEnabled = YES;
        return self;
    }
    return nil;
}

- (void)initSubViews{
    
    CGFloat padding = 70;
    CGFloat btnWidth = (kScreenWidth - padding * 3)/2;
    
    self.leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(padding, 0, btnWidth, self.frameHeight)];
    self.leftBtn.layer.borderColor = [UIColor clearColor].CGColor;
    self.leftBtn.layer.borderWidth = 0;

    [self addSubview:self.leftBtn];
    
    self.leftBottomLine = [[UILabel alloc] initWithFrame:CGRectMake(45, self.frameHeight - 2,(self.leftBtn.centerX - 45) * 2, 2)];
    self.leftBottomLine.backgroundColor = [UIColor blueColor];
    [self addSubview:self.leftBottomLine];
    
    self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - padding - btnWidth, 0, btnWidth, self.frameHeight)];
    self.rightBtn.layer.borderColor = [UIColor clearColor].CGColor;
    self.rightBtn.layer.borderWidth = 0;
    [self addSubview:self.rightBtn];
    
    self.rightBottomLine = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 45 - self.leftBottomLine.frameWidth, self.frameHeight - 2,self.leftBottomLine.frameWidth, 2)];
    self.rightBottomLine.backgroundColor = [UIColor blueColor];
    [self addSubview:self.rightBottomLine];
}

@end
