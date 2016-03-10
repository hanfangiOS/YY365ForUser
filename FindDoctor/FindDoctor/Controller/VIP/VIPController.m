//
//  VIPController.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/10/9.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "VIPController.h"

@implementation VIPController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"优医VIP";
    
    [self initSubviews];
}

- (void)loadNavigationBar
{
    [self.navigationBar performSelector:@selector(useTranslucentBackgroundImage) withObject:nil];
}

- (void)initSubviews
{
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImage.image = [UIImage imageNamed:@"background"];
    [self.view addSubview:bgImage];
    [self.view sendSubviewToBack:bgImage];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    NSArray *vipIcons = @[@"vip_card_silver", @"vip_card_gold", @"vip_card_vip"];
    
    CGFloat iconWidth = 296.0 * kScreenRatio;
    CGFloat iconHeight = 90.0 * kScreenRatio;
    CGFloat iconOrginX = (self.contentView.frameWidth - iconWidth) / 2;
    CGFloat iconOriginY = 0;
    CGFloat iconSpace = 15.0;
    
    for (NSInteger i = 0; i < vipIcons.count; i ++) {
        CGRect iconRect = CGRectMake(iconOrginX, iconOriginY, iconWidth, iconHeight);
        
        UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        iconBtn.frame = iconRect;
        [iconBtn setBackgroundImage:[UIImage imageNamed:vipIcons[i]] forState:UIControlStateNormal];
        iconBtn.adjustsImageWhenHighlighted = NO;
        [self.contentView addSubview:iconBtn];
        
        iconOriginY += (iconHeight + iconSpace);
    }
}

@end
