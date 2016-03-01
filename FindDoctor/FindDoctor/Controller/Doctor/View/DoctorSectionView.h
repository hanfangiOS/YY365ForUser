//
//  DoctorSectionView.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Doctor.h"

typedef void(^DoctorSectionAction)(void);

@interface DoctorSectionView : UIView

@property (nonatomic, strong) Doctor *data;
@property (nonatomic, copy) DoctorSectionAction clickBlock;

+ (CGFloat)defaultHeight;

@end
