//
//  UserDropdownMenuView.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/25.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUUser.h"

@interface UserDropdownMenuView : UIView

@property (nonatomic, strong) CUUser *user;
@property (nonatomic, copy) CUCommomButtonAction dropdownBlock;
@property (nonatomic, copy) CUCommomButtonAction addBlock;

+ (CGFloat)defaultHeight;

- (void)update;

@end
