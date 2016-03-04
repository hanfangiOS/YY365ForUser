//
//  MyDiagnosisRecordsDetailViewController.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/27.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CUViewController.h"
#import "CUOrder.h"
//typedef void(^CancelOrderBlock)(void);

@interface MyDiagnosisRecordsDetailViewController : CUViewController

@property (nonatomic, strong)  CUOrder *data;

//@property (nonatomic, copy) CancelOrderBlock cancelOrderBlock;

@end
