//
//  OrderResultButtonView.m
//  CommentTest
//
//  Created by zhouzhenhua on 14-9-15.
//  Copyright (c) 2014年 zhouzhenhua. All rights reserved.
//

#import "OrderResultButtonView.h"
#import "UIConstants.h"
#import "UIImage+Color.h"

#define kDefaultHeight     45.0

#define kViewWidth         CGRectGetWidth(self.bounds)
#define kLPadding          0.0
#define kButtonSpace       2.0

#define kButtonOriginX     kLPadding
#define kButtonOriginY     ((kDefaultHeight - kButtonHeight)/2)
#define kButtonWidth       ((kViewWidth - kLPadding * 2)/2)
#define kButtonHeight      45.0

#define kLineColor         UIColorFromHex(Color_Hex_Tableview_Separator)

@implementation OrderResultButtonView
{
    UIButton     *leftButton;
    UIButton     *rightButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        [self initSubviews];
    }
    return self;
}

+ (float)defaultHeight
{
    return kDefaultHeight;
}

- (void)initSubviews
{
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0.5)];
    topLine.backgroundColor = kLineColor;
    [self addSubview:topLine];
    
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(kButtonOriginX, kButtonOriginY, kButtonWidth, kButtonHeight);
    [leftButton setBackgroundImage:[[UIImage createImageWithColor:kDarkGreenColor] stretchableImageByCenter] forState:UIControlStateNormal];
    [leftButton setTitle:@"查看约诊单" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftButton];
    
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(CGRectGetMaxX(leftButton.frame), kButtonOriginY, CGRectGetWidth(leftButton.frame), CGRectGetHeight(leftButton.frame));
    [rightButton setBackgroundImage:[[UIImage createImageWithColor:UIColorFromRGB(102, 212, 215)] stretchableImageByCenter] forState:UIControlStateNormal];
    [rightButton setTitle:@"返回" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightButton];
}

- (void)leftButtonPress
{
    if (self.checkAction) {
        self.checkAction();
    }
}

- (void)rightButtonPress
{
    if (self.backAction) {
        self.backAction();
    }
}

@end
