//
//  DetailsAppointInfoView.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/18.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUOrder.h"

@interface DetailsAppointInfoView : UIView

@property (strong,nonatomic)CUOrder * data;

+ (float)defaultHeight;

@end
