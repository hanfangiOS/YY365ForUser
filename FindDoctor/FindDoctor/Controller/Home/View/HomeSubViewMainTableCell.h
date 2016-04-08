//
//  HomeSubViewMainTableCell.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/6.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Doctor.h"

@interface HomeSubViewMainTableCell : UITableViewCell

@property (nonatomic, strong) Doctor * data;

+ (CGFloat)defaultHeight;


@end
