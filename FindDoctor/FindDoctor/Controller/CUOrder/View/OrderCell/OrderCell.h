//
//  OrderCell.h
//  EShiJia
//
//  Created by zhouzhenhua on 15-4-24.
//  Copyright (c) 2015年 zhouzhenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"
#import "OrderCellContentView.h"

@protocol OrderCellDelegate;

@interface OrderCell : UITableViewCell

@property (nonatomic, weak) id<OrderCellDelegate> delegate;

+ (CGFloat)defaultHeight;

@property (nonatomic, strong) OrderCellContentView *cellContentView;

@end

@protocol OrderCellDelegate <NSObject>

@optional
- (void)didClickToPay:(id)order;
- (void)didClickToComment:(id)order;

@end
