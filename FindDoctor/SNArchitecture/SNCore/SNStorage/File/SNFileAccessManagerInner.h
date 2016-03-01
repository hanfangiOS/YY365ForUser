//
//  SNFileAccessManagerInner.h
//  本类均提供主线程同步方法


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SNStorageProtocol.h"

@interface SNFileAccessManagerInner : NSObject<SNStorageProtocol>

+ (NSString *)fullPathWithNameSpace:(NSString *)spaceName;
+ (NSString *)fullFilePathForKey:(NSString *)key nameSpace:(NSString *)nameSpace;

+(BOOL)cleanNameSpace:(NSString *)nameSpace withError:(NSError **)error;

@end

@interface SNFileAccessManagerInner (Size)

+(CGFloat)sizeOfNameSpace:(NSString *)nameSpace;

- (CGFloat)sizeOfObjectForKey:(NSString *)key;
+ (CGFloat)sizeOfObjectForKey:(NSString *)key underNameSpace:(NSString *)nameSpace;

@end
