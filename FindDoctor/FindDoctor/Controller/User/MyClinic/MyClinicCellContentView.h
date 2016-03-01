//
//  MyClinicCellContentView.h
//  FindMyClinic
//
//  Created by zhouzhenhua on 15/8/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clinic.h"

@interface MyClinicCellContentView : UIView

@property (nonatomic, strong) Clinic *data;

- (void)hilight;
- (void)normal;

@end
