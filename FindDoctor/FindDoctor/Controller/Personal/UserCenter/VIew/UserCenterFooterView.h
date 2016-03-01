//
//  UserCenterFooterView.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/19.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UserCenterFooterAction)(NSInteger index);

@interface UserCenterFooterView : UIView

@property (nonatomic, copy) UserCenterFooterAction clickAction;

+ (CGFloat)defaultHeight;

@end
