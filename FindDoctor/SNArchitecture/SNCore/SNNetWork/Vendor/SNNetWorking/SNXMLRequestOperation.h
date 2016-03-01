//
//  SNXMLRequestOperation.h
//  Weibo
//
//  Created by Wade Cheng on 3/23/12.
//  Copyright (c) 2012 Sina. All rights reserved.
//

#import "AFXMLRequestOperation.h"
#import "AFNetworking.h"
#import "SNNetworkClient.h"

@class TBXML;

@interface SNXMLRequestOperation : AFHTTPRequestOperation <SNConfiguableRequestOperation>
{
    NSError *_XMLError;
    NSArray *_arrayQueryPaths;
    id _responseXML;
}

@property (readonly, nonatomic, retain) id responseXML;

- (BOOL)validateXMLStructureBeforeParse:(TBXML *)tbxml;
- (BOOL)validateXMLStructureAfterParse:(TBXML *)tbxml;

@end