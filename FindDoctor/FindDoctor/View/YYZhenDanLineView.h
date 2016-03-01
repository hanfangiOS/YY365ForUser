//
//  YYZhenDanLineView.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/27.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYZhenDanLineView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentTextLabel;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setTitle:(NSString *)title;
- (void)setContentText:(NSString *)contentText;
- (CGFloat)getframeHeight;

@end
