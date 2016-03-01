//
//  YYPhotoView.h
//  FindDoctor
//
//  Created by Guo on 15/11/6.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYPhotoView : UIView

- (instancetype)initWithPhotoArray:(NSMutableArray *)array numberOfClickedPhoto:(NSInteger)number;


@property (strong,nonatomic)    UIScrollView *contentScrollView;
@property (strong,nonatomic)    UIPageControl *pageControl;
@property (strong,nonatomic)    NSMutableArray *baseViewArray;
@property (strong,nonatomic)    NSMutableArray *baseScrollViewArray;
@property (strong,nonatomic)    NSMutableArray *imageViewArray;

@end


@interface YYPhotoScrollView : UIScrollView

@property  NSInteger photoWidth;
@property  NSInteger photoHeight;
@property  (strong,nonatomic)   UIImageView *imageView;
@property  float scrollMinZoomScale;
@property  CGRect initialImageViewRect;

@end