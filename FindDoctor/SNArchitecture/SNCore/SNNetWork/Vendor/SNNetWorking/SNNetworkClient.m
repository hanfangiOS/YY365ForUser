//
//  SNNetworkClient.m
//  AFNetworkingDemo
//
//  Created by Wade Cheng on 2/23/12.
//  Copyright (c) 2012 SINA. All rights reserved.
//

#import "SNNetworkClient.h"
#import "SNHTTPRequestOperationWrapper.h"
#import "SNImageRequestOperation.h"

typedef void (^AFHTTPRequestOperationSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^AFHTTPRequestOperationFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

static dispatch_queue_t networkclient_operation_wrappers_queue;

static void sync_access_operation_wrappers(void (^block)(void)) {
    dispatch_sync(networkclient_operation_wrappers_queue, block);
}

void SNNetworkAddRequestParameter(NSMutableDictionary *parameters, NSString *name, NSString *value)
{
    if (name && value && parameters)
    {
        [parameters setObject:value forKey:name];
    }
}

@interface AFHTTPClient (SNNetworking)
@property (readwrite, nonatomic, retain) NSURL *baseURL;
@property (readwrite, nonatomic, retain) NSMutableArray *registeredHTTPOperationClassNames;
@end

@interface SNHTTPRequestOperationWrapper ()
@property (nonatomic, retain) AFHTTPRequestOperation *operation;
@end

@interface SNNetworkBaseClient ()
- (void)wrapOperation:(AFHTTPRequestOperation *)operation withWrapper:(SNHTTPRequestOperationWrapper *)wrapper;
- (void)unwrapOperation:(AFHTTPRequestOperation *)operation;
@end

@implementation SNNetworkBaseClient

- (NSURL *)baseURL
{
    return [super baseURL];
}

- (void)resetBaseURL:(NSURL *)URL
{
    self.baseURL = URL;
}

#pragma mark - Cancel Request

- (void)cancelAllRequests
{
    [[self operationQueue] cancelAllOperations];
    
    __block NSArray *wrappers = nil;
    sync_access_operation_wrappers(^(void) {
        wrappers = [operationWrappers allValues];
    });
    
    for (SNHTTPRequestOperationWrapper *wrapper in wrappers)
    {
        if (![wrapper isKindOfClass:NSSet.class])
        {
            [self cancelWrapper:wrapper];
        }
    }
    
    sync_access_operation_wrappers(^(void) {
        [operationWrappers removeAllObjects];
    });
}

- (void)cancelWrapper:(SNHTTPRequestOperationWrapper *)wrapper
{
    [wrapper retain];
    [wrapper.operation clearBlocksAfterComplete];
    
    [wrapper.operation cancel];
    [self unwrapOperation:wrapper.operation];
    wrapper.operation = nil;
    [wrapper release];
}

#pragma mark - Memory management

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkclient_operation_wrappers_queue = dispatch_queue_create("com.sina.networkclient.operationwrappers_serial_queue", 0);
    });
}

- (id)initWithBaseURL:(NSURL *)URL requestConfigBlock:(void (^)(NSMutableURLRequest *request))_requestConfigBlock
{
    requestConfigBlock = [_requestConfigBlock copy];
    return [self initWithBaseURL:URL];
}

- (id)initWithBaseURL:(NSURL *)URL
{
    self = [super initWithBaseURL:URL];
    if (self) {
        operationWrappers = [[NSMutableDictionary alloc] init];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    }
    return self;
}

- (void)dealloc
{
    [self cancelAllRequests];

    [requestConfigBlock release], requestConfigBlock = nil;
    [errorHandlerClass release], errorHandlerClass = nil;
    [operationWrappers release], operationWrappers = nil;
    [defaultParameters release], defaultParameters = nil;
    [defaultQueryParameters release], defaultQueryParameters = nil;
    
    [super dealloc];
}

#pragma mark - Error handler

- (BOOL)registerErrorHandlerClass:(Class)_errorHandlerClass
{
    if (![_errorHandlerClass instancesRespondToSelector:@selector(handleError:forWrapper:)])
    {
        [errorHandlerClass release];
        errorHandlerClass = [_errorHandlerClass retain];
        return YES;
    }
    
    return NO;
}

- (void)clearErrorHandlerClass
{
    [errorHandlerClass release], errorHandlerClass = nil;
}

#pragma mark - Create / Get operation wrapper

- (SNHTTPRequestOperationWrapper *)wrapperWithRequest:(NSMutableURLRequest *)request
                                         successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                                         failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
{
    SNHTTPRequestOperationWrapper *wrapper = [[SNHTTPRequestOperationWrapper alloc] initWithRequest:request successBlock:successBlock failureBlock:failureBlock];
    return [wrapper autorelease];
}

- (SNHTTPRequestOperationWrapper *)wrapperOfOperation:(AFHTTPRequestOperation *)operation
{
    if (operation)
    {
        NSString *key = [NSString stringWithFormat:@"%p", operation];
        
        __block SNHTTPRequestOperationWrapper *wrapper = nil;
        sync_access_operation_wrappers(^{
            wrapper = [operationWrappers objectForKey:key];
            [wrapper retain];
        });
        return [wrapper autorelease];
    }
    return nil;
}

#pragma mark - Wrap / Unwrap operation

- (void)wrapOperation:(AFHTTPRequestOperation *)operation withWrapper:(SNHTTPRequestOperationWrapper *)wrapper
{
    wrapper.client = self;
    
    if (wrapper.operation != operation)
    {
        [wrapper retain];
        [self unwrapOperation:wrapper.operation];
        wrapper.operation = operation;
        NSString *key = [NSString stringWithFormat:@"%p", operation];
        

        if (operationWrappers == nil) {
            operationWrappers = [NSMutableDictionary new];
        }
        sync_access_operation_wrappers(^{
            [operationWrappers setObject:wrapper forKey:key];
        });

//        [operationWrappers setObject:wrapper forKey:key];
        
        [wrapper release];
    }
}

- (void)unwrapOperation:(AFHTTPRequestOperation *)operation
{
    if (!operation)
    {
        return;
    }
    
    NSString *key = [NSString stringWithFormat:@"%p", operation];
    __block SNHTTPRequestOperationWrapper *wrapper = nil;
    sync_access_operation_wrappers(^{
        wrapper = [operationWrappers objectForKey:key];
    });
    if (wrapper)
    {
        sync_access_operation_wrappers(^{
            [operationWrappers removeObjectForKey:key];
        });
    }
}

#pragma mark - Create operation with wrapper

- (SNHTTPRequestOperationWrapper *)enqueueOperationWithRequest:(NSMutableURLRequest *)request
                                                      settings:(NSDictionary *)settings
                                                  successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                                                  failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
{
    SNHTTPRequestOperationWrapper *wrapper = [self wrapperWithRequest:request
                                                         successBlock:successBlock
                                                         failureBlock:failureBlock];
    wrapper.settings = settings;
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request wrapper:wrapper];
    [self enqueueHTTPRequestOperation:operation];
    
    return wrapper;
}

- (SNHTTPRequestOperationWrapper *)enqueueOperationWithRequest:(NSMutableURLRequest *)request
                                                  successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                                                  failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
{
    return [self enqueueOperationWithRequest:request settings:nil successBlock:successBlock failureBlock:failureBlock];
}

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSMutableURLRequest *)request
                                                    wrapper:(SNHTTPRequestOperationWrapper *)wrapper
{
    __block SNNetworkBaseClient *blockSelf = self;

    AFHTTPRequestOperation *_operation = [self HTTPRequestOperationWithRequest:request
                                                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [operation retain], [responseObject retain];
        SNHTTPRequestOperationWrapper *relatedWrapper = [blockSelf wrapperOfOperation:operation];
        [relatedWrapper retain];
        
        [blockSelf unwrapOperation:operation];
        [operation clearBlocksAfterComplete];
        
        [relatedWrapper callbackSuccessBlockWithResponseObject:responseObject];
        
        if (relatedWrapper.operation == operation)
        {
            relatedWrapper.operation = nil;
        }

        [relatedWrapper release];
        [operation release], [responseObject release];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [operation retain], [error retain];
        SNHTTPRequestOperationWrapper *relatedWrapper = [blockSelf wrapperOfOperation:operation];
        [relatedWrapper retain];
        
        [blockSelf unwrapOperation:operation];
        [operation clearBlocksAfterComplete];
        
        if (blockSelf->errorHandlerClass)
        {
            error = [blockSelf->errorHandlerClass handleError:error forWrapper:relatedWrapper];
        }
        
        // 如果吃掉了error，则不回调
        if (error)
        {
            [relatedWrapper callbackFailureBlockWithError:error];
        }
        
        if (relatedWrapper.operation == operation)
        {
            relatedWrapper.operation = nil;
        }
        
        [relatedWrapper release];
        [operation release], [error release];
    }];
    [self wrapOperation:_operation withWrapper:wrapper];
    
    if (wrapper.settings && [_operation conformsToProtocol:@protocol(SNConfiguableRequestOperation)])
    {
        [(id<SNConfiguableRequestOperation>)_operation configWithSettings:wrapper.settings];
    }
    
    [_operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        __strong typeof(blockSelf) sself = blockSelf;
        SNHTTPRequestOperationWrapper *relatedWrapper = [self wrapperOfOperation:_operation];
        if (relatedWrapper.uploadProgressBlock)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                relatedWrapper.uploadProgressBlock((double)totalBytesWritten / totalBytesExpectedToWrite, totalBytesExpectedToWrite, totalBytesWritten);
            });
        }
    }];
    
    [_operation setDownloadProgressBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        SNHTTPRequestOperationWrapper *relatedWrapper = [blockSelf wrapperOfOperation:_operation];
        if (relatedWrapper.downloadProgressBlock)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                relatedWrapper.downloadProgressBlock((double)totalBytesRead / totalBytesExpectedToRead, totalBytesExpectedToRead, totalBytesRead);
            });
        }
    }];
    
    return _operation;
}

#pragma mark - Default parameters

- (NSString *)pathByAppendDefaultQueryParameters:(NSString *)path
{
    if (defaultQueryParameters)
    {
        path = [path stringByAppendingFormat:[path rangeOfString:@"?"].location == NSNotFound ? @"?%@" : @"&%@", AFQueryStringFromParametersWithEncoding(defaultQueryParameters, self.stringEncoding)];
    }
    
    return path;
}

- (NSDictionary *)parametersByAppendDefaultParameters:(NSDictionary *)parameters
{
    if (defaultParameters)
    {
        if(!parameters)
        {
            parameters = [[defaultParameters copy] autorelease];
        }
        else
        {
            // 使用外面的参数覆盖默认参数
            NSMutableDictionary *_parameters = [NSMutableDictionary dictionaryWithDictionary:defaultParameters];
            [_parameters addEntriesFromDictionary:parameters];
            parameters = _parameters;
        }
    }
    
    return parameters;
}

- (void)setDefaultParameter:(NSString *)parameter value:(NSString *)value
{
    if (!parameter)
    {
        return;
    }
    
    if (value)
    {
        if (!defaultParameters)
        {
            defaultParameters = [[NSMutableDictionary alloc] init];
        }
        [defaultParameters setObject:value forKey:parameter];
    }
    else
    {
        [defaultParameters removeObjectForKey:parameter];
    }
}

- (void)setDefaultQueryParameter:(NSString *)parameter value:(NSString *)value
{
    if (!parameter)
    {
        return;
    }
    
    if (value)
    {
        if (!defaultQueryParameters)
        {
            defaultQueryParameters = [[NSMutableDictionary alloc] init];
        }
        [defaultQueryParameters setObject:value forKey:parameter];
    }
    else
    {
        [defaultQueryParameters removeObjectForKey:parameter];
    }
}

#pragma mark - Create request

- (NSMutableURLRequest *)_requestWithMethod:(NSString *)method 
                                       path:(NSString *)path 
                                 parameters:(NSDictionary *)parameters
{
    return [self requestWithMethod:method path:path parameters:parameters];
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method 
                                      path:(NSString *)path 
                                parameters:(NSDictionary *)parameters
                                       tag:(NSString *)tag
                   appendDefaultParameters:(BOOL)appendDefaultParameters
{
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (appendDefaultParameters)
    {
        path = [self pathByAppendDefaultQueryParameters:path];
        parameters = [self parametersByAppendDefaultParameters:parameters];
    }
    
    NSMutableURLRequest *request = [self _requestWithMethod:method path:path parameters:parameters];
    if (requestConfigBlock)
    {
        requestConfigBlock(request);
    }
//    [request setValue:(tag ? tag : kSNNetworkRequestHeaderTagValueUnknown)
//        forHTTPHeaderField:kSNNetworkRequestHeaderTagName];
    
    return request;
}

- (NSMutableURLRequest *)normalRequestWithMethod:(NSString *)method 
                                            path:(NSString *)path 
                                      parameters:(NSDictionary *)parameters
{
    return [self requestWithMethod:method path:path
                        parameters:parameters
                               tag:kSNNetworkRequestHeaderTagValueNormal
           appendDefaultParameters:YES];
}

- (NSMutableURLRequest *)_multipartFormRequestWithMethod:(NSString *)method
                                                    path:(NSString *)path
                                              parameters:(NSDictionary *)parameters
                               constructingBodyWithBlock:(void (^)(id <AFMultipartFormData>formData))block
{
    return [super multipartFormRequestWithMethod:method path:path parameters:parameters constructingBodyWithBlock:block];
}

- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
                                                   path:(NSString *)path
                                             parameters:(NSDictionary *)parameters
                              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData>formData))block
{
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    path = [self pathByAppendDefaultQueryParameters:path];
    parameters = [self parametersByAppendDefaultParameters:parameters];
    NSMutableURLRequest *request = [self _multipartFormRequestWithMethod:method path:path parameters:parameters constructingBodyWithBlock:block];
//    [request setValue:kSNNetworkRequestHeaderTagValueUpload
//        forHTTPHeaderField:kSNNetworkRequestHeaderTagName];
    return request;
}

@end

@implementation SNNetworkClient

#pragma mark - Perform HTTP request operation

- (SNHTTPRequestOperationWrapper *)getPath:(NSString *)path 
                                parameters:(NSDictionary *)parameters
                              successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                              failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
{
	NSMutableURLRequest *request = [self normalRequestWithMethod:@"GET" path:path parameters:parameters];
    return [self enqueueOperationWithRequest:request successBlock:successBlock failureBlock:failureBlock];
}

- (SNHTTPRequestOperationWrapper *)postPath:(NSString *)path 
                                 parameters:(NSDictionary *)parameters
                               successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                               failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
{
	NSMutableURLRequest *request = [self normalRequestWithMethod:@"POST" path:path parameters:parameters];
	return [self enqueueOperationWithRequest:request successBlock:successBlock failureBlock:failureBlock];
}

- (SNHTTPRequestOperationWrapper *)putPath:(NSString *)path 
                                parameters:(NSDictionary *)parameters 
                              successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                              failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
{
	NSMutableURLRequest *request = [self normalRequestWithMethod:@"PUT" path:path parameters:parameters];
	return [self enqueueOperationWithRequest:request successBlock:successBlock failureBlock:failureBlock];
}

- (SNHTTPRequestOperationWrapper *)deletePath:(NSString *)path 
                                   parameters:(NSDictionary *)parameters
                                 successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                                 failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
{
	NSMutableURLRequest *request = [self normalRequestWithMethod:@"DELETE" path:path parameters:parameters];
	return [self enqueueOperationWithRequest:request successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark - Perform Upload request operation

- (SNHTTPRequestOperationWrapper *)uploadPath:(NSString *)path 
                                   parameters:(NSDictionary *)parameters
                    constructingBodyWithBlock:(SNHTTPMultipartFormConstructingBodyBlock)constructingBodyBlock
                                 successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                                 failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
{
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:path parameters:parameters constructingBodyWithBlock:constructingBodyBlock];
    return [self enqueueOperationWithRequest:request successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark - Use wrapper to resend an operation

- (void)resendOperationWithWrapper:(SNHTTPRequestOperationWrapper *)wrapper
                        properties:(NSDictionary *)properties;
{
    [[wrapper retain] autorelease];
    
    NSMutableURLRequest *request = [wrapper requestWithResendProperties:properties];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                      wrapper:wrapper];
    //注意，performSelector和GCD貌似会有冲突，下面语句不会执行,因此统一改用GCD的方法
    //[self performSelector:@selector(enqueueHTTPRequestOperation:) withObject:operation afterDelay:0.2];
    
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self enqueueHTTPRequestOperation:operation];
    });
     
}

@end


@implementation SNNetworkClient(Extension)

- (SNHTTPRequestOperationWrapper *)enqueueOperationWithRequest:(NSMutableURLRequest *)request
                                                      settings:(NSDictionary *)settings
                                                  successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                                                  failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
                                      callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
{
    SNHTTPRequestOperationWrapper *wrapper = [self wrapperWithRequest:request
                                                         successBlock:successBlock
                                                         failureBlock:failureBlock];
    wrapper.settings = settings;
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request wrapper:wrapper];
    if (runInGlobalQueue) {
        operation.successCallbackQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        operation.failureCallbackQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    
    [self enqueueHTTPRequestOperation:operation];
    
    return wrapper;
}

- (SNHTTPRequestOperationWrapper *)enqueueOperationWithRequest:(NSMutableURLRequest *)request
                                                  successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                                                  failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
                                      callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
{
    return [self enqueueOperationWithRequest:request settings:nil successBlock:successBlock failureBlock:failureBlock callbackRunInGlobalQueue:runInGlobalQueue];
}

- (SNHTTPRequestOperationWrapper *)getPath:(NSString *)path
                                parameters:(NSDictionary *)parameters
                              successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                              failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
                  callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
{
    NSMutableURLRequest *request = [self normalRequestWithMethod:@"GET" path:path parameters:parameters];
    return [self enqueueOperationWithRequest:request successBlock:successBlock failureBlock:failureBlock callbackRunInGlobalQueue:runInGlobalQueue];
}

- (SNHTTPRequestOperationWrapper *)postPath:(NSString *)path
                                 parameters:(NSDictionary *)parameters
                               successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                               failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
                   callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
{
    NSMutableURLRequest *request = [self normalRequestWithMethod:@"POST" path:path parameters:parameters];
    return [self enqueueOperationWithRequest:request successBlock:successBlock failureBlock:failureBlock callbackRunInGlobalQueue:runInGlobalQueue];
}

- (SNHTTPRequestOperationWrapper *)putPath:(NSString *)path
                                parameters:(NSDictionary *)parameters
                              successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                              failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
                  callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
{
    NSMutableURLRequest *request = [self normalRequestWithMethod:@"PUT" path:path parameters:parameters];
    return [self enqueueOperationWithRequest:request successBlock:successBlock failureBlock:failureBlock callbackRunInGlobalQueue:runInGlobalQueue];
}

- (SNHTTPRequestOperationWrapper *)deletePath:(NSString *)path
                                   parameters:(NSDictionary *)parameters
                                 successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                                 failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
                     callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
{
    NSMutableURLRequest *request = [self normalRequestWithMethod:@"DELETE" path:path parameters:parameters];
    return [self enqueueOperationWithRequest:request successBlock:successBlock failureBlock:failureBlock callbackRunInGlobalQueue:runInGlobalQueue];
}

- (SNHTTPRequestOperationWrapper *)getPath:(NSString *)path
                                parameters:(NSDictionary *)parameters
                                  priority:(NSOperationQueuePriority)priority
                              successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                              failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
                  callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
{
    SNHTTPRequestOperationWrapper *wrapper = [self getPath:path parameters:parameters successBlock:successBlock failureBlock:failureBlock callbackRunInGlobalQueue:runInGlobalQueue];
    
    [wrapper.operation setQueuePriority:priority];
    return wrapper;
}

- (SNHTTPRequestOperationWrapper *)postPath:(NSString *)path
                                 parameters:(NSDictionary *)parameters
                                   priority:(NSOperationQueuePriority)priority
                               successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                               failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
                   callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
{
    SNHTTPRequestOperationWrapper *wrapper = [self postPath:path parameters:parameters successBlock:successBlock failureBlock:failureBlock callbackRunInGlobalQueue:runInGlobalQueue];
    
    [wrapper.operation setQueuePriority:priority];
    
    return wrapper;
}

- (void)removeParameter:(NSString *)parameter
{
    if (!parameter)
    {
        return;
    }
    
    [defaultParameters removeObjectForKey:parameter];
}

@end
