//
//  SNNetworkClient+XML.h
//  Weibo
//
//  Created by Wade Cheng on 3/23/12.
//  Copyright (c) 2012 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNNetworkClient.h"

#define kSNXMLResponseArrayQueryPathsKey              @"SNXMLResponseArrayQueryPathsKey"

@interface SNNetworkClient (XML)

#pragma mark - Normal request

/*
 path 请求的路径
 parameters 请求参数
 arrayQueryPaths 在解析XML数据时哪些节点需要处理为array
 successBlock 成功之后的回调
 failureBlock 失败之后的回调
 */
- (SNHTTPRequestOperationWrapper *)getPath:(NSString *)path
                                parameters:(NSDictionary *)parameters
                           arrayQueryPaths:(NSArray *)arrayQueryPaths
                              successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                              failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock;

- (SNHTTPRequestOperationWrapper *)postPath:(NSString *)path 
                                 parameters:(NSDictionary *)parameters
                            arrayQueryPaths:(NSArray *)arrayQueryPaths
                               successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                               failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock;

- (SNHTTPRequestOperationWrapper *)putPath:(NSString *)path 
                                parameters:(NSDictionary *)parameters 
                           arrayQueryPaths:(NSArray *)arrayQueryPaths
                              successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                              failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock;

- (SNHTTPRequestOperationWrapper *)deletePath:(NSString *)path 
                                   parameters:(NSDictionary *)parameters 
                              arrayQueryPaths:(NSArray *)arrayQueryPaths
                                 successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                                 failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock;

- (SNHTTPRequestOperationWrapper *)uploadPath:(NSString *)path 
                                   parameters:(NSDictionary *)parameters
                              arrayQueryPaths:(NSArray *)arrayQueryPaths
                    constructingBodyWithBlock:(SNHTTPMultipartFormConstructingBodyBlock)constructingBodyBlock
                                 successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                                 failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock;

@end
