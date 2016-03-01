//
//  OrderCreateController.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/24.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUViewController.h"
#import "CUOrder.h"

@class Doctor;

@interface OrderCreateController : CUViewController

@property (nonatomic, strong) Doctor *doctor;
@property (nonatomic, strong) NSMutableArray *memberArray;
@property (nonatomic, strong) CUOrder *order;

@end
