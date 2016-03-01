//
//  NSSet+Safety.m
//  SNArchitecture
//


//

#import "NSSet+SNExtension.h"

@implementation NSMutableSet (Safety)

- (void)addObjectSafely:(id)object
{
    if (nil != object)
    {
        [self addObject:object];
    }
}

@end
