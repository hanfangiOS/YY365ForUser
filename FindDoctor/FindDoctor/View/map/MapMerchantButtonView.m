//
//  MapMerchantButtonView.m
//  HuiYangChe
//
//  Created by zhouzhenhua on 14-9-22.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import "MapMerchantButtonView.h"
//#import "UIConstants.h"
#import "UIImage+Stretch.h"
#import "CUUIContant.h"

#define kDefaultHeight     54.0

#define kViewWidth         CGRectGetWidth(self.bounds)

#define kLabelSpace        3.0

#define kLabelLPadding     12.0
#define kLabelTPadding     7.0

#define kTitleFontSize     16.0
#define kTitleHeight       16.0

#define kAddressFontSize   12.0
#define kAddressHeight     (12.0 * 2)

#define kButtonSpace       10.0
#define kButtonPadding     10.0
#define kButtonWidth       73.0
#define kButtonHeight      33.0
#define kButtonOriginY     ((kDefaultHeight - kButtonHeight)/2)

#define kLineColor         [UIColor colorWithWhite:230.0/255.0 alpha:1.0f]

@implementation MapMerchantButtonView
{
    UILabel      *titleLabel;
    UILabel      *addressLabel;
    UIButton     *gpsButton;
    UIButton     *routeButton;
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
    float viewWidth = CGRectGetWidth(self.bounds);
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 0.5)];
    topLine.backgroundColor = kLineColor;
    [self addSubview:topLine];
    
    routeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    routeButton.frame = CGRectMake(viewWidth - kButtonPadding - kButtonWidth, kButtonOriginY, kButtonWidth, kButtonHeight);
    [routeButton setBackgroundImage:[[UIImage imageNamed:@"route_button_normal"] stretchableImageByCenter] forState:UIControlStateNormal];
    [routeButton setBackgroundImage:[[UIImage imageNamed:@"route_button_selected"] stretchableImageByCenter] forState:UIControlStateHighlighted];
    [routeButton setTitle:@"路线" forState:UIControlStateNormal];
    routeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [routeButton setTitleColor:UIColorFromHex(Color_Hex_Text_Normal) forState:UIControlStateNormal];
    [routeButton addTarget:self action:@selector(rightButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:routeButton];
    
    gpsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    gpsButton.frame = CGRectMake(CGRectGetMinX(routeButton.frame) - kButtonSpace - kButtonWidth, kButtonOriginY, kButtonWidth, kButtonHeight);
    [gpsButton setBackgroundImage:[[UIImage imageNamed:@"navigation_button_normal"] stretchableImageByCenter] forState:UIControlStateNormal];
    [gpsButton setBackgroundImage:[[UIImage imageNamed:@"navigation_button_selected"] stretchableImageByCenter] forState:UIControlStateHighlighted];
    [gpsButton setTitle:@"导航" forState:UIControlStateNormal];
    gpsButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [gpsButton setTitleColor:UIColorFromHex(Color_Hex_Text_Normal) forState:UIControlStateNormal];
    [gpsButton addTarget:self action:@selector(leftButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:gpsButton];
    
    float labelWidth = CGRectGetMinX(gpsButton.frame) - kLabelLPadding - 30;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelLPadding, kLabelTPadding, labelWidth, kTitleHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = UIColorFromHex(Color_Hex_Text_Normal);
    titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    [self addSubview:titleLabel];
    
    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelLPadding, CGRectGetMaxY(titleLabel.frame) + 3, labelWidth, kAddressHeight)];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.textColor = UIColorFromHex(Color_Hex_Text_Normal);
    addressLabel.numberOfLines = 2;
    addressLabel.font = [UIFont systemFontOfSize:kAddressFontSize];
    [self addSubview:addressLabel];
}

- (void)setTitle:(NSString *)title
{
    titleLabel.text = title;
}

- (void)setAddress:(NSString *)address
{
    addressLabel.text = address;
}

- (void)leftButtonPress
{
    if (self.gpsAction) {
        self.gpsAction();
    }
}

- (void)rightButtonPress
{
    if (self.routeAction) {
        self.routeAction();
    }
}

@end
