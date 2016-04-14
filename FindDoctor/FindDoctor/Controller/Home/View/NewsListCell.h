//
//  NewsListCell.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/13.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipMessageData.h"

@interface NewsListCell : UITableViewCell

@property (strong,nonatomic) TipMessageData * data;

- (NSInteger)CellHeight;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
