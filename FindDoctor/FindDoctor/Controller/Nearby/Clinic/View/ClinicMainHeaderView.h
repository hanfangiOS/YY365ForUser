//
//  ClinicMainHeaderView.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/2/26.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clinic.h"

@interface ClinicMainHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic ,strong) Clinic *data;

@end
