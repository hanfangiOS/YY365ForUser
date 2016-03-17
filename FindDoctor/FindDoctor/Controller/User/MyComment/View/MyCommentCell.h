//
//  MyCommentCell.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/3/14.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface MyCommentCell : UITableViewCell

@property (strong,nonatomic) Comment * data;

- (NSInteger)CellHeight;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


@end