//
//  AppCore.m
//  CollegeUnion
//
//  Created by li na on 15/2/17.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "AppCore.h"
#import "CUServerAPIConstant.h"
#import "CUUserManager.h"
#import "CUPlatFormManager.h"

@interface AppCore ()

@property (nonatomic,strong) NSMutableArray * managerArray;

@end

@implementation AppCore

SINGLETON_IMPLENTATION(AppCore);

- (instancetype)init
{
    if (self = [super init])
    {
        self.apiManager = [[SNServerAPIManager alloc] initWithServer:URL_Base];
        self.fileAccessManager = [[SNFileAccessManager alloc] initWithNameSpace:@"AppCore"];
        self.managerArray = [NSMutableArray array];
        
        [self.apiManager setDefaultParameter:@"from" value:@"ios_user"];
        [self.apiManager setDefaultParameter:@"version" value:[CUPlatFormManager currentAppVersion]];
        
        [self resgisterManager];
    }
    return self;
}

-(void)resgisterManager
{
    [self registerBusinessManager:[CUUserManager sharedInstance]];
    [self registerBusinessManager:[CUPlatFormManager sharedInstance]];
}

- (void)registerBusinessManager:(SNBusinessMananger *)manager
{
    if (self.managerArray == nil)
    {
        self.managerArray = [NSMutableArray array];
    }
    [self.managerArray addObjectSafely:manager];
    
}

- (void)removeBusinessManager:(SNBusinessMananger *)manager
{
//    [self.managerArray removeObjectAtIndexSafely:<#(NSUInteger)#>]
}


- (void)load
{
    [self.managerArray enumerateObjectsUsingBlock:^(SNBusinessMananger * obj, NSUInteger idx, BOOL *stop) {
        [obj load];
    }];
}
- (void)save
{
    [self.managerArray enumerateObjectsUsingBlock:^(SNBusinessMananger * obj, NSUInteger idx, BOOL *stop) {
        [obj save];
    }];

}
- (void)clear
{
    [self.managerArray enumerateObjectsUsingBlock:^(SNBusinessMananger * obj, NSUInteger idx, BOOL *stop) {
        [obj clear];
    }];

}

- (void) updateBeforeLoad
{
    [self.managerArray enumerateObjectsUsingBlock:^(SNBusinessMananger * obj, NSUInteger idx, BOOL *stop) {
        [obj updateBeforeLoad];
    }];
}
- (void) updateAfterLoad
{
    [self.managerArray enumerateObjectsUsingBlock:^(SNBusinessMananger * obj, NSUInteger idx, BOOL *stop) {
        [obj updateAfterLoad];
    }];
}

@end
