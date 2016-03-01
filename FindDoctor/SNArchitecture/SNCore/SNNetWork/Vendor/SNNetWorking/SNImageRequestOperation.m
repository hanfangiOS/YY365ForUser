//
//  SNImageRequestOperation.m
//  Weibo
//
//  Created by Wade Cheng on 3/13/12.
//  Copyright (c) 2012 Sina. All rights reserved.
//

#import "SNImageRequestOperation.h"

@implementation SNImageRequestOperation

@synthesize encodeAsImage;
@synthesize callbackAfterImageFileSaved;

- (void)configWithSettings:(NSDictionary *)settings
{
    [originalPath release];
    originalPath = [[settings objectForKey:kSNImageResponseOriginalPathKey] retain];
}

+ (BOOL)canProcessRequest:(NSURLRequest *)request
{
    // 只接受图片request
    NSString *requestTag = [request valueForHTTPHeaderField:kSNNetworkRequestHeaderTagName];
    
    return [requestTag isEqualToString:kSNNetworkRequestHeaderTagValueImage];
}

- (UIImage *)responseImage
{
    NSString *URLString = originalPath;
    if (!URLString)
    {
        URLString = [self.request.URL absoluteString];
    }
    
    if (!responseObject)
    {
        if (encodeAsImage)
        {
            responseObject = [UIImage imageWithData:self.responseData];
            if (responseObject)
            {
                [[SNNetworkImageCache sharedCache] storeImage:responseObject withData:[super responseData] forURL:URLString sync:callbackAfterImageFileSaved];
            }
        }
        else
        {
            responseObject = self.responseData;
            [[SNNetworkImageCache sharedCache] storeImageData:responseObject forURL:URLString sync:callbackAfterImageFileSaved];
        } 
    }
    
    return (UIImage *)responseObject;
}

- (void)dealloc
{
    [originalPath release], originalPath = nil;
    [super dealloc];
}

@end
