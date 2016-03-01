//
//  MapMechanicView.h
//  HuiYangChe
//
//  Created by zhouzhenhua on 14-12-13.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Doctor;

@interface MapMechanicView : UIView

@property (nonatomic, strong) Doctor *mechanic;

- (void)update;

+ (float)defaultWidth;
+ (float)defaultHeight;

@end
