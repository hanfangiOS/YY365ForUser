//
//  DoctorHeaderView.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Doctor.h"
#import "DoctorDetailController.h"

typedef void(^CommentBlock)(void);

@interface DoctorHeaderView : UIView

@property (nonatomic, strong) Doctor *data;
@property (nonatomic, strong) UILabel *dateLable;
@property (nonatomic, copy) CommentBlock commentBlock;

@property (nonatomic, strong)DoctorDetailController * fatherVC;


+ (CGFloat)defaultHeight;

@end
