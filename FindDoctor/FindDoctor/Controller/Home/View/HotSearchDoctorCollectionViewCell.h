//
//  HotSearchDoctorCollectionViewCell.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/14.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Doctor.h"

@interface HotSearchDoctorCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) Doctor *data;
@property (nonatomic) BOOL hasLine;

+ (CGFloat)defaultHeight;

@end
