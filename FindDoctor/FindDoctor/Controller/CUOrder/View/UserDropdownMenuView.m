//
//  UserDropdownMenuView.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/25.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "UserDropdownMenuView.h"

@implementation UserDropdownMenuView
{
    UIImageView *imageView;
    UILabel     *titleLabel;
    UIButton    *arrowButton;
    UIButton    *addButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initSubviews];
    }
    
    return self;
}

+ (CGFloat)defaultHeight
{
    return 75.0;
}

- (void)initSubviews
{
    CGFloat padding = 25.0;

    CGFloat imageWith = 42;
//    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding, padding, imageWith, imageWith)];
//    imageView.image = [UIImage imageNamed:@"menu_user_pic"];
//    [self addSubview:imageView];
    
    CGFloat titleOriginX = CGRectGetMaxX(imageView.frame) + padding;
    CGFloat titleHeight = 30.0;
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleOriginX, (self.frameHeight - titleHeight) / 2, self.frameWidth - titleOriginX - 135, titleHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = kBlackColor;
    [self addSubview:titleLabel];
    
    CGFloat arrowWidth = 20;
    CGRect arrowFrame = CGRectMake(CGRectGetMaxX(titleLabel.frame), (self.frameHeight - arrowWidth) / 2, arrowWidth, arrowWidth);
    arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    arrowButton.frame = CGRectInset(arrowFrame, -10, -10);
    [arrowButton setImage:[UIImage imageNamed:@"menu_arrow_down"] forState:UIControlStateNormal];
    [arrowButton addTarget:self action:@selector(arrowButtonPress) forControlEvents:UIControlEventTouchUpInside];
    arrowButton.adjustsImageWhenHighlighted = NO;
    [self addSubview:arrowButton];
    
    CGFloat addBtnPadding = 15.0;
    CGFloat addBtnWidth = imageWith;
    addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(self.frameWidth - addBtnWidth - addBtnPadding, (self.frameHeight - addBtnWidth) / 2, addBtnWidth, addBtnWidth);
    [addButton setImage:[UIImage imageNamed:@"menu_btn_add_nor"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"menu_btn_add_sel"] forState:UIControlStateHighlighted];
    [addButton addTarget:self action:@selector(addButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addButton];
}

- (void)update
{
    titleLabel.text = self.user.name;
}

- (void)arrowButtonPress
{
    if (self.dropdownBlock) {
        self.dropdownBlock();
    }
}

- (void)addButtonPress
{
    if (self.addBlock) {
        self.addBlock();
    }
}

@end
