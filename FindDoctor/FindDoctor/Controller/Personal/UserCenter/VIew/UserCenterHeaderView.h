//
//  UserCenterHeaderView.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/19.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUUser.h"

@interface UserCenterHeaderView : UIView

@property (nonatomic, strong) CUUser *user;

+ (CGFloat)defaultHeight;

@end
