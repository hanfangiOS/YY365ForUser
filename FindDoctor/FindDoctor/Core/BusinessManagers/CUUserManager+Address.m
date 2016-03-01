//
//  AddressManager+Address.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/16.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUUserManager+Address.h"

@implementation CUUserManager (Address)

- (void)addAddress:(Address *)address resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    if (resultBlock) {
        address.addressId = @"9898";
        
        SNServerAPIResultData *result = [[SNServerAPIResultData alloc] init];
        result.parsedModelObject = address;
        
        resultBlock(nil, result);
    }
}

- (void)deleteAddress:(Address *)address resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    if (resultBlock) {
        SNServerAPIResultData *result = [[SNServerAPIResultData alloc] init];
        result.parsedModelObject = address;
        
        resultBlock(nil, result);
    }
}

- (void)editAddress:(Address *)address resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    if (resultBlock) {
        SNServerAPIResultData *result = [[SNServerAPIResultData alloc] init];
        result.parsedModelObject = address;
        
        resultBlock(nil, result);
    }
}

@end
