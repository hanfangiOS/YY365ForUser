//
//  NSArray+Safety.m
//  SNArchitecture
//


//

#import "NSArray+SNExtension.h"

@implementation NSArray (Extension)

- (id)objectAtIndexSafely:(NSUInteger)index
{
    if (index >= [self count])
    {
        return nil;
    }

    return [self objectAtIndex:index];
}

@end


@implementation NSMutableArray (Safety)

- (void)addObjectSafely:(id)anObject
{
    if (nil != anObject)
    {
        [self addObject:anObject];
    }
}
- (void)insertObjectSafely:(id)anObject atIndex:(NSUInteger)index
{
    if ( nil != anObject && index < [self count])
    {
        [self insertObject:anObject atIndex:index];
    }
}
- (void)removeObjectAtIndexSafely:(NSUInteger)index
{
    if ( index < [self count] )
    {
        [self removeObjectAtIndex:index];
    }
}
- (void)replaceObjectAtIndexSafely:(NSUInteger)index withObject:(id)anObject
{
    if ( nil != anObject && index < [self count] )
    {
        [self replaceObjectAtIndex:index withObject:anObject];
    }
}

@end

@implementation NSMutableArray (StackAndQueue)

- (NSMutableArray *)pushObject:(id)object
{
    [self addObjectSafely:object];
    return self;
}

- (NSMutableArray *)pushObjects:(id)object,...
{
    id obj = object;
	va_list objects;
	va_start(objects, object);
	do
	{
		[self addObjectSafely:obj];
		obj = va_arg(objects, id);
	} while (nil != obj);
	va_end(objects);
	return self;

}

- (id)pop
{
    id lastone = [self lastObject];
    [self removeLastObject];
    return lastone;
}

@end

@implementation NSArray (SNExtension)

- (BOOL)isEmpty
{
    return ([self count] == 0)?YES:NO;
}

@end

@implementation  NSMutableArray (SNExtension)

+ (NSMutableArray *)arrayWithSet:(NSSet *)sets
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[sets count]];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [array addObject:obj];
    }];
    return array;
}

@end

@implementation NSArray (NSData)

-(NSData*)data
{
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self];
    return data;
}

@end