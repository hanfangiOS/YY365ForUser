//
//  MyClinicCell.h
//  FindMyClinic
//
//  Created by zhouzhenhua on 15/8/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyClinicCellContentView.h"

@interface MyClinicCell : UITableViewCell

+ (CGFloat)defaultHeight;

@property (nonatomic, strong) MyClinicCellContentView *cellContentView;

@end
