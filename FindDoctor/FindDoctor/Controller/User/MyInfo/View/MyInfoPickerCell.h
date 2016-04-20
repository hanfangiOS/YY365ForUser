//
//  MyInfoPickerCell.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/19.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInfoPickerCell : UITableViewCell

@property (strong ,nonatomic)UILabel        * label;
@property (strong ,nonatomic)UIButton       * btn;

+ (float)cellDefaultHeight;

@end
