//
//  CUOrderDetailViewController.h
//  CollegeUnion
//
//  Created by li na on 15/3/5.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUViewController.h"
#import "CUOrder.h"

@interface CUOrderDetailViewController : CUViewController

@property (nonatomic,strong) CUOrder * order;
@property BOOL isConfirmOrder;

- (instancetype)initWithPageName:(NSString *)pageName order:(CUOrder *)order;

@end
