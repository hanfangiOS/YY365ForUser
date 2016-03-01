//
//  CUPasswordViewController.h
//  FindDoctor
//
//  Created by Tom Zhang on 15/11/21.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CUViewController.h"
#import "CUPasswordView.h"

@interface CUPasswordViewController : CUViewController

SINGLETON_DECLARE(CUPasswordViewController);

@property (nonatomic, strong) NSString *navTitle;
@property BOOL hasVerify;
@property BOOL hasOldPassword;

@property (nonatomic,strong) CUPasswordView * passwordView;

- (void)confirmButtonAction;
//- (void)backToRoot;
- (void)endEditing;

@end
