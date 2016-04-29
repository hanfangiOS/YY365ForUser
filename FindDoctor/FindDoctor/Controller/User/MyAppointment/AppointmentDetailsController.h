//
//  AppointmentDetailsController.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/18.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "CUViewController.h"
#import "CUOrder.h"

@interface AppointmentDetailsController : CUViewController

@property (strong,nonatomic)CUOrder * order;

@property (strong,nonatomic)NSString * from;

@end
