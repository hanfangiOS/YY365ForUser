//
//  GoodClinicCell.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/7.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clinic.h"

@interface GoodClinicCell : UICollectionViewCell

@property (strong,nonatomic) Clinic * data;

+ (float)defaultHeight;

+ (float)defaultWidth;

@end
