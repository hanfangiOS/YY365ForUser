//
//  SearchViewController.h
//  
//
//  Created by yutao on 14-9-22.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNViewController.h"

typedef void(^DoctorSearchAction)(NSString *keyword);

@interface DoctorSearchController : SNViewController

@property (nonatomic, copy) DoctorSearchAction action;

@end
