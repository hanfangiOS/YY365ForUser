//
//  SNHTTPRequestOperation.h
//  SNArchitecture
//


#import <Foundation/Foundation.h>

typedef enum
{
    SNHTTPREQUESTMETHOD_GET = 1,
    SNHTTPREQUESTMETHOD_POST,
    SNHTTPREQUESTMETHOD_PUT,
    SNHTTPREQUESTMETHOD_DELETE
    
}SNHTTPRequestMethod;


@interface SNHTTPRequestOperation : NSObject

// 性能信息
//@property (nonatomic,readonly,assign) CFTimeInterval startTime;   // 请求发起时间
//@property (nonatomic,readonly,assign) CFTimeInterval netCost;     // 网络耗时
//@property (nonatomic,readonly,assign) CFTimeInterval  parseCost;   // 结果解析耗时,包括解析成model的耗时
//@property (nonatomic,readonly,assign) CFTimeInterval totalCost;   // 总耗时，netCost+parseCost

// 

@property (nonatomic,assign) SNHTTPRequestMethod requestMethod;

- (instancetype)initWithProxyObject:(id)object;

- (void)cancel;

@end


