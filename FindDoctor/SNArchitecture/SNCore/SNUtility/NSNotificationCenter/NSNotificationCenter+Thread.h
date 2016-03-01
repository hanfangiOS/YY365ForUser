//
//  NSNotificationCenter+Thread.h


#import <Foundation/Foundation.h>

@interface NSNotificationCenter (Thread)

- (void)postNotificationNameOnMainThread:(NSString *)aName
                                  object:(id)anObject
                                userInfo:(NSDictionary *)aUserInfo;

@end
