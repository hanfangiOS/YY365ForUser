//
//  SNNetworkClient+Image.h
//  Weibo
//
//  Created by Wade Cheng on 3/23/12.
//  Copyright (c) 2012 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNNetworkClient.h"

#define kSNImageResponseOriginalPathKey              @"SNImageResponseOriginalPathKey"

@interface SNNetworkClient (Image)

#pragma mark - Image request

/*
 path 图片完整URL
 encodeAsImage 是否将响应的数据encode成UIImage。如果是YES，则返回UIImage，否则返回NSData（可用于解析GIF）
 successBlock 成功之后的回调
 failureBlock 失败之后的回调
 */
- (SNHTTPRequestOperationWrapper *)loadImageFileWithPath:(NSString *)path
                                           encodeAsImage:(BOOL)encodeAsImage
                                            successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                                            failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock;

- (void)loadImageFileWithWrapper:(SNHTTPRequestOperationWrapper *)wrapper
                            path:(NSString *)path
                   encodeAsImage:(BOOL)encodeAsImage;

- (SNHTTPRequestOperationWrapper *)loadImageWithPath:(NSString *)path
                                       encodeAsImage:(BOOL)encodeAsImage
                                        successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                                        failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock;

- (void)loadImageWithWrapper:(SNHTTPRequestOperationWrapper *)wrapper
                        path:(NSString *)path
               encodeAsImage:(BOOL)encodeAsImage;

@end
