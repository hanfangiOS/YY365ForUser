//
//  SNHTTPRequestOperationWrapper.h
//  Weibo
//
//  Created by Wade Cheng on 3/12/12.
//  Copyright (c) 2012 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNNetworkClient.h"

@interface SNHTTPRequestOperationWrapper : NSObject
{
    SNHTTPRequestOperationSuccessBlock successBlock;
    SNHTTPRequestOperationFailureBlock failureBlock;
    
    SNHTTPRequestOperationUploadProgressBlock uploadProgressBlock;
    SNHTTPRequestOperationDownloadProgressBlock downloadProgressBlock;
    
    SNNetworkClient *client;
    AFHTTPRequestOperation *operation;
    NSMutableURLRequest *request;
    
    NSDictionary *settings;
    __block id blockSelf;
    __block id blockResponseObject;
}

@property (nonatomic, readonly) NSMutableURLRequest *request;
@property (nonatomic, assign) SNNetworkBaseClient *client;
@property (nonatomic, retain) NSDictionary *settings;
@property (nonatomic, copy) SNHTTPRequestOperationUploadProgressBlock uploadProgressBlock;
@property (nonatomic, copy) SNHTTPRequestOperationDownloadProgressBlock downloadProgressBlock;

- (id)initWithRequest:(NSMutableURLRequest *)request
         successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
         failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock;

//- (SNHTTPRequestOperationSuccessBlock)successBlock;
//- (SNHTTPRequestOperationFailureBlock)failureBlock;

// 停止当前请求（但是会保留所有的block。后续可能还会重新使用这个wrapper。）
- (void)cancel;
// 清空wrapper（先停止请求，然后清除所有block。后续不会在继续使用这个wrapper了。）
- (void)drop;

- (void)resetRequest:(NSMutableURLRequest *)request;

// 重发请求
- (void)resendWithProperties:(NSDictionary *)properties;
- (NSMutableURLRequest *)requestWithResendProperties:(NSDictionary *)properties;

/*
 path 图片完整URL
 encodeAsImage 是否将响应的数据encode成UIImage。如果是YES，则返回UIImage，否则返回NSData（可用于解析GIF）
 */
- (void)loadImageWithPath:(NSString *)path encodeAsImage:(BOOL)encodeAsImage;
- (void)loadImageFileWithPath:(NSString *)path encodeAsImage:(BOOL)encodeAsImage;

// 获取请求响应数据
- (NSHTTPURLResponse *)response;
- (NSData *)responseData;
- (NSString *)responseString;

// 同步回调
- (void)callbackSuccessBlockWithResponseObject:(id)responseObject;
- (void)callbackFailureBlockWithError:(NSError *)error;

// 异步回调
- (void)callbackSuccessBlockInSuccessQueueWithResponseObject:(id)responseObject;
- (void)callbackFailureBlockInFailureQueueWithError:(NSError *)error;

@end
