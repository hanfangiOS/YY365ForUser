//
//  SettingTextFeildView.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/20.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTextFeildView : UIView

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title;

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UITextField *contentTextFeild;
@property (nonatomic, strong) UIImageView *imageView;
@end
