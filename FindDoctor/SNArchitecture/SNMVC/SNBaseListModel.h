//
//  SNBaseListModel.h
//  CollegeUnion
//
//  Created by li na on 15/2/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNServerAPIManager.h"

extern int startPageNum;
extern int pageSize;

@interface SNPageInfo : NSObject

@property (nonatomic, assign) NSUInteger totalCount;        // 可返回的总结果数
@property (nonatomic, assign) NSUInteger pageSize;          // 每次请求的结果数
@property (nonatomic, assign) NSUInteger currentPage;       // 当前起始页，从1开始
@property (nonatomic, assign) NSUInteger totalPage;


@end

@interface SNBaseListModel : NSObject

@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) NSUInteger startIndex;            // 当前起始页，从1开始
@property (nonatomic,strong) SNPageInfo * pageInfo;

@property (nonatomic,assign) BOOL isHasNext;               // 上拉更多
@property (nonatomic,assign) BOOL isHasPrev;               // 下拉更多

@property (nonatomic,strong) NSMutableArray * items;

// 总页数，ceil(totalCount/pageSize)
- (NSUInteger)totalPageCount;

// 是否可加载更多或下一页
- (BOOL)hasNext;
- (BOOL)hasPrev;

// 定位，替换当前结果
- (void)gotoFirstPage;
- (void)gotoPage:(NSUInteger)pn;

// 增量，append或者prepend当前结果
- (void)mergeNextPage;
- (void)mergePrevPage;

// 翻页，替换当前结果
- (void)gotoNextPage;
- (void)gotoPrevPage;

// block
- (void)gotoFirstPage:(SNServerAPIResultBlock)resultBlock;
- (void)gotoNextPage:(SNServerAPIResultBlock)resultBlock;


@end
