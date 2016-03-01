//
//  BaseCell.h
//  TableTest
//
//  Created by baidu on 14-6-4.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellContentView.h"

@interface BaseCell : UITableViewCell

@property (nonatomic, strong) CellContentView *cellContentView;

- (void)updateWithData:(id)data displayInfo:(id)info;
- (void)initContentView;

// for subclass
+ (Class)contentViewClass;
+ (CellDisplayInfo *)displayInfoForData:(id)data;

@end
