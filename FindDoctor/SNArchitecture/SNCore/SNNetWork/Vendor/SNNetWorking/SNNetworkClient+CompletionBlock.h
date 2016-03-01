//
//  SNNetworkClient+CompletionBlock.h
//  Weibo
//
//  Created by Wade Cheng on 4/11/12.
//  Copyright (c) 2012 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNNetworkClient.h"
#import "SNHTTPRequestOperationWrapper.h"

typedef void (^SNHTTPRequestOperationCompletionBlock)(SNHTTPRequestOperationWrapper *operationWrapper, id responseObject, NSError *error);


@interface SNNetworkClient (CompletionBlock)

#pragma mark - Normal request

/*
 path 请求的路径
 parameters 请求参数
 completionBlock 完成之后的回调
 */
- (SNHTTPRequestOperationWrapper *)getPath:(NSString *)path
                                parameters:(NSDictionary *)parameters
                           completionBlock:(SNHTTPRequestOperationCompletionBlock)completionBlock;

- (SNHTTPRequestOperationWrapper *)postPath:(NSString *)path 
                                 parameters:(NSDictionary *)parameters
                            completionBlock:(SNHTTPRequestOperationCompletionBlock)completionBlock;

- (SNHTTPRequestOperationWrapper *)putPath:(NSString *)path 
                                parameters:(NSDictionary *)parameters
                           completionBlock:(SNHTTPRequestOperationCompletionBlock)completionBlock;

- (SNHTTPRequestOperationWrapper *)deletePath:(NSString *)path 
                                   parameters:(NSDictionary *)parameters
                              completionBlock:(SNHTTPRequestOperationCompletionBlock)completionBlock;

/*
 path 请求的路径
 parameters 请求参数
 constructingBodyWithBlock 添加文件内容数据的block
 completionBlock 完成之后的回调
 */
- (SNHTTPRequestOperationWrapper *)uploadPath:(NSString *)path 
                                   parameters:(NSDictionary *)parameters
                    constructingBodyWithBlock:(SNHTTPMultipartFormConstructingBodyBlock)constructingBodyBlock
                              completionBlock:(SNHTTPRequestOperationCompletionBlock)completionBlock;

#pragma mark - Image request

/*
 path 图片完整URL
 encodeAsImage 是否将响应的数据encode成UIImage。如果是YES，则返回UIImage，否则返回NSData（可用于解析GIF）
 completionBlock 完成之后的回调
 */

- (SNHTTPRequestOperationWrapper *)loadImageWithPath:(NSString *)path
                                       encodeAsImage:(BOOL)encodeAsImage
                                     completionBlock:(SNHTTPRequestOperationCompletionBlock)completionBlock;

#pragma mark - XML request

/*
 path 请求的路径
 parameters 请求参数
 arrayQueryPaths 在解析XML数据时哪些节点需要处理为array
 completionBlock 完成之后的回调
 */
- (SNHTTPRequestOperationWrapper *)getPath:(NSString *)path
                                parameters:(NSDictionary *)parameters
                           arrayQueryPaths:(NSArray *)arrayQueryPaths
                           completionBlock:(SNHTTPRequestOperationCompletionBlock)completionBlock;

- (SNHTTPRequestOperationWrapper *)postPath:(NSString *)path 
                                 parameters:(NSDictionary *)parameters
                            arrayQueryPaths:(NSArray *)arrayQueryPaths
                            completionBlock:(SNHTTPRequestOperationCompletionBlock)completionBlock;

- (SNHTTPRequestOperationWrapper *)putPath:(NSString *)path 
                                parameters:(NSDictionary *)parameters 
                           arrayQueryPaths:(NSArray *)arrayQueryPaths
                           completionBlock:(SNHTTPRequestOperationCompletionBlock)completionBlock;

- (SNHTTPRequestOperationWrapper *)deletePath:(NSString *)path 
                                   parameters:(NSDictionary *)parameters 
                              arrayQueryPaths:(NSArray *)arrayQueryPaths
                              completionBlock:(SNHTTPRequestOperationCompletionBlock)completionBlock;

- (SNHTTPRequestOperationWrapper *)uploadPath:(NSString *)path 
                                   parameters:(NSDictionary *)parameters
                              arrayQueryPaths:(NSArray *)arrayQueryPaths
                    constructingBodyWithBlock:(SNHTTPMultipartFormConstructingBodyBlock)constructingBodyBlock
                              completionBlock:(SNHTTPRequestOperationCompletionBlock)completionBlock;


@end
