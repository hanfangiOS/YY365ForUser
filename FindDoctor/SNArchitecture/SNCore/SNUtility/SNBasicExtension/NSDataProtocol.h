//
//  NSDataProtocol.h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol NSDataProtocol <NSObject>

@optional

- (NSData*)data;
- (NSArray*)array;
- (NSDictionary*)dictionary;
- (UIImage*)image;

@end
