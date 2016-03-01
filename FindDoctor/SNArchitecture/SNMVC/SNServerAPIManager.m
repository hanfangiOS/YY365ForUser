//
//  SNServerAPIManager.m
//  SNArchitecture
//
//  Created by li na on 15/2/16.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "SNServerAPIManager.h"

@interface SNServerAPIManager ()

//@property (nonatomic,strong) SNHTTPRequestOperationManager * requestManager;
@property (nonatomic,strong,readwrite) NSString * server;
@property (nonatomic,strong,readwrite) NSString * lastRequestApi;
@property (nonatomic,strong,readwrite) NSDictionary * lastRequestParameters;

@property (nonatomic,strong) NSMutableDictionary * requestDict;
@property (nonatomic,strong) dispatch_queue_t requestQueue;

// last request uesed for require the second time
//@property (nonatomic,strong,readonly) NSString * lastRequestApi;
//@property (nonatomic,strong,readonly) NSDictionary * lastRequestParameters;

@end

@implementation SNServerAPIManager

- (instancetype)initWithServer:(NSString *)server
{
    if (self = [super init])
    {
        if (![server hasPrefix:@"http://"])
        {
            server = [@"http://" stringByAppendingString:server];
        }
        if ([server hasSuffix:@"/"])
        {
            server = [server substringToIndex:server.length - 1];
        }
        
        self.server = server;
        self.requestDict = [[NSMutableDictionary alloc] init];
        self.requestQueue = dispatch_queue_create("com.sn.architecure.snServerAPIRequestQueue",0);
    }

    return self;
}

- (void)setDefaultParameter:(NSString *)parameter value:(NSString *)value
{
    [[SNHTTPRequestOperationManager manager] setDefaultParameter:parameter value:value];
}

- (NSString *)fullURLWithAPIName:(NSString *)api
{
    NSString * fullPath = api;
    if (self.server != nil)
    {
        fullPath = [self.server stringByAppendingString:[self standardAPI:api]];
    }
    return fullPath;
}


- (NSString *)standardAPI:(NSString *)api
{
    NSString * apiReturn = [api hasPrefix:@"/"]?api:[@"/" stringByAppendingString:api];
    return apiReturn;
}

- (SNHTTPRequestOperation *)GET:(NSString *)api
                     parameters:(NSDictionary *)parameters
       callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
                         parser:(SNServerAPIDataParser *)parser
                    parseMethod:(SEL)parseMethod
                    resultBlock:(SNServerAPIResultBlock)resultBlock
                         forKey:(NSString *)key
               forPageNameGroup:(NSString *)pageName
{
    SNServerAPIResultData * result = [[SNServerAPIResultData alloc] init];
    
    SNHTTPRequestOperation * operation = [[SNHTTPRequestOperationManager manager] GET:[self fullURLWithAPIName:api] parameters:parameters successBlock:^(SNHTTPRequestOperation *request, id responseObject) {
        
        result.responseObject = responseObject;
        @try
        {
            if ([parser respondsToSelector:parseMethod])
            {
           
                result.parsedModelObject = [parser performSelector:parseMethod withObject:responseObject];
            }
        }
        @catch (NSException *exception)
        {
            parser.hasError = YES;
            NSLog(@"exception %@ in %s", exception, __FUNCTION__);
        }
            
        @finally
        {
            result.hasError = parser.hasError;
            if (parser.hasError)
            {
                result.error = parser.error;
                result.errorType = SNServerAPIErrorType_DataError;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if(resultBlock)
                {
                    resultBlock(request,result);
                }
            });
            
            [self removeRequestForKey:key];
            [self removeRequestForPageNameGroup:pageName];
        }
        
    } failureBlock:^(SNHTTPRequestOperation *request, NSError *error) {
        
        result.hasError = YES;
        result.error = error;
        result.errorType = SNServerAPIErrorType_NetWorkFailure;
        dispatch_async(dispatch_get_main_queue(), ^{
            if(resultBlock)
            {
                resultBlock(request,result);
            }
        });
        [self removeRequestForKey:key];
        [self removeRequestForPageNameGroup:pageName];
        
    } callbackRunInGlobalQueue:runInGlobalQueue];
    
    if (key != nil) {
        [self setRequest:operation forKey:key];
    }
    
    if (pageName != nil) {
        [self setRequest:operation forPageNameGroup:pageName];
    }
    
    return operation;
}

- (SNHTTPRequestOperation *)POST:(NSString *)api
                      parameters:(NSDictionary *)parameters
        callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
                          parser:(SNServerAPIDataParser *)parser
                     parseMethod:(SEL)parseMethod
                          object:(id)object
                     resultBlock:(SNServerAPIResultBlock)resultBlock
                          forKey:(NSString *)key
                forPageNameGroup:(NSString *)pageName;
{
    SNServerAPIResultData * result = [[SNServerAPIResultData alloc] init];
    
    SNHTTPRequestOperation * operation = [[SNHTTPRequestOperationManager manager] POST:[self fullURLWithAPIName:api] parameters:parameters successBlock:^(SNHTTPRequestOperation *request, id responseObject) {
        
        result.responseObject = responseObject;
        @try
        {
            if ([parser respondsToSelector:parseMethod])
            {
                result.parsedModelObject = [parser performSelector:parseMethod withObject:responseObject withObject:object];
            }
        }
        @catch (NSException *exception)
        {
            parser.hasError = YES;
            NSLog(@"exception %@ in %s", exception, __FUNCTION__);
        }
        
        @finally
        {
            result.hasError = parser.hasError;
            if (parser.hasError)
            {
                result.error = parser.error;
                result.errorType = SNServerAPIErrorType_DataError;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if(resultBlock)
                {
                    resultBlock(request,result);
                }
            });
            
            [self removeRequestForKey:key];
            [self removeRequestForPageNameGroup:pageName];
        }
        
    } failureBlock:^(SNHTTPRequestOperation *request, NSError *error) {
        
        result.hasError = YES;
        result.error = error;
        result.errorType = SNServerAPIErrorType_NetWorkFailure;
        dispatch_async(dispatch_get_main_queue(), ^{
            if(resultBlock)
            {
                resultBlock(request,result);
            }
        });
        [self removeRequestForKey:key];
        [self removeRequestForPageNameGroup:pageName];
        
    } callbackRunInGlobalQueue:runInGlobalQueue];
    
    if (key != nil) {
        [self setRequest:operation forKey:key];
    }
    
    if (pageName != nil) {
        [self setRequest:operation forPageNameGroup:pageName];
    }
    
    return operation;
}


- (SNHTTPRequestOperation *)POST:(NSString *)api
                     parameters:(NSDictionary *)parameters
       callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
                         parser:(SNServerAPIDataParser *)parser
                    parseMethod:(SEL)parseMethod
                    resultBlock:(SNServerAPIResultBlock)resultBlock
                         forKey:(NSString *)key
               forPageNameGroup:(NSString *)pageName;
{

    SNServerAPIResultData * result = [[SNServerAPIResultData alloc] init];
    
    SNHTTPRequestOperation * operation = [[SNHTTPRequestOperationManager manager] POST:[self fullURLWithAPIName:api] parameters:parameters successBlock:^(SNHTTPRequestOperation *request, id responseObject) {
        
        result.responseObject = responseObject;
        @try
        {
            if ([parser respondsToSelector:parseMethod])
            {
                result.parsedModelObject = [parser performSelector:parseMethod withObject:responseObject];
            }
        }
        @catch (NSException *exception)
        {
            parser.hasError = YES;
            NSLog(@"exception %@ in %s", exception, __FUNCTION__);
        }
        
        @finally
        {
            result.hasError = parser.hasError;
            if (parser.hasError)
            {
                result.error = parser.error;
                result.errorType = SNServerAPIErrorType_DataError;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if(resultBlock)
                {
                    resultBlock(request,result);
                }
            });
            
            [self removeRequestForKey:key];
            [self removeRequestForPageNameGroup:pageName];
        }
        
    } failureBlock:^(SNHTTPRequestOperation *request, NSError *error) {
        
        result.hasError = YES;
        result.error = error;
        result.errorType = SNServerAPIErrorType_NetWorkFailure;
        dispatch_async(dispatch_get_main_queue(), ^{
            if(resultBlock)
            {
                resultBlock(request,result);
            }
        });
        [self removeRequestForKey:key];
        [self removeRequestForPageNameGroup:pageName];
        
    } callbackRunInGlobalQueue:runInGlobalQueue];
    
    if (key != nil) {
        [self setRequest:operation forKey:key];
    }
    
    if (pageName != nil) {
        [self setRequest:operation forPageNameGroup:pageName];
    }
    
    return operation;
}

- (SNHTTPRequestOperation *)GET:(NSString *)api
                     parameters:(NSDictionary *)parameters
       callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
                         parser:(SNServerAPIDataParser *)parser
                    parseMethod:(SEL)parseMethod
                    resultBlock:(SNServerAPIResultBlock)resultBlock
{
    return [self GET:api parameters:parameters callbackRunInGlobalQueue:runInGlobalQueue parser:parser parseMethod:parseMethod resultBlock:resultBlock forKey:nil forPageNameGroup:nil];
}

- (SNHTTPRequestOperation *)GET:(NSString *)api
                     parameters:(NSDictionary *)parameters
       callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
                         parser:(SNServerAPIDataParser *)parser
                    parseMethod:(SEL)parseMethod
                    resultBlock:(SNServerAPIResultBlock)resultBlock
                         forKey:(NSString *)key
{
    return [self GET:api parameters:parameters callbackRunInGlobalQueue:runInGlobalQueue parser:parser parseMethod:parseMethod resultBlock:resultBlock forKey:key forPageNameGroup:nil];
}

- (SNHTTPRequestOperation *)GET:(NSString *)api
                     parameters:(NSDictionary *)parameters
       callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
                         parser:(SNServerAPIDataParser *)parser
                    parseMethod:(SEL)parseMethod
                    resultBlock:(SNServerAPIResultBlock)resultBlock                forPageNameGroup:(NSString *)pageName
{
    return [self GET:api parameters:parameters callbackRunInGlobalQueue:runInGlobalQueue parser:parser parseMethod:parseMethod resultBlock:resultBlock forKey:nil forPageNameGroup:pageName];
}


- (SNHTTPRequestOperation *)POST:(NSString *)api
                      parameters:(NSDictionary *)parameters
        callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
                          parser:(SNServerAPIDataParser *)parser
                     parseMethod:(SEL)parseMethod
                     resultBlock:(SNServerAPIResultBlock)resultBlock
{
    return [self POST:api parameters:parameters callbackRunInGlobalQueue:runInGlobalQueue parser:parser parseMethod:parseMethod resultBlock:resultBlock forKey:nil forPageNameGroup:nil];
}

- (SNHTTPRequestOperation *)POST:(NSString *)api
                      parameters:(NSDictionary *)parameters
        callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
                          parser:(SNServerAPIDataParser *)parser
                     parseMethod:(SEL)parseMethod
                     resultBlock:(SNServerAPIResultBlock)resultBlock
                          forKey:(NSString *)key
{
    return [self POST:api parameters:parameters callbackRunInGlobalQueue:runInGlobalQueue parser:parser parseMethod:parseMethod resultBlock:resultBlock forKey:key forPageNameGroup:nil];
}

- (SNHTTPRequestOperation *)POST:(NSString *)api
                      parameters:(NSDictionary *)parameters
        callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
                          parser:(SNServerAPIDataParser *)parser
                     parseMethod:(SEL)parseMethod
                     resultBlock:(SNServerAPIResultBlock)resultBlock                forPageNameGroup:(NSString *)pageName
{
    return [self POST:api parameters:parameters callbackRunInGlobalQueue:runInGlobalQueue parser:parser parseMethod:parseMethod resultBlock:resultBlock forKey:nil forPageNameGroup:pageName];
}

- (void)setRequest:(SNHTTPRequestOperation *)request forKey:(NSString *)key
{
    [self cancelRequestForKey:key];
    if ( nil != request && nil != key )
    {
        dispatch_async(self.requestQueue, ^{
            [self.requestDict setObject:request forKey:key];
        });
    }
}
- (void)cancelRequestForKey:(NSString *)key
{
    if ( nil != key )
    {
        dispatch_async(self.requestQueue, ^{
            SNHTTPRequestOperation * request = [self.requestDict objectForKey:key];
            [request cancel];
            [self.requestDict removeObjectForKey:key];
        });
    }

}
- (void)removeRequestForKey:(NSString *)key
{
    if (nil != key )
    {
        dispatch_async(self.requestQueue, ^{
            [self.requestDict removeObjectForKey:key];
        });
    }

}
- (void)setRequest:(SNHTTPRequestOperation *)request forPageNameGroup:(NSString *)pageName
{
    if ( nil != request && pageName != nil )
    {
        dispatch_async(self.requestQueue, ^{
    
                // pageName对应的group是一个数组
                NSMutableArray * array = [self.requestDict objectForKey:pageName];
                if (nil == array)
                {
                    array = [[NSMutableArray alloc] init];
                }
                if ([array containsObject:request])
                {
                    [request cancel];
                    [array removeObject:request];
                }
                [array addObject:request];
                if ([array count] == 1)
                {
                    [self.requestDict setObject:array forKey:pageName];
                }
            
        });
    }
}

- (void)removeRequestForPageNameGroup:(NSString *)pageName
{
    if (pageName != nil)
    {
        dispatch_async(self.requestQueue, ^{
            NSMutableArray * array = [self.requestDict objectForKey:pageName];
            [self.requestDict removeObjectForKey:pageName];
            [array removeAllObjects];
        });
    }
}

- (void)cancelPatchRequestsForPageNameGroup:(NSString *)pageName
{
    if ( nil != pageName )
    {
        dispatch_async(self.requestQueue, ^{
            NSMutableArray * array = [self.requestDict objectForKey:pageName];
            [array enumerateObjectsUsingBlock:^(SNHTTPRequestOperation * obj, NSUInteger idx, BOOL *stop) {
                [obj cancel];
            }];
            [self.requestDict removeObjectForKey:pageName];
            [array removeAllObjects];
        });
    }
}

- (void)refreshLastRequest
{
    
}

@end
