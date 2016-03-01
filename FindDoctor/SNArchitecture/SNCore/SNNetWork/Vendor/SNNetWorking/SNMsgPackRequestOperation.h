//
//  SNMsgpackRequestOperation.h
//  SinaNews
//
//  Created by li na on 13-8-5.
//  Copyright (c) 2013年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNMsgPackRequestOperation : AFHTTPRequestOperation

@property (readonly, nonatomic, retain) id responseMsgPack;

+ (SNMsgPackRequestOperation *)MsgPackRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id MsgPack))success
                                                    failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id MsgPack))failure;

@end
