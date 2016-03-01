//
//  NSDictionary+Safety.m
//  SNArchitecture
//


//

#import "NSDictionary+SNExtension.h"


@implementation NSDictionary (Safety)

- (id)objectForKeySafely:(id)key
{
    id object = [self objectForKey:key];
    return (object == [NSNull null])?nil:object;
}

@end


@implementation NSMutableDictionary (Safety)

- (void)removeObjectForKeySafely:(id)aKey
{
    if (nil != aKey)
    {
        [self removeObjectForKey:aKey];
    }
}
- (void)setObjectSafely:(id)anObject forKey:(id <NSCopying>)aKey
{
    if (nil != anObject && nil != aKey)
    {
        [self setObject:anObject forKey:aKey];
    }
}


#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
- (void)setObjectSafely:(id)obj forKeyedSubscript:(id <NSCopying>)key
{
    if (nil != obj && nil != key)
    {
        [self setObject:obj forKeyedSubscript:key];
    }
}
#endif

@end

@implementation  NSDictionary (NSData)

- (NSData*)data
{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self];
    return data;

}

@end


