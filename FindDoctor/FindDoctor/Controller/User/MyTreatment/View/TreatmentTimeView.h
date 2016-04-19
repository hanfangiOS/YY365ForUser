//
//  TreatmentTimeView.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/19.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUOrder.h"

@interface TreatmentTimeView : UIView

@property (strong,nonatomic)CUOrder * data;

+ (float)defaultHeight;

@end
