//
//  TipHandler+HUD.h
//  HuiYangChe
//
//  Created by zhouzhenhua on 14-10-15.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import "TipHandler.h"

@interface TipHandler (HUD)

+ (void)showHUDText:(NSString *)text inView:(UIView *)view;
+ (void)showHUDText:(NSString *)text inView:(UIView *)view duration:(float)duration;

+ (void)showHUDText:(NSString *)text state:(TipState)state inView:(UIView *)view;
+ (void)showHUDText:(NSString *)text state:(TipState)state inView:(UIView *)view duration:(float)duration;

@end
