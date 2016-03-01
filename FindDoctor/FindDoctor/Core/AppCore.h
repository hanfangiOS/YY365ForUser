//
//  AppCore.h
//  CollegeUnion
//
//  Created by li na on 15/2/17.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNServerAPIManager.h"
#import "SNBusinessMananger.h"
#import "SNFileAccessManager.h"

@interface AppCore : NSObject

SINGLETON_DECLARE(AppCore);

@property (nonatomic,strong) SNServerAPIManager * apiManager;
@property (nonatomic,strong) SNFileAccessManager * fileAccessManager;

- (void)registerBusinessManager:(SNBusinessMananger *)manager;
- (void)removeBusinessManager:(SNBusinessMananger *)manager;

- (void)load;
- (void)save;
- (void)clear;

- (void) updateBeforeLoad;
- (void) updateAfterLoad;

@end
