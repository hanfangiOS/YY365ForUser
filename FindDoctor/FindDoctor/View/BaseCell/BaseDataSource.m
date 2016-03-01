//
//  BaseDataSource.m
//  TableTest
//
//  Created by baidu on 14-6-4.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaseDataSource.h"

@interface BaseDataSource ()

@end

@implementation BaseDataSource

- (id)init
{
    self = [super init];
    if (self) {
        _dataSourceQueue = dispatch_queue_create("com.base.baseDataSource", 0);
    }
    
    return self;
}

- (void)updateDatas:(NSArray *)datas atPage:(NSUInteger)page completion:(DataSourceCompletion)completion
{
    if (![datas isKindOfClass:[NSArray class]] || completion == nil) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(_dataSourceQueue, ^{
        NSMutableArray *dataArray = [NSMutableArray array];
        NSMutableArray *infoArray = [NSMutableArray array];
        
        for (id data in datas) {
            id info = [weakSelf displayInfoForData:data];
            if (info) {
                [dataArray addObject:data];
                [infoArray addObject:info];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // page从0开始
            if (page == 0) {
                [self clearDatas];
            }
            
            [self.dataArray addObjectsFromArray:dataArray];
            [self.infoArray addObjectsFromArray:infoArray];
            
            completion();
        });
    });
}

- (void)clearDatas
{
    self.dataArray = [NSMutableArray array];
    self.infoArray = [NSMutableArray array];
}

- (NSInteger)getDataArrayCount
{
    return self.dataArray.count;
}

- (id)getDataFromArrayAt:(NSInteger)index
{
    id data = [self.dataArray objectAtIndex:index];
    return data;
}

- (CellDisplayInfo *)displayInfoForData:(id)data
{
    return [BaseCell displayInfoForData:data];
}

- (NSString *)cellIndentifierForData:(id)data
{
    static NSString *cellIndentifier = @"BaseCell";
    return cellIndentifier;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = [self.dataArray objectAtIndex:indexPath.row];
    CellDisplayInfo *info = [self.infoArray objectAtIndex:indexPath.row];
    
    NSString *cellIndentifier = [self cellIndentifierForData:data];
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (cell == nil) {
        cell = [[info.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    [cell updateWithData:data displayInfo:info];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellDisplayInfo *info = [self.infoArray objectAtIndex:indexPath.row];
    return info.cellHeight;
}

@end
