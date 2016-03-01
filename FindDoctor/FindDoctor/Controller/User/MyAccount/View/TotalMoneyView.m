//
//  TotalMoneyView.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/23.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "TotalMoneyView.h"

@interface TotalMoneyView(){
    int _diamater;
    NSString *_title;
    UILabel *feeLabel;
    UIColor *_color;
}

@end

@implementation TotalMoneyView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title color:(UIColor *)color{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0;
        _diamater = frame.size.height;
        _title = title;
        _color = color;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    UIView *incomeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _diamater, _diamater)];
    incomeView.clipsToBounds = YES;
    incomeView.layer.cornerRadius = _diamater/2.f;
    incomeView.layer.backgroundColor = _color.CGColor;
    [self addSubview:incomeView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frameHeight*3.5/9 - 5, self.frameWidth, self.frameHeight/9)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:self.frameHeight/9];
    titleLabel.text = _title;
    [incomeView addSubview:titleLabel];
    
    feeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frameHeight/2, self.frameWidth, 0)];
    feeLabel.textColor = [UIColor whiteColor];
    feeLabel.textAlignment = NSTextAlignmentCenter;
    [incomeView addSubview:feeLabel];
}

- (void)setFee:(NSString *)fee{
    _fee = fee;
    CGSize _size = CGSizeMake(self.frameWidth, 18);
    for (int i = self.frameHeight/4.5; i > 0; i--) {
        CGSize size = [self sizeWithString:_fee font:[UIFont systemFontOfSize:i] lableWith:sqrt(self.frameWidth*self.frameWidth + i * i)];
        if (i *1.5 > size.height) {
            feeLabel.text = _fee;
            feeLabel.font = [UIFont systemFontOfSize:i];
            feeLabel.textAlignment = NSTextAlignmentCenter;
            feeLabel.frame = CGRectMake(feeLabel.frameX + (feeLabel.frameWidth - size.width)/2,feeLabel.frameY , size.width, size.height);
            _size = size;
            break;
        }
    }
}

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font lableWith:(CGFloat)lableWith{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(lableWith, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

- (void)show{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 1;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05f, 1.05f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:popAnimation forKey:nil];
    
    self.alpha = 0;
    
    [UIView animateWithDuration:1
                     animations:^{
                         self.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

@end
