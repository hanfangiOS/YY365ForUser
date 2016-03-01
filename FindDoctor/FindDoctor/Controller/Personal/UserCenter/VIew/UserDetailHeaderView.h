//
//  UserDetailHeaderView.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/19.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUUser.h"

@interface UserDetailHeaderView : UIView

@property (nonatomic, strong) CUUser *user;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, readonly) UITextField *nickField;
@property (nonatomic, readonly) UITextField *emailField;

@property (nonatomic, copy) CUCommomButtonAction clickAvatarBlock;
@property (nonatomic, copy) CUCommomButtonAction clickPasswordBlock;

+ (CGFloat)defaultHeight;

@end
