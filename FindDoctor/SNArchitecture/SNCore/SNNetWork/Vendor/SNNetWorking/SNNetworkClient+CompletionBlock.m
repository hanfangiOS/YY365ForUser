//
//  SNNetworkClient+CompletionBlock.m
//  Weibo
//
//  Created by Wade Cheng on 4/11/12.
//  Copyright (c) 2012 Sina. All rights reserved.
//

#import "SNNetworkClient+CompletionBlock.h"
#import "SNNetworkClient+Image.h"
#import "SNNetworkClient+XML.h"

@implementation SNNetworkClient (CompletionBlock)

#pragma mark - Normal request

/*
 path 请求的路径
 parameters 请求参数
 completionBlock 完成之后的回调
 */
- (SNHTTPRequestOperationWrapper *)getPath:(NSString *)path
                                parameters:(NSDictionary *)parameters
                           completionBlock:(SNHTTPRequestOperationCompletionBlock)completionBlock
{
    return [self getPath:path parameters:parameters successBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, id responseObject) {
        if (completionBlock)
        {
            completionBlock(operationWrapper, responseObject, nil);
        }
    } failureBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, NSError *error) {
        if (completionBlock)
        {
            completionBlock(operationWrapper, nil, error);
        }
    }];
}

- (SNHTTPRequestOperationWrapper *)postPath:(NSString *)path 
                                 parameters:(NSDictionary *)parameters
                            completionBlock:(SNHTTPRequestOperationCompletionBlock)completionBlock
{
    return [self postPath:path parameters:parameters successBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, id responseObject) {
        if (completionBlock)
        {
            completionBlock(operationWrapper, responseObject, nil);
        }
    } failureBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, NSError *error) {
        if (completionBlock)
        {
            completionBlock(operationWrapper, nil, error);
        }
    }];
}

- (SNHTTPRequestOperationWrapper *)putPath:(NSString *)path 
                                parameters:(NSDictionary *)parameters
                           completionBlock:(SNHTTPRequestOperationCompletionBlock)completionBlock
{
    return [self putPath:path parameters:parameters successBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, id responseObject) {
        if (completionBlock)
        {
            completionBlock(operationWrapper, responseObject, nil);
        }
    } failureBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, NSError *error) {
        if (completionBlock)
        {
            completionBlock(operationWrapper, nil, error);
        }
    }];
}

- (SNHTTPRequestOperationWrapper *)deletePath:(NSString *)path 
                                   parameters:(NSDictionary *)parameters
                              completionBlock:(SNHTTPRequestOperationCompletionBlock)completionBlock
{
    return [self deletePath:path parameters:parameters successBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, id responseObject) {
        if (completionBlock)
        {
            completionBlock(operationWrapper, responseObject, nil);
        }
    } failureBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, NSError *error) {
        if (completionBlock)
        {
            completionBlock(operationWrapper, nil, error);
        }
    }];
}

/*
 path 请求的路径
 parameters 请求参数
 constructingBodyWithBlock 添加文件内容数据的block
 completionBlock 完成之后的回调
 */
- (SNHTTPRequestOperationWrapper *)uploadPath:(NSString *)path 
                                   parameters:(NSDictionary *)parameters
                    constructingBodyWithBlock:(SNHTTPMultipartFormConstructingBodyBlock)constructingBodyBlock
                              completionBlock:(SNHTTPRequestOperationCompletionBlock)completionBlock
{
    return [self uploadPath:path parameters:parameters constructingBodyWithBlock:constructingBodyBlock successBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, id responseObject) {
        if (completionBlock)
        {
            completionBlock(operationWrapper, responseObject, nil);
        }
    } failureBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, NSError *error) {
        if (completionBlock)
        {
            completionBlock(operationWrapper, nil, error);
        }
    }];
}

#pragma mark - Image request

/*
 path 图片完整URL
 encodeAsImage 是否将响应的数据encode成UIImage。如果是YES，则返回UIImage，否则返回NSData（可用于解析GIF）
 completionBlock 完成之后的回调
 */

- (SNHTTPRequestOperationWrapper *)loadImageWithPath:(NSString *)path
                                       encodeAsImage:(BOOL)encodeAsImage
                                     completionBlock:(SNHTTPRequestOperationCompletionBlock)completionBlock
{
    return [self loadImageWithPath:path encodeAsImage:encodeAsImage successBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, id responseObject) {
        if (completionBlock)
        {
            completionBlock(operationWrapper, responseObject, nil);
        }
    } failureBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, NSError *error) {
        if (completionBlock)
        {
            completionBlock(operationWrapper, nil, error);
        }
    }];
}

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
                           completionBlock:(SNHTTPRequestOperationCompletionBlock)completionBlock
{
    return [self getPath:path parameters:parameters arrayQueryPaths:arrayQueryPaths successBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, id responseObject) {
        if (completionBlock)
        {
            completionBlock(operationWrapper, responseObject, nil);
        }
    } failureBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, NSError *error) {
        if (completionBlock)
        {
            completionBlock(operationWrapper, nil, error);
        }
    }];
}

- (SNHTTPRequestOperationWrapper *)postPath:(NSString *)path 
                                 parameters:(NSDictionary *)parameters
                            arrayQueryPaths:(NSArray *)arrayQueryPaths
                            completionBlock:(SNHTTPRequestOperationCompletionBlock)completionBlock
{
    return [self postPath:path parameters:parameters arrayQueryPaths:arrayQueryPaths successBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, id responseObject) {
        if (completionBlock)
        {
            completionBlock(operationWrapper, responseObject, nil);
        }
    } failureBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, NSError *error) {
        if (completionBlock)
        {
            completionBlock(operationWrapper, nil, error);
        }
    }];
}

- (SNHTTPRequestOperationWrapper *)putPath:(NSString *)path 
                                parameters:(NSDictionary *)parameters 
                           arrayQueryPaths:(NSArray *)arrayQueryPaths
                           completionBlock:(SNHTTPRequestOperationCompletionBlock)completionBlock
{
    return [self putPath:path parameters:parameters arrayQueryPaths:arrayQueryPaths successBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, id responseObject) {
        if (completionBlock)
        {
            completionBlock(operationWrapper, responseObject, nil);
        }
    } failureBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, NSError *error) {
        if (completionBlock)
        {
            completionBlock(operationWrapper, nil, error);
        }
    }];
}

- (SNHTTPRequestOperationWrapper *)deletePath:(NSString *)path 
                                   parameters:(NSDictionary *)parameters 
                              arrayQueryPaths:(NSArray *)arrayQueryPaths
                              completionBlock:(SNHTTPRequestOperationCompletionBlock)completionBlock
{
    return [self deletePath:path parameters:parameters arrayQueryPaths:arrayQueryPaths successBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, id responseObject) {
        if (completionBlock)
        {
            completionBlock(operationWrapper, responseObject, nil);
        }
    } failureBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, NSError *error) {
        if (completionBlock)
        {
            completionBlock(operationWrapper, nil, error);
        }
    }];
}

- (SNHTTPRequestOperationWrapper *)uploadPath:(NSString *)path 
                                   parameters:(NSDictionary *)parameters
                              arrayQueryPaths:(NSArray *)arrayQueryPaths
                    constructingBodyWithBlock:(SNHTTPMultipartFormConstructingBodyBlock)constructingBodyBlock
                              completionBlock:(SNHTTPRequestOperationCompletionBlock)completionBlock
{
    return [self uploadPath:path parameters:parameters constructingBodyWithBlock:constructingBodyBlock successBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, id responseObject) {
        if (completionBlock)
        {
            completionBlock(operationWrapper, responseObject, nil);
        }
    } failureBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, NSError *error) {
        if (completionBlock)
        {
            completionBlock(operationWrapper, nil, error);
        }
    }];
}

@end
