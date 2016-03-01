//
//  CUViewController.h
//  CollegeUnion
//
//  Created by li na on 15/3/4.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNViewController.h"
#import "SNViewController+Nav.h"
#import "MBProgressHUD.h"

@interface CUViewController : SNViewController

@property (nonatomic,strong,readonly) UIView * contentView;
@property (nonatomic,assign)BOOL hasTab;
@property (nonatomic,strong)MBProgressHUD   * progressView;
@property (nonatomic,assign,readonly)CGFloat keybordHeight;

- (void)setShouldHaveTab;
- (void)loadNavigationBar;
- (void)loadContentView;
- (void)removeContentView;

@end

@interface CUViewController (HUD)

- (void)showProgressView;
- (void)hideProgressView;

@end

@interface CUViewController (keybord)

-(void)setViewMovedUp:(CGFloat)movedUpOffSet;
-(void)setViewMovedDown:(CGFloat)movedUpOffSet;

@end
