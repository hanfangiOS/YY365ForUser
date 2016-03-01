//
//  SNListEmptyView.m
//  CollegeUnion
//
//  Created by li na on 15/6/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "SNListEmptyView.h"

@implementation SNListEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //
        if ([UIImage imageNamed:@"empty_list"]) {
            self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 185, 185)];
            self.imgView.centerY = self.boundsHeight/2.0 - 20;
            self.imgView.centerX = self.boundsWidth/2.0;
            [self.imgView setImage:[UIImage imageNamed:@"empty_list"]];
            [self addSubview:self.imgView];
        }
        
        //
        CGFloat labelOriginY = self.imgView ? CGRectGetMaxY(self.imgView.frame) + 4 : self.boundsHeight/2.0;
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, labelOriginY, self.boundsWidth, 50)];
        [self.textLabel setTextAlignment:NSTextAlignmentCenter];
        [self.textLabel setText:@"暂时没有数据哦"];
        [self.textLabel setTextColor:UIColorFromHex(0x979797)];
        [self.textLabel setFont:[UIFont systemFontOfSize:13.0]];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.numberOfLines = 2.0;
        [self addSubview:self.textLabel];
        
        //
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:gesture];

    }
    return self;
}

- (void)tapped:(UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(emptyViewClicked)])
    {
        [self.delegate emptyViewClicked];
    }
}

@end
