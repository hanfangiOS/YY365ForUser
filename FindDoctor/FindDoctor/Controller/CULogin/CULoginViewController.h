//
//  LoginViewController.h
//  iCar
//
//  Created by yutao on 14-9-14.
//  Copyright (c) 2014年 yutao. All rights reserved.
//

#import "CUViewController.h"
#import "CULoginView.h"

@interface CULoginViewController : CUViewController
{
    UIImageView *headerImage;
}

SINGLETON_DECLARE(CULoginViewController);

@property (nonatomic, strong) NSString *navTitle;
@property BOOL verifyCode;
@property BOOL hasPassword;

@property CGFloat intervalY;

@property (nonatomic,strong) CULoginView * loginView;

- (void)confirmButtonAction;
- (void)backToRoot;
- (void)endEditing;

- (void)loadHeaderImage;

@end
