//
//  NSObject+SNExtension.h
//  SNArchitecture
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Safety)

- (id)valueForKeySafely:(NSString *)key;
- (id)valueForKeyPathSafely:(NSString *)keyPath;

- (void)enumerateObjectsUsingBlockSafety:(void (^)(id  _Nonnull obj, NSUInteger idx, BOOL *stop))block;

@end

@interface NSObject (SNExtension)

//多参数perform扩展
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3;
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
           withObject:(id)p4;
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
           withObject:(id)p4 withObject:(id)p5;
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
           withObject:(id)p4 withObject:(id)p5 withObject:(id)p6;
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
           withObject:(id)p4 withObject:(id)p5 withObject:(id)p6 withObject:(id)p7;

//- (void)enumerateObjectsUsingBlockSafety:(void (^)(ObjectType obj, NSUInteger idx, BOOL *stop))block;
@end

NS_ASSUME_NONNULL_END