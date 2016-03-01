//
//  AFHTTPRequestOperation+SNNetworking.m
//  Weibo
//
//  Created by Wade Cheng on 5/15/12.
//  Copyright (c) 2012 Sina. All rights reserved.
//

#import "AFHTTPRequestOperation+SNNetworking.h"

@implementation AFHTTPRequestOperation (SNNetworking)

- (void)clearBlocksAfterComplete
{
    [self setUploadProgressBlock:nil];
    [self setDownloadProgressBlock:nil];
    [self setCompletionBlock:nil];
    [self setAuthenticationAgainstProtectionSpaceBlock:nil];
    [self setAuthenticationChallengeBlock:nil];
    [self setCacheResponseBlock:nil];
}

@end
