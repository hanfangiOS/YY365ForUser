//
//  AVCaptureDevice+Permission.h
//
//
//  Created by zhouzhenhua on 15-4-25.
//  Copyright (c) 2015年 na li. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface AVCaptureDevice (Permission)

// YES表示用户明确允许或者拒绝，NO表示未弹框确认过
+ (BOOL)isCameraAuthorizationDetermined;

// 相机是否允许访问
+ (BOOL)isCameraAuthorized;

// 弹框申请相机权限
+ (void)requestCameraAuthorization:(void (^)(BOOL isAuthorized))handler;

// YES表示用户明确允许或者拒绝，NO表示未弹框确认过
+ (BOOL)isAlbumAuthorizationDetermined;

// 相册是否允许访问
+ (BOOL)isAlbumAuthorized;

// 弹框申请相册权限
+ (void)requestAlbumAuthorization:(void (^)(BOOL isAuthorized))handler;

@end
