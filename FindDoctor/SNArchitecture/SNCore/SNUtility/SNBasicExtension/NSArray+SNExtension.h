//
//  NSArray+Safety.h
//  SNArchitecture
//


//

#import <Foundation/Foundation.h>
#import "NSDataProtocol.h"


@interface NSArray (Safety)

- (id)objectAtIndexSafely:(NSUInteger)index;

@end


@interface NSMutableArray (Safety)

- (void)addObjectSafely:(id)anObject;
- (void)insertObjectSafely:(id)anObject atIndex:(NSUInteger)index;
- (void)removeObjectAtIndexSafely:(NSUInteger)index;
- (void)replaceObjectAtIndexSafely:(NSUInteger)index withObject:(id)anObject;

@end


@interface NSMutableArray (StackAndQueue)

- (NSMutableArray *)pushObject:(id)object;
- (NSMutableArray *)pushObjects:(id)object,...;

- (id)pop;


@end

@interface NSArray (SNExtension)

- (BOOL)isEmpty;

@end

@interface NSMutableArray (SNExtension)

// 把set转化成可变数组
+ (NSMutableArray *)arrayWithSet:(NSSet *)sets;

@end

@interface NSArray (NSData) <NSDataProtocol>

- (NSData*)data;

@end