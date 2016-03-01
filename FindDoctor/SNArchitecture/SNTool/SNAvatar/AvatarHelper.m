//
//  AvatarHelper.m
//
//
//  Created by zhouzhenhua on 15-4-5.
//  Copyright (c) 2015年 na li. All rights reserved.
//

#import "AvatarHelper.h"
#import "UIImage+Color.h"

#define kHeaderImageKey     @"header_image_key"

#define kHeaderBlurImageKey @"header_blur_image_key"

@implementation AvatarHelper

#pragma mark - Avatar

+ (UIImage *)defaultAvatar
{
    return [UIImage imageNamed:@"mine_avatar_placeholder"];
}

+ (UIImage *)cachedAvatar
{
    NSData *imageData = [[NSUserDefaults standardUserDefaults] valueForKey:kHeaderImageKey];
    UIImage *image = [UIImage imageWithData:imageData];
    return image ? image : [self defaultAvatar];
}

+ (void)saveAvatar:(NSData *)imageData
{
    [[NSUserDefaults standardUserDefaults] setValue:imageData forKey:kHeaderImageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearAvatar
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHeaderImageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (UIImage *)defaultAvatarBlur
{
    return [[UIImage createImageWithColor:[UIColor colorWithHex:0x83a2f8]] stretchableImageByCenter];
}

+ (UIImage *)cachedAvatarBlur
{
    NSData *imageData = [[NSUserDefaults standardUserDefaults] valueForKey:kHeaderBlurImageKey];
    UIImage *image = [UIImage imageWithData:imageData];
    return image ? image : [self defaultAvatarBlur];
}

+ (void)saveAvatarBlur:(NSData *)imageData
{
    [[NSUserDefaults standardUserDefaults] setValue:imageData forKey:kHeaderBlurImageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearAvatarBlur
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHeaderBlurImageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
