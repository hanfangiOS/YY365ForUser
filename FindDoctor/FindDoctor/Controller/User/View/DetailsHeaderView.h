//
//  DetailsHeaderView.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/18.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Doctor.h"

@interface DetailsHeaderView : UIView

@property (strong,nonatomic)Doctor * data;



+ (float)defaultHeight;

@end
