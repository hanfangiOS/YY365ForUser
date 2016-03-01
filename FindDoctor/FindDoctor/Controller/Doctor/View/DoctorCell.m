//
//  DoctorCell.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "DoctorCell.h"

#define kDoctorCellHeight     120.0

@implementation DoctorCell

+ (CGFloat)defaultHeight
{
    return kDoctorCellHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews
{
    self.cellContentView = [[DoctorCellContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kDoctorCellHeight)];
    [self.contentView addSubview:self.cellContentView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
