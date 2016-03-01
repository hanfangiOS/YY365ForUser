//
//  NSMutableArray+SNSlideStack.m
//  SNSlideController
//
//  Created by Nova on 13-4-2.
//  Copyright (c) 2013年. All rights reserved.
//

#import "NSMutableArray+SNSlideStack.h"

@implementation NSMutableArray (SNSlideStack)

- (BOOL)canPushController:(UIViewController *)controller
{
    if ([self containsObject:controller]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)pushController:(UIViewController *)controller
{
    if ([self containsObject:controller]) {
        return NO;
    }
    
    [self addObject:controller];
    return YES;
}

- (BOOL)popController:(UIViewController *)controller
{
    if ([self containsObject:controller]) {
        NSInteger index = [self indexOfObject:controller];
        if (index < self.count)
        {
            [self removeObjectAtIndex:index];
        }
        return YES;
    }
    else {
        return NO;
    }
}

- (NSArray *)popAllController
{
    NSArray *arr = [NSArray arrayWithArray:self];
    [self removeAllObjects];
    return arr;
}

- (NSArray *)popControllersToIndex:(NSInteger)index
{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i = self.count-1; i >= index; i--) {
        [arr addObject:[self objectAtIndex:i]];
    }
    
    [self removeObjectsInArray:arr];
    
    return [arr autorelease];
}

- (UIViewController *)previousControllerInStack
{
    return self.lastObject;
}

- (UIViewController *)currentControllerInStack
{
    return self.lastObject;
}

- (UIViewController *)belowControllerInStack
{
    if (self.count < 2) {
        return nil;
    }
    
    return [self objectAtIndex:self.count-2];
}

- (void)replaceController:(UIViewController *)oldController withController:(UIViewController *)newController
{
    if ([self containsObject:oldController]) {
        [self replaceObjectAtIndex:[self indexOfObject:oldController] withObject:newController];
    }
}

@end
