//
//  CellContentView.h
//  TableTest
//
//  Created by baidu on 14-6-4.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellDisplayInfo.h"

@interface CellContentView : UIView

@property (nonatomic, strong) id data;
@property (nonatomic, strong) id displayInfo;
@property BOOL hilighted;

- (void)initSubviews;
- (void)update;

@end
