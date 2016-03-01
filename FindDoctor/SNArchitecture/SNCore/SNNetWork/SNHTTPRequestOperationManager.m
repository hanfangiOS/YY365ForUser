//
//  SNHTTPRequestOperationManager.m
//  SNArchitecture
//
//  Created by li na on 15/2/9.
//  Copyright (c) 2015年 li na. All rights reserved.
//
#warning TODO
/*
 1、支持其他解析格式
 2、超时时间
 3、优先级默认参数
 */

#import "SNHTTPRequestOperationManager.h"
#import "SNNetWork.h"
//---------------引用第三方库Vendor---------------
//#define AFNetWorking_2_x
#if defined(AFNetWorking_2_x)
#import "AFHTTPRequestOperationManager.h"
#elif defined(AFNetWorking_1_x)
#import "SNNetworkClient.h"
#import "SNHTTPRequestOperationWrapper.h"
#endif


//----------------------------------------------

@interface SNHTTPRequestOperationManager()
@property (nonatomic,readwrite,strong) NSURL * baseURL;
#if defined(AFNetWorking_2_x)
@property (nonatomic,strong)AFHTTPRequestOperationManager * JSONManager;
#elif defined(AFNetWorking_1_x)
@property (nonatomic,strong)SNNetworkClient * JSONManager;
#endif
@end

@implementation SNHTTPRequestOperationManager

@synthesize baseURL = _baseURL;

+ (instancetype)manager
{
    static SNHTTPRequestOperationManager * _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[SNHTTPRequestOperationManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
   return [self initWithBaseURL:nil];
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    // Ensure terminal slash for baseURL path, so that NSURL +URLWithString:relativeToURL: works as expected
    if ([[url path] length] > 0 && ![[url absoluteString] hasSuffix:@"/"])
    {
        url = [url URLByAppendingPathComponent:@""];
    }
    
    self.baseURL = url;
    
    //---------------Vendor---------------
#if defined(AFNetWorking_2_x)
    self.JSONManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    self.JSONManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.JSONManager.responseSerializer = [AFJSONResponseSerializer serializer];
#elif defined(AFNetWorking_1_x)
    self.JSONManager = [[SNNetworkClient alloc] initWithBaseURL:url];
    [self.JSONManager registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self .JSONManager setDefaultHeader:@"Accept" value:@"text/plain"];
    [self.JSONManager setParameterEncoding:AFJSONParameterEncoding];
#endif
    
    return self;
}

- (void)setDefaultParameter:(NSString *)parameter value:(NSString *)value
{
#if defined(AFNetWorking_1_x)
    [self.JSONManager setDefaultParameter:parameter value:value];
#endif
}


/*
 *  http request：request & cancel
 */
- (SNHTTPRequestOperation *)GET:(NSString *)path
                parameters:(NSDictionary *)parameters
              successBlock:(SNHTTPRequestSuccessBlock)snSuccessBlock
              failureBlock:(SNHTTPRequestFailureBlock)snFailureBlock
  callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
{
#if defined(AFNetWorking_1_x)
    SNHTTPRequestOperation * snOperation = nil;
    SNHTTPRequestOperationWrapper * wrapper = [self.JSONManager getPath:path parameters:parameters successBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, id responseObject) {
       
        snSuccessBlock(snOperation,responseObject);
        
    } failureBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, NSError *error) {
        
        snFailureBlock(snOperation,error);
//        [self.requestArray removeObject:snOperation];
        
    } callbackRunInGlobalQueue:runInGlobalQueue];
   
    snOperation = [[SNHTTPRequestOperation alloc] initWithProxyObject:wrapper];
//    [self.requestArray addObject:snOperation];
    return snOperation;
#endif
}

- (SNHTTPRequestOperation *)POST:(NSString *)path
                  parameters:(NSDictionary *)parameters
               successBlock:(SNHTTPRequestSuccessBlock)snSuccessBlock
               failureBlock:(SNHTTPRequestFailureBlock)snFailureBlock
   callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
{
#if defined(AFNetWorking_1_x)
    SNHTTPRequestOperation * snOperation = nil;
    SNHTTPRequestOperationWrapper * wrapper = [self.JSONManager postPath:path parameters:parameters successBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, id responseObject) {
        
        snSuccessBlock(snOperation,responseObject);
//        [self.requestArray removeObject:snOperation];
        
    } failureBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, NSError *error) {
        
        snFailureBlock(snOperation,error);
//        [self.requestArray removeObject:snOperation];
        
    } callbackRunInGlobalQueue:runInGlobalQueue];
    
    snOperation = [[SNHTTPRequestOperation alloc] initWithProxyObject:wrapper];
//    [self.requestArray addObject:snOperation];
    return snOperation;
#endif

}

- (SNHTTPRequestOperation *)PUT:(NSString *)path
                parameters:(NSDictionary *)parameters
              successBlock:(SNHTTPRequestSuccessBlock)snSuccessBlock
              failureBlock:(SNHTTPRequestFailureBlock)snFailureBlock
  callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
{
#if defined(AFNetWorking_1_x)
    SNHTTPRequestOperation * snOperation = nil;
    SNHTTPRequestOperationWrapper * wrapper = [self.JSONManager putPath:path parameters:parameters successBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, id responseObject) {
        
        snSuccessBlock(snOperation,responseObject);
//        [self.requestArray removeObject:snOperation];
        
    } failureBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, NSError *error) {
        
        snFailureBlock(snOperation,error);
//        [self.requestArray removeObject:snOperation];
        
    } callbackRunInGlobalQueue:runInGlobalQueue];
    
    snOperation = [[SNHTTPRequestOperation alloc] initWithProxyObject:wrapper];
//    [self.requestArray addObject:snOperation];
    return snOperation;
#endif

}

- (SNHTTPRequestOperation *)DELETE:(NSString *)path
                   parameters:(NSDictionary *)parameters
                 successBlock:(SNHTTPRequestSuccessBlock)snSuccessBlock
                 failureBlock:(SNHTTPRequestFailureBlock)snFailureBlock
     callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
{
#if defined(AFNetWorking_1_x)
    SNHTTPRequestOperation * snOperation = nil;
    SNHTTPRequestOperationWrapper * wrapper = [self.JSONManager deletePath:path parameters:parameters successBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, id responseObject) {
        
        snSuccessBlock(snOperation,responseObject);
//        [self.requestArray removeObject:snOperation];
        
    } failureBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, NSError *error) {
        
        snFailureBlock(snOperation,error);
//        [self.requestArray removeObject:snOperation];
        
    } callbackRunInGlobalQueue:runInGlobalQueue];
    
    snOperation = [[SNHTTPRequestOperation alloc] initWithProxyObject:wrapper];
//    [self.requestArray addObject:snOperation];
    return snOperation;
#endif

}


- (void)cancelRequest:(SNHTTPRequestOperation *)request
{
    [request cancel];
}

- (void)cancelAllRequest
{
    [self.operationQueue cancelAllOperations];
//    [self.requestArray removeAllObjects];
}


- (NSOperationQueue *)operationQueue
{
    return self.JSONManager.operationQueue;
}

- (void)dealloc
{
    [self cancelAllRequest];
}

@end
