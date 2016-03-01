//
//  ListMoneyTableViewCell.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/23.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListMoneyTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic) NSTimeInterval timestamp;
@property (nonatomic, strong) NSString *massage;
@property (nonatomic, strong) NSString *mark;
@property (nonatomic) double fee;

- (NSInteger)CellHeight;

@end
