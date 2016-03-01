//
//  CUUserManager+Address.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/16.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUUserManager.h"
#import "Address.h"

@interface CUUserManager (Address)

- (void)addAddress:(Address *)address resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

- (void)deleteAddress:(Address *)address resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

- (void)editAddress:(Address *)address resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

@end
