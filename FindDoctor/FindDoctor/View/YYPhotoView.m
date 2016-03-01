//
//  YYPhotoView.m
//  FindDoctor
//
//  Created by Guo on 15/11/6.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "YYPhotoView.h"
@interface YYPhotoView()<UIScrollViewDelegate>{
}

@end

@implementation YYPhotoView

@synthesize contentScrollView;
@synthesize baseViewArray;
@synthesize baseScrollViewArray;
@synthesize imageViewArray;
@synthesize pageControl;


- (instancetype)initWithPhotoArray:(NSMutableArray *)array numberOfClickedPhoto:(NSInteger)number{
    self = [super init];
    if (self) {
        if ((array.count == 0) || array == nil) {
            NSLog(@"图片array为空");
            return self;
        }
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        contentScrollView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.8];
        [contentScrollView setContentOffset:CGPointMake(0, 0)];
        contentScrollView.contentSize = CGSizeMake(kScreenWidth*array.count, kScreenHeight);
//        contentScrollView.bounces = NO;
        contentScrollView.pagingEnabled = YES;
        contentScrollView.delegate = self;
        contentScrollView.showsHorizontalScrollIndicator = NO;
        contentScrollView.showsVerticalScrollIndicator = NO;
        [contentScrollView setContentOffset:CGPointMake(kScreenWidth*number, 0)];
        [self addSubview:contentScrollView];
        
        pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, kScreenHeight-50, kScreenWidth, 40)];
        pageControl.numberOfPages = array.count;
        pageControl.currentPage = number;
        pageControl.userInteractionEnabled = NO;
        [pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
        if (array.count != 1) {
            [self addSubview:pageControl];
        }


        baseViewArray = [NSMutableArray new];
        baseScrollViewArray = [NSMutableArray new];
        imageViewArray = [NSMutableArray new];
        
        for (NSInteger i = 0; i < array.count; i++) {
            UIImage *image = (UIImage *)[array objectAtIndex:i];
            
            UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, kScreenHeight)];
            baseView.userInteractionEnabled = YES;
            NSLog(@"%@",baseView);
            [baseViewArray addObjectSafely:baseView];
            [contentScrollView addSubview:baseView];
            
            YYPhotoScrollView *baseScrollView = [[YYPhotoScrollView alloc]init];
            baseScrollView.tag = i;
            baseScrollView.delegate = self;
            baseScrollView.photoWidth = image.size.width;
            baseScrollView.photoHeight = image.size.height;
            baseScrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            baseScrollView.userInteractionEnabled = YES;
            baseScrollView.showsHorizontalScrollIndicator = NO;
            baseScrollView.showsVerticalScrollIndicator = NO;
            [baseScrollViewArray addObjectSafely:baseScrollView];
            [baseView addSubview:baseScrollView];
            
            baseScrollView.imageView = [[UIImageView alloc]initWithImage:image];
            baseScrollView.imageView.userInteractionEnabled = YES;
            baseScrollView.imageView.tag = i;
//            baseScrollView.imageView.backgroundColor = [UIColor whiteColor];
//            baseScrollView.backgroundColor = [UIColor blueColor];
            if ((kScreenWidth > baseScrollView.photoWidth)&&(kScreenHeight > baseScrollView.photoHeight)) {
                NSLog(@"图太小了啊");
                baseScrollView.scrollMinZoomScale = 0.5;
                baseScrollView.initialImageViewRect = CGRectMake((kScreenWidth - baseScrollView.photoWidth*baseScrollView.scrollMinZoomScale*2)*0.5, (kScreenHeight - baseScrollView.photoHeight*baseScrollView.scrollMinZoomScale*2)*0.5, baseScrollView.photoWidth*2,baseScrollView.photoHeight*2 );
                baseScrollView.imageView.frame = baseScrollView.initialImageViewRect;
                [baseScrollView setMinimumZoomScale:baseScrollView.scrollMinZoomScale];
                [baseScrollView setZoomScale:baseScrollView.scrollMinZoomScale];
            } else{
                if (image.size.height*kScreenWidth > image.size.width*kScreenHeight) {
                    NSLog(@"高度卡死到kScreenHeight");
                    baseScrollView.scrollMinZoomScale = kScreenHeight/baseScrollView.photoHeight/2;
                    baseScrollView.initialImageViewRect = CGRectMake((kScreenWidth - baseScrollView.photoWidth * baseScrollView.scrollMinZoomScale*2)*0.5, 0, baseScrollView.photoWidth*2,baseScrollView.photoHeight*2 );
                    baseScrollView.imageView.frame = baseScrollView.initialImageViewRect;
                    
                    [baseScrollView setMinimumZoomScale:baseScrollView.scrollMinZoomScale];
                    [baseScrollView setZoomScale:baseScrollView.scrollMinZoomScale];
                }
                else{
                    NSLog(@"宽度卡死到kScreenWidth");
                    baseScrollView.scrollMinZoomScale = kScreenWidth/image.size.width/2;
                    baseScrollView.initialImageViewRect = CGRectMake(0, (kScreenHeight - baseScrollView.photoHeight*baseScrollView.scrollMinZoomScale*2)*0.5, baseScrollView.photoWidth*2,baseScrollView.photoHeight*2 );
                    baseScrollView.imageView.frame = baseScrollView.initialImageViewRect;
                    
                    [baseScrollView setMinimumZoomScale:baseScrollView.scrollMinZoomScale];
                    [baseScrollView setZoomScale:baseScrollView.scrollMinZoomScale];
                }
            }
            baseScrollView.maximumZoomScale = 2.0;
            [imageViewArray addObjectSafely:baseScrollView.imageView];
            [baseScrollView addSubview:baseScrollView.imageView];
            // 在baseView上添加单机、双击手势
            UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleSingleFingerEvent:)];
            tapGesture1.numberOfTapsRequired = 1;
            tapGesture1.numberOfTouchesRequired = 1;
            [baseView addGestureRecognizer:tapGesture1];
            tapGesture1.view.tag = i;
            
            UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleSingleFingerEvent:)];
            tapGesture2.numberOfTapsRequired = 2;
            tapGesture1.numberOfTouchesRequired = 1;
            [baseView addGestureRecognizer:tapGesture2];
            tapGesture2.view.tag = i;
            [tapGesture1 requireGestureRecognizerToFail:tapGesture2];
            
            NSLog(@"tapGesture1.view.tag = %d, tapGesture2.view.tag = %d,i = %d",tapGesture1.view.tag,tapGesture2.view.tag,i);
        }
        
        [UIView animateWithDuration:1 delay:3 options:UIViewAnimationOptionLayoutSubviews animations:^{
            pageControl.alpha = 0;
        } completion:nil];

    }
    return self;
}

- (void)closeYYPhotoView{
    [self removeFromSuperview];
}

- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender{
    NSInteger i = sender.view.tag;
    NSLog(@"%d",i);
    if (sender.numberOfTapsRequired == 1) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:5.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished){
            [self closeYYPhotoView];
        }];
    }
    else if (sender.numberOfTapsRequired == 2 )  {
        YYPhotoScrollView *scrollView = (YYPhotoScrollView *)[baseScrollViewArray objectAtIndex:i];
        NSLog(@"%@",scrollView);
        if (scrollView.zoomScale == scrollView.scrollMinZoomScale) {
            CGRect zoomRect = [self zoomRectForScale:(scrollView.scrollMinZoomScale*2) withCenter:[sender locationInView:sender.view]];
            
            CGRect frame = scrollView.imageView.frame;
            if (kScreenHeight > scrollView.photoHeight*scrollView.scrollMinZoomScale*2*2) {
                NSLog(@"照片高度填不满屏幕");
                frame.origin.y = (kScreenHeight - scrollView.photoHeight * scrollView.scrollMinZoomScale*2*2)*0.5;
            }else{
                NSLog(@"照片高度可以填满屏幕");
                frame.origin.y = 0;
            }
            
            if (kScreenWidth > scrollView.photoWidth*scrollView.scrollMinZoomScale*2*2) {
                NSLog(@"照片宽度填不满屏幕");
                frame.origin.x = (kScreenWidth - scrollView.photoWidth * scrollView.scrollMinZoomScale*2*2)*0.5;
                scrollView.imageView.frame = frame;
            }else{
                NSLog(@"照片宽度可以填满屏幕");
                frame.origin.x = 0;
            }
            
            [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionLayoutSubviews animations:^{
                scrollView.imageView.frame = frame;
                [scrollView zoomToRect:zoomRect animated:YES];

            } completion:nil];
        }
        else{
            CGRect zoomRect = [self zoomRectForScale:(scrollView.scrollMinZoomScale) withCenter:[sender locationInView:sender.view]];
            
            CGRect frame = scrollView.imageView.frame;
            if (kScreenHeight > scrollView.photoHeight*scrollView.scrollMinZoomScale*2) {
                NSLog(@"照片高度填不满屏幕");
                frame.origin.y = (kScreenHeight - scrollView.photoHeight * scrollView.scrollMinZoomScale*2)*0.5;
            }else{
                NSLog(@"照片高度可以填满屏幕");
                frame.origin.y = 0;
            }
            
            if (kScreenWidth > scrollView.photoWidth*scrollView.scrollMinZoomScale*2) {
                NSLog(@"照片宽度填不满屏幕");
                frame.origin.x = (kScreenWidth - scrollView.photoWidth * scrollView.scrollMinZoomScale*2)*0.5;
                scrollView.imageView.frame = frame;
            }else{
                NSLog(@"照片宽度可以填满屏幕");
                frame.origin.x = 0;
            }
            
            [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionLayoutSubviews animations:^{
                scrollView.imageView.frame = frame;
                [scrollView zoomToRect:zoomRect animated:YES];
                
            } completion:nil];
        }
        
    }
    
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    YYPhotoScrollView *tempScrollView = (YYPhotoScrollView *)scrollView;
    return tempScrollView.imageView;
}

//放大完毕中
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    NSInteger i = scrollView.tag;
    NSLog(@"放大完毕调用函数");
    YYPhotoScrollView *YYscrollView = (YYPhotoScrollView *)[baseScrollViewArray objectAtIndex:i];
    
    // 适配照片位置
    CGRect frame = YYscrollView.imageView.frame;
    if (kScreenHeight > YYscrollView.photoHeight*scale*2) {
        NSLog(@"照片高度填不满屏幕");
        frame.origin.y = (kScreenHeight - YYscrollView.photoHeight * scale*2)*0.5;
    }else{
        NSLog(@"照片高度可以填满屏幕");
        frame.origin.y = 0;
    }

    if (kScreenWidth > YYscrollView.photoWidth*scale*2) {
        NSLog(@"照片宽度填不满屏幕");
        frame.origin.x = (kScreenWidth - YYscrollView.photoWidth * scale*2)*0.5;
        YYscrollView.imageView.frame = frame;
    }else{
        NSLog(@"照片宽度可以填满屏幕");
        frame.origin.x = 0;
    }
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:0 animations:^{
        YYscrollView.imageView.frame = frame;
    } completion:nil];


}

//开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == contentScrollView) {
        NSLog(@"%f",pageControl.alpha);
        pageControl.alpha = 1;
        [UIView animateWithDuration:1 delay:3 options:UIViewAnimationOptionLayoutSubviews animations:^{
                pageControl.alpha = 0;
        } completion:^(BOOL finished){}];


    }

}


//减速停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == contentScrollView) {
        //设置PageControl页数
        NSInteger currentPageNumber = pageControl.currentPage ;
        NSLog(@"起始页 页数：%d",pageControl.currentPage );
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.frame;
        [pageControl setCurrentPage:offset.x / bounds.size.width];
        NSLog(@"停止页 页数 ：%d",pageControl.currentPage);
        
        //设置放大为初始值
        
        if (currentPageNumber != pageControl.currentPage) {
            NSInteger number = [baseScrollViewArray count];
            NSLog(@"调用的ScrollView代理减速停止");
            for (int i = 0; i < number; i++) {
                YYPhotoScrollView *YYscrollView = (YYPhotoScrollView *)[baseScrollViewArray objectAtIndex:i];
                if (YYscrollView.zoomScale != YYscrollView.scrollMinZoomScale) {
                    YYscrollView.zoomScale = YYscrollView.scrollMinZoomScale;
                    // 适配照片位置
                    CGRect frame = YYscrollView.imageView.frame;
                    if (kScreenHeight > YYscrollView.photoHeight*YYscrollView.scrollMinZoomScale*2) {
                        NSLog(@"第 %d 照片高度填不满屏幕",i);
                        frame.origin.y = (kScreenHeight - YYscrollView.photoHeight * YYscrollView.scrollMinZoomScale*2)*0.5;
                    }else{
                        NSLog(@"第 %d 照片高度可以填满屏幕",i);
                        frame.origin.y = 0;
                    }
                    
                    if (kScreenWidth > YYscrollView.photoWidth*YYscrollView.scrollMinZoomScale*2) {
                        NSLog(@"第 %d 照片宽度填不满屏幕",i);
                        frame.origin.x = (kScreenWidth - YYscrollView.photoWidth * YYscrollView.scrollMinZoomScale*2)*0.5;
                        YYscrollView.imageView.frame = frame;
                    }else{
                        NSLog(@"第 %d 照片宽度可以填满屏幕",i);
                        frame.origin.x = 0;
                    }
                    YYscrollView.imageView.frame = frame;
                    
                }
            }
        }
        
    }

}

// 这个是点击的时候设置放大点击中点的
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x/scale*2 - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y/scale*2 - (zoomRect.size.height / 2.0);
    return zoomRect;
}


- (void)pageChange:(UIPageControl *)sender{
    NSInteger number = [baseScrollViewArray count];
    //令UIScrollView做出相应的滑动显示
    CGSize viewSize = contentScrollView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [contentScrollView scrollRectToVisible:rect animated:YES];
    
    NSLog(@"调用的pageChange");
    for (int i = 0; i < number; i++) {
        YYPhotoScrollView *scrollView = (YYPhotoScrollView *)[baseScrollViewArray objectAtIndex:i];
        if (scrollView.zoomScale != scrollView.scrollMinZoomScale){
            if ((kScreenWidth > scrollView.photoWidth)&&(kScreenHeight > scrollView.photoHeight)) {
                NSLog(@"图太小了啊");
                scrollView.imageView.frame = scrollView.initialImageViewRect;
                [scrollView setMinimumZoomScale:scrollView.scrollMinZoomScale];
                [scrollView setZoomScale:scrollView.scrollMinZoomScale];
            } // 图很小
            else{
                if(scrollView.photoHeight*kScreenWidth > scrollView.photoWidth*kScreenHeight){
                    CGRect frame = scrollView.imageView.frame;
                    frame.origin.x = (kScreenWidth - scrollView.photoWidth *scrollView.scrollMinZoomScale*2)*0.5;
                    scrollView.imageView.frame = frame;
                    [scrollView setZoomScale:scrollView.scrollMinZoomScale];
                } // 高度超过屏幕
                else{
                    CGRect frame = scrollView.imageView.frame;
                    frame.origin.y = (kScreenHeight - scrollView.photoHeight *scrollView.scrollMinZoomScale*2)*0.5;
                    scrollView.imageView.frame = frame;
                    [scrollView setZoomScale:scrollView.scrollMinZoomScale];
                } // 宽度超过屏幕
            }
        

        }
    }
}


@end

@implementation YYPhotoScrollView

@end
