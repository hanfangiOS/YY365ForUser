//
//  CUBlankView.h
//  EShiJia
//
//  Created by zhouzhenhua on 15/6/26.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CUBlankView : UIView

+ (CUBlankView *)showBlankViewAddedTo:(UIView *)view;
+ (CUBlankView *)showBlankViewAddedTo:(UIView *)view text:(NSString *)text;

+ (BOOL)hideAllBlankViewForView:(UIView *)view;

@property (nonatomic, copy) NSString *labelText;

@end
