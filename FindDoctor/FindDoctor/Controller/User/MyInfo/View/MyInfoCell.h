//
//  MyInfoCell.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInfoCell : UITableViewCell

@property (strong ,nonatomic)UILabel        * label;
@property (strong ,nonatomic)UITextField    * textField;

+ (float)cellDefaultHeight;

@end
