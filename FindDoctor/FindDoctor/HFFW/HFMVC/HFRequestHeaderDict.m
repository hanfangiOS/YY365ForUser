//
//  HFRequestHeaderDict.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/19.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "HFRequestHeaderDict.h"
#import "CUUserManager.h"

@implementation HFRequestHeaderDict

+ (NSMutableDictionary *)initWithInterfaceID:(NSInteger)interfaceID require:(NSString *)require{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatForm forKey:@"from"];
    [param setObjectSafely:( [[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" ) forKey:@"token"];
    [param setObjectSafely:require forKey:@"require"];
    [param setObjectSafely:@(interfaceID) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    return param;
}

@end
