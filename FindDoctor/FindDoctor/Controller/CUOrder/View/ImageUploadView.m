//
//  ImageUploadView.m
//  CommentTest
//
//  Created by zhouzhenhua on 14-9-7.
//  Copyright (c) 2014年 zhouzhenhua. All rights reserved.
//

#import "ImageUploadView.h"

#define kDefaultHeight     70.0

#define kButtonCount       3

#define kPadding           10.0

#define kButtonWidth       60.0

@implementation ImageUploadView
{
    NSArray    *_imageArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        [self initSubviews];
    }
    return self;
}

+ (float)defaultHeight
{
    return kDefaultHeight;
}

- (void)initSubviews
{
    float width = CGRectGetWidth(self.frame) / kButtonCount;
    float height = CGRectGetHeight(self.frame);
    
    for (int i = 0; i < kButtonCount; i ++) {
        CGRect buttonRect = CGRectInset(CGRectMake(i * width, 0, width, height),kPadding, 0);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = buttonRect;
        button.tag = [self tagAtIndex:i];
        button.backgroundColor = [UIColor whiteColor];
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        button.clipsToBounds = YES;
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)reloadWithImages:(NSArray *)images
{
    _imageArray = images;
    
    for (int i = 0; i < kButtonCount; i ++) {
        UIButton *button = (UIButton *)[self viewWithTag:[self tagAtIndex:i]];
        
        if (i < _imageArray.count) {
            [button setImage:[_imageArray objectAtIndex:i] forState:UIControlStateNormal];
            [button setImage:[_imageArray objectAtIndex:i] forState:UIControlStateHighlighted];
        }
        else {
            [button setImage:[UIImage imageNamed:@"image_btn_add_nor"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"image_btn_add_sel"] forState:UIControlStateHighlighted];
            
            button.layer.borderWidth = kDefaultLineHeight;
            button.layer.borderColor = kLightLineColor.CGColor;
        }
    }
}

- (void)buttonPress:(UIButton *)button
{
    int index = (int)button.tag - 100;
    
    if (index < _imageArray.count) {
        if ([self.delegate respondsToSelector:@selector(didClickToBrowseImageAtIndex:)]) {
            [self.delegate didClickToBrowseImageAtIndex:index];
        }
    }
    else {
        if ([self.delegate respondsToSelector:@selector(didClickToAddImage)]) {
            [self.delegate didClickToAddImage];
        }
    }
}

- (int)tagAtIndex:(int)index
{
    return index + 100;
}

@end
