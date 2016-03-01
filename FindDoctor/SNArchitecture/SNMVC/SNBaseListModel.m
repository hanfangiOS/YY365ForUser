//
//  SNBaseListModel.m
//  CollegeUnion
//
//  Created by li na on 15/2/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "SNBaseListModel.h"

@implementation SNPageInfo

//- (NSString *)description
//{
//    return [NSString stringWithFormat:@"totalCount=%d,pageSize=%d,currentPage=%d",self.totalCount,self.pageSize,self.currentPage];
//}

- (instancetype)init
{
    if (self = [super init])
    {
        self.totalCount = 0;
        self.pageSize = pageSize;
        self.currentPage = startPageNum;
    }
    return self;
}


@end

@implementation SNBaseListModel

- (instancetype)init
{
    if (self = [super init])
    {
        self.items = [NSMutableArray array];
        self.pageInfo = [[SNPageInfo alloc] init];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"pageInfo=%@,list=%@",self.pageInfo,self.items];
}

// 总页数，ceil(totalCount/pageSize)
- (NSUInteger)totalPageCount
{
    return self.pageInfo.totalCount;
}

// 是否可加载更多或下一页
- (BOOL)hasNext
{
    BOOL next = NO;
    if ( self.pageInfo.currentPage == startPageNum )
    {
        if ([self.items count] < pageSize/*self.pageInfo.pageSize*/)
        {
            next = NO;
        }
        else
        {
            next = YES;
        }
    }
    else if ( self.pageInfo.currentPage > startPageNum )
    {
        if ([self.items count] < self.pageInfo.totalPage * pageSize)
        {
            next = YES;
        }
        else
        {
            next = NO;
        }

    }
    return next;
}
- (BOOL)hasPrev
{
    return NO;
}

// 定位，替换当前结果
- (void)gotoFirstPage
{
    
}

- (void)gotoPage:(NSUInteger)pn
{
    
}

// 增量，append或者prepend当前结果
- (void)mergeNextPage
{
    
}
- (void)mergePrevPage
{
    
}

// 翻页，替换当前结果
- (void)gotoNextPage
{
    
}
- (void)gotoPrevPage
{
    
}

- (void)gotoFirstPage:(SNServerAPIResultBlock)resultBlock
{
    SNServerAPIResultData * result = [[SNServerAPIResultData alloc] init];
    result.parsedModelObject = self;
    resultBlock(nil,result);
}
- (void)gotoNextPage:(SNServerAPIResultBlock)resultBlock
{
    SNServerAPIResultData * result = [[SNServerAPIResultData alloc] init];
    result.parsedModelObject = self;
    resultBlock(nil,result);
}

@end
