//
//  SNSingleton.h
//  SNArchitecture
//


//

#import <Foundation/Foundation.h>

#undef SINGLETON_DECLARE
#define SINGLETON_DECLARE( __class )\
+ ( __class *)sharedInstance;

#undef SINGLETON_IMPLENTATION
#define SINGLETON_IMPLENTATION( __class )\
+ ( __class *)sharedInstance\
{\
    static dispatch_once_t once;\
    static __class * _instance;\
    dispatch_once(&once, ^{_instance = [[__class alloc] init];});\
    return _instance;\
}


@interface SNSingleton : NSObject

@end
