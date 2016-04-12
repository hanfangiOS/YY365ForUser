//
//  GoodDoctorCell.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/7.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Doctor.h"

@interface GoodDoctorCell : UICollectionViewCell

@property (strong,nonatomic) Doctor * data;

+ (float)defaultHeight;

+ (float)defaultWidth;

+ (NSInteger)bottomLineTag;

@end