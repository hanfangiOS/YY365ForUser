//
//  NSNotificationCenter+Thread.m


#import "NSNotificationCenter+Thread.h"
#import <objc/message.h>

@implementation NSNotificationCenter (Thread)

- (void)postNotificationNameOnMainThread:(NSString *)aName
                                  object:(id)anObject
                                userInfo:(NSDictionary *)aUserInfo
{
    if ([NSThread isMainThread]) {
        [self postNotificationName:aName object:anObject userInfo:aUserInfo];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postNotificationName:aName object:anObject userInfo:aUserInfo];
        });
    }
}

@end
