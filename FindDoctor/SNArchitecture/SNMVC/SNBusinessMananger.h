//
//  SNBusinessMananger.h
//  SNArchitecture
//
//  Created by li na on 15/2/16.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNBusinessMananger : NSObject

// 子类可以选择性的实现以下方法
- (void)load;
- (void)save;
- (void)clear;

- (void) updateBeforeLoad;
- (void) updateAfterLoad;

@end
