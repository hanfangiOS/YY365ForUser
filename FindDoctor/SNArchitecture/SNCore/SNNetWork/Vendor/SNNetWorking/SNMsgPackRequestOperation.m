//
//  SNMsgpackRequestOperation.m
//  SinaNews
//
//  Created by li na on 13-8-5.
//  Copyright (c) 2013年 sina. All rights reserved.
//

#import "SNMsgPackRequestOperation.h"
#import "MessagePack.h"

static dispatch_queue_t sn_msgpack_request_operation_processing_queue;
static dispatch_queue_t msgpack_request_operation_processing_queue() {
    if (sn_msgpack_request_operation_processing_queue == NULL) {
        sn_msgpack_request_operation_processing_queue = dispatch_queue_create("com.sina.networking.msgpack-request.processing", 0);
    }
    
    return sn_msgpack_request_operation_processing_queue;
}

@interface SNMsgPackRequestOperation ()
@property (readwrite, nonatomic, retain) id responseMsgPack;
@property (readwrite, nonatomic, retain) NSError *MsgPackError;
@end

@implementation SNMsgPackRequestOperation
@synthesize responseMsgPack = _responseMsgPack;
@synthesize MsgPackError = _MsgPackError;

+ (SNMsgPackRequestOperation *)MsgPackRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id MsgPack))success
                                                    failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id MsgPack))failure
{
    SNMsgPackRequestOperation *requestOperation = [[[self alloc] initWithRequest:urlRequest] autorelease];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation.request, operation.response, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation.request, operation.response, error, [(SNMsgPackRequestOperation *)operation responseMsgPack]);
        }
    }];
    
    return requestOperation;
}

- (void)dealloc {
    [_responseMsgPack release];
    [_MsgPackError release];
    [super dealloc];
}

- (id)responseMsgPack
{
    if (!_responseMsgPack
        && [self.responseData length] > 0
        && [self isFinished]
        && !self.MsgPackError)
    {
        NSError *error = nil;
        
        if ([self.responseData length] == 0)
        {
            self.responseMsgPack = nil;
        }
        else
        {
            //            NSLog(@"----------MsgPack-----------");
            //            NSLog(@"Before Parsed Size = %.3f(kb)",[self.responseData length]/1024.0);
            //            NSDate * date1 = [NSDate date];
            
            id responseData = nil;
            @try
            {
                responseData = [self.responseData messagePackParse];
            }
            @catch (NSException *exception)
            {
                ;
            }
            @finally {
                 self.responseMsgPack = responseData;
            }
            
            //            NSLog(@"Parse Time = %.3f(ms)",abs([date1 timeIntervalSinceNow]*1000000)/1000.0);
            
        }
        
        self.MsgPackError = error;
    }
    
    return _responseMsgPack;
}


- (NSError *)error {
    if (_MsgPackError) {
        return _MsgPackError;
    } else {
        return [super error];
    }
}

#pragma mark - AFHTTPRequestOperation

+ (NSSet *)acceptableContentTypes
{
    return [NSSet setWithObjects:@"application/x-msgpack",@"text/html",nil];
}

+ (BOOL)canProcessRequest:(NSURLRequest *)request {
   
    return [[[request URL] pathExtension] isEqualToString:@"msgpack"] || [super canProcessRequest:request];    
}

- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    self.completionBlock = ^ {
        if ([self isCancelled]) {
            return;
        }
        
        if (self.error) {
            if (failure) {
                dispatch_async(self.failureCallbackQueue ? self.failureCallbackQueue : dispatch_get_main_queue(), ^{
                    failure(self, self.error);
                });
            }
        } else {
            dispatch_async(msgpack_request_operation_processing_queue(), ^{
                id MsgPack = self.responseMsgPack;
                
                if (self.MsgPackError) {
                    if (failure) {
                        dispatch_async(self.failureCallbackQueue ? self.failureCallbackQueue : dispatch_get_main_queue(), ^{
                            failure(self, self.error);
                        });
                    }
                } else {
                    if (success) {
                        dispatch_async(self.successCallbackQueue ? self.successCallbackQueue : dispatch_get_main_queue(), ^{
                            success(self, MsgPack);
                        });
                    }
                }
            });
        }
    };
}


@end
