//
//  DoctorCellContentView.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Doctor.h"

@interface DoctorCellContentView : UIView

@property (nonatomic, strong) Doctor *data;

- (void)hilight;
- (void)normal;

@end
