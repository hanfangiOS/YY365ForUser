//
//  SNServerAPIManager.h
//  SNArchitecture
//
//  Created by li na on 15/2/16.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNHTTPRequestOperation.h"
#import "SNHTTPRequestOperationManager.h"
#import "SNServerAPIDataParser.h"
#import "SNServerAPIResultData.h"

typedef void(^SNServerAPIResultBlock)(SNHTTPRequestOperation * request,SNServerAPIResultData * result);
typedef void(^SNServerAPIProgressBlock)(float progress);


@interface SNServerAPIManager : NSObject


// request
@property (nonatomic,strong,readonly) NSString * server;


/*server其实就是baseURL*/
- (instancetype)initWithServer:(NSString *)server;

// 设置公共参数
- (void)setDefaultParameter:(NSString *)parameter value:(NSString *)value;

/*
 *  http request:get or post
 *  @param key  使用key作为一个请求的key，请求时会自动存储在dict中
 *  @param pageName 可以使用pageName作为一个页面所有请求的key，请求时会自动将请求批量存储为array
 *  @param parser是解析使用的类，一般是单例，因为一个业务模块对应着一个parser
 *  @param parseMethod是parser的一个方法
 */
- (SNHTTPRequestOperation *)GET:(NSString *)api
                     parameters:(NSDictionary *)parameters
       callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
                         parser:(SNServerAPIDataParser *)parser
                    parseMethod:(SEL)parseMethod
                    resultBlock:(SNServerAPIResultBlock)resultBlock;

- (SNHTTPRequestOperation *)GET:(NSString *)api
                     parameters:(NSDictionary *)parameters
       callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
                         parser:(SNServerAPIDataParser *)parser
                    parseMethod:(SEL)parseMethod
                   resultBlock:(SNServerAPIResultBlock)resultBlock
                         forKey:(NSString *)key;

- (SNHTTPRequestOperation *)GET:(NSString *)api
                     parameters:(NSDictionary *)parameters
       callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
                         parser:(SNServerAPIDataParser *)parser
                    parseMethod:(SEL)parseMethod
                   resultBlock:(SNServerAPIResultBlock)resultBlock                forPageNameGroup:(NSString *)pageName;

- (SNHTTPRequestOperation *)GET:(NSString *)api
                     parameters:(NSDictionary *)parameters
       callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
                         parser:(SNServerAPIDataParser *)parser
                    parseMethod:(SEL)parseMethod
                   resultBlock:(SNServerAPIResultBlock)resultBlock
                         forKey:(NSString *)key
               forPageNameGroup:(NSString *)pageName;

- (SNHTTPRequestOperation *)POST:(NSString *)api
                     parameters:(NSDictionary *)parameters
       callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
                         parser:(SNServerAPIDataParser *)parser
                    parseMethod:(SEL)parseMethod
                    resultBlock:(SNServerAPIResultBlock)resultBlock;

- (SNHTTPRequestOperation *)POST:(NSString *)api
                     parameters:(NSDictionary *)parameters
       callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
                         parser:(SNServerAPIDataParser *)parser
                    parseMethod:(SEL)parseMethod
                    resultBlock:(SNServerAPIResultBlock)resultBlock
                         forKey:(NSString *)key;

- (SNHTTPRequestOperation *)POST:(NSString *)api
                     parameters:(NSDictionary *)parameters
       callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
                         parser:(SNServerAPIDataParser *)parser
                    parseMethod:(SEL)parseMethod
                    resultBlock:(SNServerAPIResultBlock)resultBlock                forPageNameGroup:(NSString *)pageName;

- (SNHTTPRequestOperation *)POST:(NSString *)api
                     parameters:(NSDictionary *)parameters
       callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
                         parser:(SNServerAPIDataParser *)parser
                    parseMethod:(SEL)parseMethod
                    resultBlock:(SNServerAPIResultBlock)resultBlock
                         forKey:(NSString *)key
               forPageNameGroup:(NSString *)pageName;

- (SNHTTPRequestOperation *)POST:(NSString *)api
                      parameters:(NSDictionary *)parameters
        callbackRunInGlobalQueue:(BOOL)runInGlobalQueue
                          parser:(SNServerAPIDataParser *)parser
                     parseMethod:(SEL)parseMethod
                          object:(id)object
                     resultBlock:(SNServerAPIResultBlock)resultBlock
                          forKey:(NSString *)key
                forPageNameGroup:(NSString *)pageName;


/*
 *用key给某一个请求进行记录和取消操作
 */
- (void)cancelRequestForKey:(NSString *)key;

/*
 *批量请求取消一个页面的所有请求，例如点击返回页面弹出时
 *@param pageName
 */
- (void)cancelPatchRequestsForPageNameGroup:(NSString *)pageName;

/*重新请求最近的一个request*/
#warning TODO
- (void)refreshLastRequest;
- (void)refreshRequestForKey:(NSString *)key;

@end
