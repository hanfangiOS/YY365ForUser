//
//  SNHTTPRequestOperationManager.h
//  SNArchitecture
//
//  Created by li na on 15/2/9.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNHTTPRequestOperation.h"


typedef void(^SNHTTPRequestSuccessBlock)(SNHTTPRequestOperation * request,id responseObject);
typedef void(^SNHTTPRequestFailureBlock)(SNHTTPRequestOperation * request,NSError *error);

#pragma SNHTTPRequestOperationManager

@interface SNHTTPRequestOperationManager : NSObject

@property (nonatomic,strong,readonly)NSURL * baseURL;
//@property (nonatomic,strong)NSMutableArray * requestArray;
@property (nonatomic,strong)NSOperationQueue * operationQueue;

+ (instancetype)manager;
- (instancetype)initWithBaseURL:(NSString *)url;

- (void)setDefaultParameter:(NSString *)parameter value:(NSString *)value;

/*
 *  http request：request & cancel
 */
- (SNHTTPRequestOperation *)GET:(NSString *)path
                 parameters:(NSDictionary *)parameters
               successBlock:(SNHTTPRequestSuccessBlock)snSuccessBlock
               failureBlock:(SNHTTPRequestFailureBlock)snFailureBlock
   callbackRunInGlobalQueue:(BOOL)runInGlobalQueue;

- (SNHTTPRequestOperation *)POST:(NSString *)path
                  parameters:(NSDictionary *)parameters
               successBlock:(SNHTTPRequestSuccessBlock)snSuccessBlock
               failureBlock:(SNHTTPRequestFailureBlock)snFailureBlock
   callbackRunInGlobalQueue:(BOOL)runInGlobalQueue;

- (SNHTTPRequestOperation *)PUT:(NSString *)path
                 parameters:(NSDictionary *)parameters
               successBlock:(SNHTTPRequestSuccessBlock)snSuccessBlock
               failureBlock:(SNHTTPRequestFailureBlock)snFailureBlock
   callbackRunInGlobalQueue:(BOOL)runInGlobalQueue;

- (SNHTTPRequestOperation *)DELETE:(NSString *)path
                 parameters:(NSDictionary *)parameters
               successBlock:(SNHTTPRequestSuccessBlock)snSuccessBlock
               failureBlock:(SNHTTPRequestFailureBlock)snFailureBlock
   callbackRunInGlobalQueue:(BOOL)runInGlobalQueue;


//- (void)refreshRequest:(SNHTTPRequestOperation *)request;
- (void)cancelRequest:(SNHTTPRequestOperation *)request;
- (void)cancelAllRequest;

@end
