//
//  SNNetworkClient+Image.m
//  Weibo
//
//  Created by Wade Cheng on 3/23/12.
//  Copyright (c) 2012 Sina. All rights reserved.
//

#import "SNNetworkClient+Image.h"
#import "AFNetworking.h"
#import "SNHTTPRequestOperationWrapper.h"
#import "SNImageRequestOperation.h"

@interface SNNetworkClient ()
- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSMutableURLRequest *)request
                                                    wrapper:(SNHTTPRequestOperationWrapper *)wrapper;
- (SNHTTPRequestOperationWrapper *)enqueueOperationWithRequest:(NSMutableURLRequest *)request
                                                      settings:(NSDictionary *)settings
                                                  successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                                                  failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock;
@end

@interface SNHTTPRequestOperationWrapper ()
@property (nonatomic, retain) AFHTTPRequestOperation *operation;
@end

@implementation SNNetworkClient (Image)

#pragma mark - Perform Image request operation

- (id)cachedImageResponseObjectOfPath:(NSString *)path encodeAsImage:(BOOL)encodeAsImage
{
    return encodeAsImage ? [[SNNetworkImageCache sharedCache] imageFromURL:path] : [[SNNetworkImageCache sharedCache] imageDataFromURL:path];
}

- (SNHTTPRequestOperationWrapper *)_loadImageWithPath:(NSString *)path
                          callbackAfterImageFileSaved:(BOOL)callbackAfterImageFileSaved
                                       encodeAsImage:(BOOL)encodeAsImage
                                        successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                                        failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
{
    if (!path) return nil;
    
    BOOL memoryCached = [[SNNetworkImageCache sharedCache] hasMemoryCachedURL:path];
    if (memoryCached)
    {
        if (successBlock)
        {
            id cachedResponseObject = [self cachedImageResponseObjectOfPath:path encodeAsImage:encodeAsImage];
            if (cachedResponseObject)
            {
                successBlock(nil, cachedResponseObject);
            }
        }
        
        return nil;
    }
    
    BOOL diskCached = [[SNNetworkImageCache sharedCache] hasDiskCachedURL:path];
    if (diskCached)
    {
        if (successBlock)
        {
            id cachedResponseObject = [self cachedImageResponseObjectOfPath:path encodeAsImage:encodeAsImage];
            if (cachedResponseObject)
            {
                successBlock(nil, cachedResponseObject);
            }
        }
        
        return nil;
    }
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:path
                                                parameters:nil
                                                       tag:kSNNetworkRequestHeaderTagValueImage
                                   appendDefaultParameters:NO];
    NSDictionary *settings = [NSDictionary dictionaryWithObject:path forKey:kSNImageResponseOriginalPathKey];
    SNHTTPRequestOperationWrapper *wrapper = [self enqueueOperationWithRequest:request settings:settings successBlock:successBlock failureBlock:failureBlock];
    SNImageRequestOperation *operation = (SNImageRequestOperation *)wrapper.operation;
    operation.encodeAsImage = encodeAsImage;
    operation.callbackAfterImageFileSaved = callbackAfterImageFileSaved;
    
    return wrapper;
}

- (SNHTTPRequestOperationWrapper *)loadImageFileWithPath:(NSString *)path
                                           encodeAsImage:(BOOL)encodeAsImage
                                            successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                                            failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
{
    return [self _loadImageWithPath:path callbackAfterImageFileSaved:YES encodeAsImage:encodeAsImage successBlock:successBlock failureBlock:failureBlock];
}

- (SNHTTPRequestOperationWrapper *)loadImageWithPath:(NSString *)path
                                       encodeAsImage:(BOOL)encodeAsImage
                                        successBlock:(SNHTTPRequestOperationSuccessBlock)successBlock
                                        failureBlock:(SNHTTPRequestOperationFailureBlock)failureBlock
{
    return [self _loadImageWithPath:path callbackAfterImageFileSaved:NO encodeAsImage:encodeAsImage successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark - Use wrapper to load a image

- (void)_loadImageWithWrapper:(SNHTTPRequestOperationWrapper *)wrapper path:(NSString *)path callbackAfterImageFileSaved:(BOOL)callbackAfterImageFileSaved encodeAsImage:(BOOL)encodeAsImage
{
    if (!path) return;
    
    BOOL memoryCached = [[SNNetworkImageCache sharedCache] hasMemoryCachedURL:path];
    if (memoryCached)
    {
        id cachedResponseObject = [self cachedImageResponseObjectOfPath:path encodeAsImage:encodeAsImage];
        if (cachedResponseObject)
        {
            [wrapper callbackSuccessBlockInSuccessQueueWithResponseObject:cachedResponseObject];
        }
        
        return;
    }
    
    BOOL diskCached = [[SNNetworkImageCache sharedCache] hasDiskCachedURL:path];
    if (diskCached)
    {
        id cachedResponseObject = [self cachedImageResponseObjectOfPath:path encodeAsImage:encodeAsImage];
        if (cachedResponseObject)
        {
            [wrapper callbackSuccessBlockInSuccessQueueWithResponseObject:cachedResponseObject];
        }
        
        return;
    }
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET"
                                                      path:path
                                                parameters:nil
                                                       tag:kSNNetworkRequestHeaderTagValueImage
                                   appendDefaultParameters:NO];
    [wrapper resetRequest:request];
    wrapper.settings = [NSDictionary dictionaryWithObject:path forKey:kSNImageResponseOriginalPathKey];
    SNImageRequestOperation *operation = (SNImageRequestOperation *)[self HTTPRequestOperationWithRequest:request wrapper:wrapper];
    operation.encodeAsImage = encodeAsImage;
    operation.callbackAfterImageFileSaved = callbackAfterImageFileSaved;
    [self enqueueHTTPRequestOperation:operation];
}

- (void)loadImageFileWithWrapper:(SNHTTPRequestOperationWrapper *)wrapper
                            path:(NSString *)path
                   encodeAsImage:(BOOL)encodeAsImage
{
    [self _loadImageWithWrapper:wrapper path:path callbackAfterImageFileSaved:YES encodeAsImage:encodeAsImage];
}

- (void)loadImageWithWrapper:(SNHTTPRequestOperationWrapper *)wrapper path:(NSString *)path encodeAsImage:(BOOL)encodeAsImage
{
    [self _loadImageWithWrapper:wrapper path:path callbackAfterImageFileSaved:NO encodeAsImage:encodeAsImage];
}

@end
