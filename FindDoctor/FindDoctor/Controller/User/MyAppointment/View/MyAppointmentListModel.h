//
//  MyAppointmentListModel.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/18.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "SNBaseListModel.h"
#import "CUOrder.h"

@interface MyAppointmentListModel : SNBaseListModel

@property (strong,nonatomic) OrderFilter * filter;

- (instancetype)initWithFilter:(OrderFilter *)filter;

@end
