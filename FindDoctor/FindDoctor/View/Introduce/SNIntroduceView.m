//
//  SNIntroduceView.m
//  SinaNews
//
//  Created by Nova on 13-4-21.
//  Modified by zhenhua on 13-12-16.
//  Copyright (c) 2013年 sina. All rights reserved.
//

#import "SNIntroduceView.h"
#import "UIImage+Compatible.h"
#import "AppDelegate.h"

#define Is_Screen_6s (CGRectGetHeight([[UIScreen mainScreen] bounds]) == 736.0)
#define Is_Screen_6  (CGRectGetHeight([[UIScreen mainScreen] bounds]) == 667.0)
#define Is_Screen_4  (CGRectGetHeight([[UIScreen mainScreen] bounds]) == 568.0)
#define Is_Screen_3  (CGRectGetHeight([[UIScreen mainScreen] bounds]) == 480.0)

#define kSNIntroduceViewIntroduceImagesPlist      @"Introduce_Images.plist"

#define kSNIntroduceViewPageControlBottomPadding  20
#define kSNIntroduceViewHideButton4BottomPadding  45
#define kSNIntroduceViewHideButton5BottomPadding  70

#define kSNIntroduceViewHideButtonWidth           175

#define kSNBandingButtonFontSize  13
#define kSNBandingButtonColor     [UIColor colorWithHex:0x666666]
#define kSNBandingButtonWidth     108
#define kSNBandingButtonHeight    17
#define kStartBtnTopMargin        10
#define kTopMargin                (Is_Screen_4 ? 27 : 0)

#define kHideAnimationDuration    0.4
#define kScrollViewAddtionalSpace 0.5

#define kTagArrowImage              301
#define kArrowAnimationDelatY       6
#define kYOffsetPhone4              82      // phone4 的偏移
#define kYOffset4Inch               112      // 4英寸屏的偏移
#define kButtonYOffsetPhone4        50
#define kButtonYOffset4Inch         75
#define kArrowAnimationDuration     0.5
#define kArrowAnimationRepeatCount  4

#define kIntroduceScrollViewHorizontal      //是否是横向
#define kIntroduceScrollViewPagingEnable    //是否paging

@interface SNIntroduceView ()
{
    NSArray *_introduceImageNames;
    UIButton * _btn;
}

- (void)initIntroduceMainScrollView;

- (void)mainScrollViewDidChangeContentOffset:(CGPoint)newContentOffset;

@end

static UIWindow *window = nil;

@implementation SNIntroduceView

@synthesize complete = _complete;

#pragma mark life cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _introduceImageNames = [[NSArray alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:kSNIntroduceViewIntroduceImagesPlist]];
        [self initBtn];
        [self initIntroduceMainScrollView];
        [self initPageControl];
        
    }
    
    return self;
}

- (void)dealloc
{
    
}


#pragma mark

- (void)initBtn{
    _btn = [[UIButton alloc] init];
    CGFloat width = CGRectGetWidth(self.bounds)*(375 - 76*2)/375.f;
    CGFloat height = CGRectGetHeight(self.bounds)*48.f/667;
    [_btn setTitle:@"开启轻松之旅" forState:UIControlStateNormal];
    _btn.frame = CGRectMake(CGRectGetWidth(self.bounds)*76/375.f, CGRectGetHeight(self.bounds)*488/667.f, width, height);
    _btn.layer.borderColor = [UIColor whiteColor].CGColor;
    _btn.layer.borderWidth = 1.f;
    _btn.layer.cornerRadius = 13.f;
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btn.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBtn)];
    [_btn addGestureRecognizer:tap];
}

- (void)clickBtn{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AfterFirstView" object:self userInfo:nil];
}

- (void)initIntroduceMainScrollView
{
    _introduceMainScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _introduceMainScrollView.backgroundColor = [UIColor clearColor];
    _introduceMainScrollView.scrollEnabled = YES;
#ifdef kIntroduceScrollViewPagingEnable
    _introduceMainScrollView.pagingEnabled = YES;
#endif
    _introduceMainScrollView.showsHorizontalScrollIndicator = NO;
    _introduceMainScrollView.showsVerticalScrollIndicator = NO;
    _introduceMainScrollView.bounces = NO;
    
#ifdef kIntroduceScrollViewHorizontal
    _introduceMainScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * _introduceImageNames.count + kScrollViewAddtionalSpace, CGRectGetHeight(self.bounds));
#else
    _introduceMainScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) * [_introduceImageNames count] + kScrollViewAddtionalSpace);
#endif
    _introduceMainScrollView.delegate = self;
    [self addSubview:_introduceMainScrollView];
    
    CGRect introduceImageViewFrame = _introduceMainScrollView.bounds;
    CGFloat width = CGRectGetWidth(introduceImageViewFrame);
    CGFloat height = CGRectGetHeight(introduceImageViewFrame);
    CGFloat count = [_introduceImageNames count];
    for (int i = 0; i < count; i++)
    {
        NSString *introduceImageName = [_introduceImageNames objectAtIndex:i];
        NSString *imageExtension = [introduceImageName pathExtension];
        if (imageExtension.length == 0) {
            imageExtension = @"png";
        }
        NSString *imageName = [introduceImageName stringByDeletingPathExtension];
        //        imageName = [self compatibleImageName:imageName];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:imageExtension];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        UIImageView *introduceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        introduceImageView.image = image;
#ifdef kIntroduceScrollViewHorizontal
        introduceImageViewFrame.origin.x = i * width;
#else
        introduceImageViewFrame.origin.y = i * height;
#endif
        introduceImageView.frame = introduceImageViewFrame;
        if (i == count - 1) {
            introduceImageView.userInteractionEnabled = YES;
            [introduceImageView addSubview:_btn];
        }
        [_introduceMainScrollView addSubview:introduceImageView];
    }
}

- (void)initPageControl
{
//    _introducePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame) - 48 - kTopMargin, CGRectGetWidth(self.bounds), kTopMargin)];
    _introducePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) * (667 - 49)/667.f, CGRectGetWidth(self.bounds), 0)];
    _introducePageControl.userInteractionEnabled = NO;
    _introducePageControl.backgroundColor = [UIColor clearColor];
    _introducePageControl.numberOfPages = _introduceImageNames.count - 1;
    _introducePageControl.currentPage = 0;
    _introducePageControl.hidesForSinglePage = YES;
    [self addSubview:_introducePageControl];
}

#pragma mark Class method

+ (void)showWithCompleteInMoreTab:(void (^)(SNIntroduceView *))complete
{
    [self showWithComplete:complete];
}

+ (void)showWithComplete:(void(^)(SNIntroduceView *introduceView))complete
{
//    if (!window)
//    {
//        SNIntroduceView *intro = [[SNIntroduceView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        intro.complete = complete;
//        window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        window.windowLevel = UIWindowLevelStatusBar + 1;
//        window.hidden = NO;
//        [window addSubview:intro];
//    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
#ifdef kIntroduceScrollViewHorizontal
    NSInteger index = floor(scrollView.contentOffset.x/CGRectGetWidth(scrollView.bounds));
#else
    NSInteger index = floor(scrollView.contentOffset.y/CGRectGetHeight(scrollView.bounds));
#endif
    _introducePageControl.currentPage = index;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint contentOffset = scrollView.contentOffset;
    [self mainScrollViewDidChangeContentOffset:contentOffset];
}

- (void)mainScrollViewDidChangeContentOffset:(CGPoint)newContentOffset
{
    // 向右 or 向下 滑动并静止
#ifdef kIntroduceScrollViewHorizontal
    //该偏移量为所有图片－1张图
    CGFloat xOffset2 = CGRectGetWidth(self.bounds)*(MAX(0, _introduceImageNames.count-2));
    
    if(newContentOffset.x >= xOffset2+kScrollViewAddtionalSpace){
        _introducePageControl.hidden = YES;
    }else{
        _introducePageControl.hidden = NO;
    }
    
    CGFloat xOffset = CGRectGetWidth(self.bounds)*(MAX(0, _introduceImageNames.count-1));
    if (newContentOffset.x >= xOffset+kScrollViewAddtionalSpace) {
        //        [self performSelectorOnMainThread:@selector(hide) withObject:nil waitUntilDone:NO];
       
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AfterFirstView" object:self userInfo:nil];
    }
#else
    CGFloat yOffset = CGRectGetHeight(self.bounds)*(MAX(0, _introduceImageNames.count-1));
    if (newContentOffset.y >= yOffset+kScrollViewAddtionalSpace) {
        //        [self performSelectorOnMainThread:@selector(hide) withObject:nil waitUntilDone:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AfterFirstView" object:self userInfo:nil];
    }
#endif
}

- (void)hide
{
    static BOOL isHidden = NO;
    if (!isHidden) {
        isHidden = YES;
        
        if (_complete) {
            _complete(self);
        }
        
        CGRect windowFrame = window.frame;
#ifdef kIntroduceScrollViewHorizontal
        windowFrame.origin.x = - (CGRectGetWidth(windowFrame) + 20);
#else
        windowFrame.origin.y = - (CGRectGetHeight(windowFrame) + 20);
#endif
        [UIView animateWithDuration:kHideAnimationDuration animations:^{
            window.frame = windowFrame;
        } completion:^(BOOL isFinish) {
            window.hidden = YES;
            window = nil;
            
            isHidden = NO;
        }];
    }
}

- (NSString *)compatibleImageName:(NSString *)name
{
    NSString *imageName = name;
    if (Is_Screen_3) {
        imageName = [NSString stringWithFormat:@"%@-480h",imageName];
    }
    else if (Is_Screen_6) {
        imageName = [NSString stringWithFormat:@"%@-667h",imageName];
    }
    
    if (Is_Screen_6s) {
        imageName = [NSString stringWithFormat:@"%@@3x",imageName];
    }
    else {
        imageName = [NSString stringWithFormat:@"%@@2x",imageName];
    }
    
    return imageName;
}

@end
