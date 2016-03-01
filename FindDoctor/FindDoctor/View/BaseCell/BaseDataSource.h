//
//  BaseDataSource.h
//  TableTest
//
//  Created by baidu on 14-6-4.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellDisplayInfo.h"
#import "BaseCell.h"

typedef void (^DataSourceCompletion)(void);

@interface BaseDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>
{
    dispatch_queue_t _dataSourceQueue;
}

@property (nonatomic, strong) NSMutableArray *infoArray;
@property (nonatomic, strong) NSMutableArray *dataArray;

- (void)updateDatas:(NSArray *)datas atPage:(NSUInteger)page completion:(DataSourceCompletion)completion;
//获取data array count
- (NSInteger)getDataArrayCount;
//获取第index的data
- (id)getDataFromArrayAt:(NSInteger)index;
//清空data array数据
- (void)clearDatas;

// for subclass
- (CellDisplayInfo *)displayInfoForData:(id)data;
- (NSString *)cellIndentifierForData:(id)data;

@end
