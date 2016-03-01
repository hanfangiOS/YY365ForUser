//
//  BlueDotLabelInDoctorHeaderView.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/1/11.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlueDotLabelInDoctorHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title contents:(NSString *)contents unit:(NSString *)unit hasDot:(BOOL)hasDot;
- (void)resetTitle:(NSString *)title contents:(NSString *)contents unit:(NSString *)unit;

@end
