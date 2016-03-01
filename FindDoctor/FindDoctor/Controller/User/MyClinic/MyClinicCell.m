//
//  MyClinicCell.m
//  FindMyClinic
//
//  Created by zhouzhenhua on 15/8/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "MyClinicCell.h"

#define kMyClinicCellHeight     120.0

@implementation MyClinicCell

+ (CGFloat)defaultHeight
{
    return kMyClinicCellHeight;
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
    self.cellContentView = [[MyClinicCellContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kMyClinicCellHeight)];
    [self.contentView addSubview:self.cellContentView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
