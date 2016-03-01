//
//  AFHTTPRequestOperation+SNNetworking.h
//  Weibo
//
//  Created by Wade Cheng on 5/15/12.
//  Copyright (c) 2012 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

@interface AFHTTPRequestOperation (SNNetworking)

- (void)clearBlocksAfterComplete;

@end
