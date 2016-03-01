//
//  MyDoctorListView.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/19.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Doctor.h"

typedef void(^MyDoctorDeleteAction)(NSInteger index);

@interface MyDoctorListView : UIView

@property (nonatomic, copy) CUCommomButtonAction clickBlock;
@property (nonatomic, copy) MyDoctorDeleteAction deleteBlock;

+ (CGFloat)defaultHeight;

- (void)reloadData:(NSArray *)dataArray;

@end
