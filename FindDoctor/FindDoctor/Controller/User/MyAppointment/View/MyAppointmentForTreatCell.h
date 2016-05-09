//
//  MyAppointmentForTreatCell.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/29.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUOrder.h"

@interface MyAppointmentForTreatCell : UITableViewCell

@property (strong,nonatomic)CUOrder       * data;

+ (float)kDefaultHeight;

@end