//
//  NSDictionary+Safety.h
//  SNArchitecture
//


//

#import <Foundation/Foundation.h>
#import "NSDataProtocol.h"


@interface NSDictionary (Safety)

- (id)objectForKeySafely:(id)key;

@end

@interface NSMutableDictionary (Safety)

- (void)removeObjectForKeySafely:(id)aKey;

- (void)setObjectSafely:(id)anObject forKey:(id <NSCopying>)aKey;

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
- (void)setObjectSafely:(id)obj forKeyedSubscript:(id <NSCopying>)key;
#endif


@end

@interface NSDictionary (NSData) <NSDataProtocol>

- (NSData*)data;

@end