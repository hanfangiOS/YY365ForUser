//
//  StarRatingView.m
//  CommentTest
//
//  Created by zhouzhenhua on 14-9-7.
//  Copyright (c) 2014年 zhouzhenhua. All rights reserved.
//

#import "StarRatingView.h"

@interface StarRatingView ()

@end

@implementation StarRatingView
{
    StarType     _type;
    CGFloat      _starSpace;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numberOfStar:kImageCount type:StarTypeSmall];
}

- (id)initWithFrame:(CGRect)frame type:(StarType)type
{
    return [self initWithFrame:frame numberOfStar:kImageCount type:type];
}

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number type:(StarType)type
{
    float imageSpace = (type == StarTypeLarge) ? kImageSpace_B : kImageSpace_S;
    return [self initWithFrame:frame numberOfStar:number type:type starSpace:imageSpace];
}

- (id)initWithFrame:(CGRect)frame type:(StarType)type starSpace:(CGFloat)space
{
    return [self initWithFrame:frame numberOfStar:kImageCount type:type starSpace:space];
}

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number type:(StarType)type starSpace:(CGFloat)space
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _numberOfStar = number;
        _type = type;
        _starSpace = space;
        
        [self setRate:0];
        self.editable = NO;
        
        [self initSubviews];
        
        self.frame = CGRectMake(self.frameX, self.frameY,((_type == StarTypeLarge) ? kImageWidth_B : kImageWidth_S)*5 + space*4 , (_type == StarTypeLarge) ? kImageWidth_B : kImageWidth_S);
    }
    return self;
}

+ (float)defaultWidth
{
    return 120;
}

- (void)initSubviews
{
    CGRect frame = self.bounds;
    
    float imageWidth = (_type == StarTypeLarge) ? kImageWidth_B : kImageWidth_S;
    float imageSpace = _starSpace;// (_type == StarTypeLarge) ? kImageSpace_B : kImageSpace_S;
    for (int i = 0; i < _numberOfStar; i ++)
    {
        UIButton *imageView = [UIButton buttonWithType:UIButtonTypeCustom];
        imageView.frame = CGRectMake(i * (imageWidth + imageSpace), 0, imageWidth, imageWidth);
        imageView.tag = i + 1;
        imageView.adjustsImageWhenHighlighted = NO;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        imageView.userInteractionEnabled = NO;
        [self addSubview:imageView];
    }
}

- (void)setRate:(float)rate
{
    if (rate < 0) {
        rate = 0;
    }
    if (rate > _numberOfStar) {
        rate = _numberOfStar;
    }
    
    _rate = rate;
    
    for (int i = 0; i < _numberOfStar; i ++) {
        UIButton *imageView = (UIButton *)[self viewWithTag:i + 1];
        if (imageView.tag <= _rate) {
            [imageView setImage:[self fullImage] forState:UIControlStateNormal];
        }
        else {
            if ((float)imageView.tag - _rate <= 0.5) {
                [imageView setImage:[self halfImage] forState:UIControlStateNormal];
            }
            else {
                [imageView setImage:[self blankImage] forState:UIControlStateNormal];
            }
        }
    }
}

- (UIImage *)fullImage
{
    return [UIImage imageNamed:(_type == StarTypeLarge) ? kStarImageFull_B : kStarImageFull_S];
}

- (UIImage *)halfImage
{
    return [UIImage imageNamed:(_type == StarTypeLarge) ? kStarImageHalf_B : kStarImageHalf_S];
}

- (UIImage *)blankImage
{
    return [UIImage imageNamed:(_type == StarTypeLarge) ? kStarImageBlank_B : kStarImageBlank_S];
}

- (void)setEditable:(BOOL)editable
{
    self.userInteractionEnabled = editable;
}

- (void)tapImage:(NSInteger)tempRate{
    self.rate = tempRate;
    
    if ([self.delegate respondsToSelector:@selector(starRatingView:rateDidChange:)]) {
        [self.delegate starRatingView:self rateDidChange:self.rate];
    }
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event{
    CGPoint point=[touch locationInView:self];
    int tempRate = point.x/((_type == StarTypeLarge) ? kImageWidth_B : kImageWidth_S + _starSpace);
    if (tempRate < 0) {
        tempRate = 0;
    }
    if (tempRate > kImageCount) {
        tempRate = kImageCount;
    }
    [self tapImage:tempRate+0.5];
    return [super continueTrackingWithTouch:touch withEvent:event];
}


@end
