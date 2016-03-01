//
//  CUScrollViewController.m
//  CollegeUnion
//
//  Created by li na on 15/3/7.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUScrollViewController.h"
#import "CUUIContant.h"
#import "UIView+Extension.h"
#import "MBProgressHUD.h"
#import "UIImage+Color.h"

@interface CUScrollViewController ()

@property (nonatomic,assign)CGPoint tempContentOffset;
@property (nonatomic,strong)MBProgressHUD   * progressView;

@end

@implementation CUScrollViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromHex(Color_Hex_ContentViewBackground);
    
    
    [self setShouldHaveTab];
    
    // --------------------如果有nav则重新生成一个可视的view,跟loadContentView的顺序不可以改
    [self addScrollContentView];
    // --------------------子类执行以下方法
    self.navigationBar.shadowImage = [UIImage createImageWithColor:UIColorFromHex( Color_Hex_NavShadow)];
    [self loadNavigationBar];
    [self loadContentView];
}

- (void)loadNavigationBar
{
    
}

- (void)loadContentView
{
    
}

- (void)setShouldHaveTab
{
    self.hasTab = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addScrollContentView
{
    self.scrollContentView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollContentView];
    self.scrollContentView.frame = [self subviewFrame];
    self.scrollContentView.backgroundColor = UIColorFromHex(Color_Hex_ContentViewBackground);
//    self.scrollContentView.delegate = self;
    
     if (self.hasTab)
    {
        self.scrollContentView.frameHeight -= Height_Tabbar;
    }
    
//    self.scrollContentView.delegate = self;
    self.scrollContentView.showsVerticalScrollIndicator = NO;
    self.scrollContentView.showsHorizontalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.scrollContentView.contentSize = CGSizeMake(self..boundsWidth, self.scrollContentView.boundsHeight + 1);
    CGSize newSize = CGSizeMake(self.scrollContentView.frameWidth, self.scrollContentView.frameHeight);
    [self.scrollContentView setContentSize:newSize];
    
}



- (UIScrollView *)contentView
{
    return self.scrollContentView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)pullDownToTop
{
    BOOL down = NO;
    CGPoint offset1 = self.scrollContentView.contentOffset;
    CGRect bounds1 = self.scrollContentView.bounds;
    //    CGSize size1 = self.scrollContentView.contentSize;
    UIEdgeInsets inset1 = self.scrollContentView.contentInset;
    float y1 = offset1.y + bounds1.size.height - inset1.bottom;
    //    float h1 = size1.height;
    if (y1 < self.scrollContentView.frame.size.height && offset1.y < 0)
    {
        down = YES;
    }
    return down;
    
}


- (BOOL)pullUp
{
    BOOL up = NO;
    CGPoint offset1 = self.scrollContentView.contentOffset;
    CGRect bounds1 = self.scrollContentView.bounds;
//    CGSize size1 = self.scrollContentView.contentSize;
    UIEdgeInsets inset1 = self.scrollContentView.contentInset;
    float y1 = offset1.y + bounds1.size.height - inset1.bottom;
//    float h1 = size1.height;
    if (y1 > self.scrollContentView.frame.size.height)
    {
        up = YES;
    }
    return up;
    
}
- (BOOL)pullDown
{
    BOOL down = NO;
    CGPoint offset1 = self.scrollContentView.contentOffset;
    CGRect bounds1 = self.scrollContentView.bounds;
//    CGSize size1 = self.scrollContentView.contentSize;
    UIEdgeInsets inset1 = self.scrollContentView.contentInset;
    float y1 = offset1.y + bounds1.size.height - inset1.bottom;
//    float h1 = size1.height;
    if (y1 < self.scrollContentView.frame.size.height)
    {
        down = YES;
    }
    return down;
}


@end

@implementation CUScrollViewController (HUD)

- (void)showProgressView
{
    if (self.progressView == nil) {
        self.progressView = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        self.progressView.center = CGPointMake(CGRectGetWidth(self.contentView.bounds)/2.0, CGRectGetHeight(self.contentView.bounds)/2.0);
        [self.view addSubview:self.progressView];
        self.progressView.dimBackground = NO;
        self.progressView.opacity = 0.1;
    }
    
    [self.progressView show:YES];
    self.contentView.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    
}

- (void)hideProgressView
{
    [self.progressView hide:NO];
    self.contentView.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
}


@end

@implementation CUScrollViewController (keybord)

-(void)setViewMovedUp:(CGFloat)movedUpOffSet
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.contentView.frame;
    
    rect.origin.y -= movedUpOffSet;
    rect.size.height += movedUpOffSet;
    self.contentView.frame = rect;
    [UIView commitAnimations];
}

@end

