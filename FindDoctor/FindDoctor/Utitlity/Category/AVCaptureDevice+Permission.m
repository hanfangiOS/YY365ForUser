//
//  AVCaptureDevice+Permission.m
//
//
//  Created by zhouzhenhua on 15-4-25.
//  Copyright (c) 2015年 na li. All rights reserved.
//

#import "AVCaptureDevice+Permission.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation AVCaptureDevice (Permission)

+ (BOOL)isCameraAuthorizationDetermined
{
    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        return YES;
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)isCameraAuthorized
{
    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        return YES;
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusAuthorized) {
        return YES;
    }
    
    return NO;
}

+ (void)requestCameraAuthorization:(void (^)(BOOL isAuthorized))handler
{
    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        return;
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:handler];
    }
}

+ (BOOL)isAlbumAuthorizationDetermined
{
    // 6.0sdk已支持
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    
    if (authStatus == ALAuthorizationStatusNotDetermined) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)isAlbumAuthorized
{
    // 6.0sdk已支持
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    
    if (authStatus == ALAuthorizationStatusAuthorized) {
        return YES;
    }
    
    return NO;
}

+ (void)requestAlbumAuthorization:(void (^)(BOOL isAuthorized))handler
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (*stop) {
            // 点击“允许”
            if (handler) {
                handler(YES);
            }
            return;
        }
        *stop = TRUE;
    } failureBlock:^(NSError *error) {
        // 点击“拒绝”
        if (handler) {
            handler(NO);
        }
    }];
}

@end
