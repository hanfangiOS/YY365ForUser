//
//  Comment.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/3/14.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "Comment.h"

//@implementation Comment

//- (instancetype)init{
//    self = [super init];
//    if (self) {
//        self.flagList = [[NSMutableArray alloc] init];
//        self.remarkList = [[NSMutableArray alloc] init];
//        return self;
//    }
//    return nil;
//}
//
//@end

@implementation FlagListInfo

@end

@implementation RemarkListInfo

@end

@implementation CommentFilter

- (instancetype)init{
    self = [super init];
    if (self) {
        self.order = [[CUOrder alloc] init];
        self.remarkListInfo = [[RemarkListInfo alloc] init];
        return self;
    }
    return nil;
}

@end

