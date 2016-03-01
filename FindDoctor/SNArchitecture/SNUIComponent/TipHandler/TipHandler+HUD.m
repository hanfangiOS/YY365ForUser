//
//  TipHandler+HUD.m
//  HuiYangChe
//
//  Created by zhouzhenhua on 14-10-15.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import "TipHandler+HUD.h"
#import "MBProgressHUD.h"

#define kMarkImageSuccess               @"checkmark_success"
#define kMarkImageFail                  @"checkmark_fail"

@implementation TipHandler (HUD)

+ (void)showHUDText:(NSString *)text inView:(UIView *)view
{
    [self showHUDText:text inView:view duration:1];
}

+ (void)showHUDText:(NSString *)text inView:(UIView *)view duration:(float)duration
{
    UIView *superView = view ? view : [UIApplication sharedApplication].keyWindow;
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
    hud.center = CGPointMake(CGRectGetWidth(superView.frame)/2, CGRectGetHeight(superView.frame)/2);
    
	[view addSubview:hud];
	
    hud.mode = MBProgressHUDModeText;
    
    hud.labelText = text;
    
    hud.removeFromSuperViewOnHide = YES;
	
	[hud show:YES];
	[hud hide:YES afterDelay:duration];
}

+ (void)showHUDText:(NSString *)text state:(TipState)state inView:(UIView *)view
{
    [self showHUDText:text state:state inView:view duration:1];
}

+ (void)showHUDText:(NSString *)text state:(TipState)state inView:(UIView *)view duration:(float)duration
{
    UIView *superView = view ? view : [UIApplication sharedApplication].keyWindow;
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
    hud.center = CGPointMake(CGRectGetWidth(superView.frame)/2, CGRectGetHeight(superView.frame)/2);
    
	[view addSubview:hud];
	
    UIImage *image = [UIImage imageNamed:(state == TipStateSuccess) ? kMarkImageSuccess : kMarkImageFail];
	hud.customView = [[UIImageView alloc] initWithImage:image];

    hud.mode = MBProgressHUDModeCustomView;

    hud.labelText = text;

    hud.removeFromSuperViewOnHide = YES;
	
	[hud show:YES];
	[hud hide:YES afterDelay:duration];
}

@end
