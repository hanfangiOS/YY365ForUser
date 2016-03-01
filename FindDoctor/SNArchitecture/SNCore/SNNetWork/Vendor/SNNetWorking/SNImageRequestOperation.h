//
//  SNImageRequestOperation.h
//  Weibo
//
//  Created by Wade Cheng on 3/13/12.
//  Copyright (c) 2012 Sina. All rights reserved.
//

#import "AFImageRequestOperation.h"
#import "SNNetworking.h"

@interface SNImageRequestOperation : AFImageRequestOperation <SNConfiguableRequestOperation>
{
    BOOL encodeAsImage;
    BOOL callbackAfterImageFileSaved;
    NSString *originalPath;
    
    id responseObject;
}

@property (nonatomic, assign) BOOL encodeAsImage;
@property (nonatomic, assign) BOOL callbackAfterImageFileSaved;

@end
