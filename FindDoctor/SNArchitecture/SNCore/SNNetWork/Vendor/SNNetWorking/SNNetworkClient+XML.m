//
//  SNNetworkClient+XML.m
//  Weibo
//
//  Created by Wade Cheng on 3/23/12.
//  Copyright (c) 2012 Sina. All rights reserved.
//

#import "SNNetworkClient+XML.h"

@interface SNNetworkClient ()

- (SNHTTPRequestOperationWrapper *)enqueueOperationWithRequest:(NSMutableURLRequest *)request
                                                      settings:(NSDictionary *)settings
                                                  successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                                                  failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock;

- (NSMutableURLRequest *)normalRequestWithMethod:(NSString *)method 
                                            path:(NSString *)path 
                                      parameters:(NSDictionary *)parameters;

@end

@implementation SNNetworkClient (XML)

- (SNHTTPRequestOperationWrapper *)enqueueOperationWithRequest:(NSMutableURLRequest *)request
                                               arrayQueryPaths:(NSArray *)arrayQueryPaths
                                                  successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                                                  failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
{
    NSDictionary *settings = nil;
    if (arrayQueryPaths)
    {
        settings = [NSDictionary dictionaryWithObject:arrayQueryPaths forKey:kSNXMLResponseArrayQueryPathsKey];
    }
    return [self enqueueOperationWithRequest:request settings:settings successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark - Perform HTTP request operation

- (SNHTTPRequestOperationWrapper *)getPath:(NSString *)path 
                                parameters:(NSDictionary *)parameters
                           arrayQueryPaths:(NSArray *)arrayQueryPaths
                              successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                              failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
{
    NSMutableURLRequest *request = [self normalRequestWithMethod:@"GET" path:path parameters:parameters];
    return [self enqueueOperationWithRequest:request arrayQueryPaths:arrayQueryPaths successBlock:successBlock failureBlock:failureBlock];
}

- (SNHTTPRequestOperationWrapper *)postPath:(NSString *)path 
                                 parameters:(NSDictionary *)parameters
                            arrayQueryPaths:(NSArray *)arrayQueryPaths
                               successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                               failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
{
    NSMutableURLRequest *request = [self normalRequestWithMethod:@"POST" path:path parameters:parameters];
    return [self enqueueOperationWithRequest:request arrayQueryPaths:arrayQueryPaths successBlock:successBlock failureBlock:failureBlock];
}

- (SNHTTPRequestOperationWrapper *)putPath:(NSString *)path 
                                parameters:(NSDictionary *)parameters 
                           arrayQueryPaths:(NSArray *)arrayQueryPaths
                              successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                              failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
{
    NSMutableURLRequest *request = [self normalRequestWithMethod:@"PUT" path:path parameters:parameters];
    return [self enqueueOperationWithRequest:request arrayQueryPaths:arrayQueryPaths successBlock:successBlock failureBlock:failureBlock];
}

- (SNHTTPRequestOperationWrapper *)deletePath:(NSString *)path 
                                   parameters:(NSDictionary *)parameters
                              arrayQueryPaths:(NSArray *)arrayQueryPaths
                                 successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                                 failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
{
    NSMutableURLRequest *request = [self normalRequestWithMethod:@"DELETE" path:path parameters:parameters];
    return [self enqueueOperationWithRequest:request arrayQueryPaths:arrayQueryPaths successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark - Perform Upload request operation

- (SNHTTPRequestOperationWrapper *)uploadPath:(NSString *)path 
                                   parameters:(NSDictionary *)parameters
                              arrayQueryPaths:(NSArray *)arrayQueryPaths
                    constructingBodyWithBlock:(SNHTTPMultipartFormConstructingBodyBlock)constructingBodyBlock
                                 successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                                 failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
{
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:path parameters:parameters constructingBodyWithBlock:constructingBodyBlock];
    return [self enqueueOperationWithRequest:request arrayQueryPaths:arrayQueryPaths successBlock:successBlock failureBlock:failureBlock];
}

@end
