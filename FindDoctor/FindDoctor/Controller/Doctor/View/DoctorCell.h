//
//  DoctorCell.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctorCellContentView.h"

@interface DoctorCell : UITableViewCell

+ (CGFloat)defaultHeight;

@property (nonatomic, strong) DoctorCellContentView * cellContentView;

@end
