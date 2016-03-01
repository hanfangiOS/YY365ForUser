//
//  SNHTTPRequest.m
//  SNArchitecture

//---------------引用第三方库Vendor---------------
#if defined(AFNetWorking_2_x)
#import "AFHTTPRequestOperation.h"
#elif defined(AFNetWorking_1_x)
#import "SNHTTPRequestOperationWrapper.h"
#endif

//----------------------------------------------

#import "SNHTTPRequestOperation.h"

@interface SNHTTPRequestOperation ()

@property (nonatomic,strong) id proxyObject;

@end


@implementation SNHTTPRequestOperation

- (instancetype)initWithProxyObject:(id)object
{
    if (self = [super init])
    {
        self.proxyObject = object;
    }
    return self;
}

#if defined(AFNetWorking_2_x)
- (AFHTTPRequestOperation *)proxyObject
{
    return (AFHTTPRequestOperation *)_proxyObject;
}
#elif defined(AFNetWorking_1_x)
- (SNHTTPRequestOperationWrapper *)proxyObject
{
    return (SNHTTPRequestOperationWrapper *)_proxyObject;
}
#endif

- (void)cancel
{
    #if defined(AFNetWorking_2_x)
    [self.proxyObject cancel];
    #elif defined(AFNetWorking_1_x)
    [self.proxyObject cancel];
    #endif
}


@end
