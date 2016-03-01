//
//  DoctorApoointmentForHourScrollView.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/19.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Doctor.h"
#import "CUPageControl.h"

@interface DoctorApoointmentForHourScrollView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong)  Doctor *data;
@property (nonatomic, strong) CUPageControl *pageControl;

- (instancetype)initWithFrame:(CGRect)frame data:(Doctor *)data;

@end
