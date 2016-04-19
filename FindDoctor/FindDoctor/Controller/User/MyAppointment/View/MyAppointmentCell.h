//
//  MyAppointmentCell.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/18.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUOrder.h"

typedef void(^clickPayBtn)(void);

@interface MyAppointmentCell : UITableViewCell

@property (strong,nonatomic)CUOrder       * data;

@property (copy,nonatomic)clickPayBtn       clickPayBtn;

+ (CGFloat)defaultHeight;

@end
