//
//  GXWHeaderView.h
//  FindDoctor
//
//  Created by Guo on 15/8/25.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleView : UIView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

@property(strong,nonatomic) UILabel *headerLabel;



@end
