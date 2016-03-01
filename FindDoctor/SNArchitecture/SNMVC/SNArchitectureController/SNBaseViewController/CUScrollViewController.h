//
//  CUScrollViewController.h
//  CollegeUnion
//
//  Created by li na on 15/3/7.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "SNViewController.h"
#import "SNViewController+Nav.h"

@interface CUScrollViewController : SNViewController//<UIScrollViewDelegate>

//- (UIView *)contentView;

@property (nonatomic,strong,readonly) UIScrollView * contentView;
@property (strong,nonatomic)UIScrollView * scrollContentView;
@property (nonatomic,assign)BOOL hasTab;

- (void)setShouldHaveTab;
- (void)loadNavigationBar;
- (void)loadContentView;

- (BOOL)pullUp;// 上拉
- (BOOL)pullDown;// 下拉
- (BOOL)pullDownToTop;

@end

@interface CUScrollViewController (HUD)

- (void)showProgressView;
- (void)hideProgressView;

@end

@interface CUScrollViewController (keybord)

-(void)setViewMovedUp:(CGFloat)movedUpOffSet;


@end