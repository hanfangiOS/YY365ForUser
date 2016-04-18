//
//  MyMemberCell.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUUser.h"

@interface MyMemberCell : UITableViewCell

@property (strong,nonatomic)CUUser * data;

+ (float)defaultCellHeight;

@end
