//
//  AvatarHelper.h
//  
//
//  Created by zhouzhenhua on 15-4-5.
//  Copyright (c) 2015年 na li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AvatarHelper : NSObject

+ (UIImage *)defaultAvatar;
+ (UIImage *)cachedAvatar;
+ (void)saveAvatar:(NSData *)imageData;
+ (void)clearAvatar;

+ (UIImage *)defaultAvatarBlur;
+ (UIImage *)cachedAvatarBlur;
+ (void)saveAvatarBlur:(NSData *)imageData;
+ (void)clearAvatarBlur;

@end
