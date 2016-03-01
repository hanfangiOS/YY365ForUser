//
//  OrderCell.m
//  EShiJia
//
//  Created by zhouzhenhua on 15-4-24.
//  Copyright (c) 2015年 zhouzhenhua. All rights reserved.
//

#import "OrderCell.h"
#import "UIConstants.h"

#define kOrderCellHeight     120.0

@implementation OrderCell

+ (CGFloat)defaultHeight
{
    return kOrderCellHeight;
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
    self.cellContentView = [[OrderCellContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kOrderCellHeight)];
    [self.contentView addSubview:self.cellContentView];
    
    __weak typeof(self) weakSelf = self;
    self.cellContentView.clickAction = ^{
        [weakSelf orderButtonPress];
    };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)orderButtonPress
{
    CUOrder *order = self.cellContentView.data;
    if (order.orderStatus == ORDERSTATUS_UNPAID) {
        if ([self.delegate respondsToSelector:@selector(didClickToPay:)]) {
            [self.delegate didClickToPay:order];
        }
    }
    else if (order.orderStatus == ORDERSTATUS_FINISHED && !order.isComment) {
        if ([self.delegate respondsToSelector:@selector(didClickToComment:)]) {
            [self.delegate didClickToComment:order];
        }
    }
}

@end
