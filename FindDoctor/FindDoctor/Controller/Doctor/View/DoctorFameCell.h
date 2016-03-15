//
//  DoctorFameCell.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/3/15.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface DoctorFameCell : UITableViewCell

@property (strong,nonatomic) RemarkListInfo * data;

- (NSInteger)CellHeight;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
