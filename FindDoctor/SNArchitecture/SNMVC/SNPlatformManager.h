//
//  SNPlatformManager.h
//  CollegeUnion
//
//  Created by li na on 15/2/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNBusinessMananger.h"

@interface SNPlatformManager : SNBusinessMananger

+ (NSString *)deviceId;
+ (NSString*)deviceString;
+ (NSString *)deviceIdAddress;

@end
