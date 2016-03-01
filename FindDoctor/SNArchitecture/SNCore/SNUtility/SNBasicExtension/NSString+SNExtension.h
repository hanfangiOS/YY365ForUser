//
//  NSString+Safety.h
//  SNArchitecture
//


//

#import <Foundation/Foundation.h>
#import "NSDataProtocol.h"

@interface NSString (SNExtension)

- (BOOL)isEmpty;

- (BOOL)containsCharacterInSet:(NSCharacterSet *)searchSet;
- (BOOL)containsString:(NSString *)searchString options:(unsigned int)mask;
- (BOOL)containsString:(NSString *)searchString;

@end

@interface NSString (Algorithm)

- (NSString *)MD5;

@end

@interface NSString (HTML)

// 过滤转义字符
- (NSString *)htmlEntityDecoding;
- (NSString *)stringByStrippingHTML;


@end

@interface NSString (URL)

// 发送请求做URL
- (NSString *)URLEncoding;

- (NSString *)URLDecoding;

/**
 * Parses a URL query string into a dictionary.
 */
- (NSDictionary *)queryDictionaryUsingEncoding:(NSStringEncoding)encoding;

/**
 * Parses a URL, adds query parameters to its query, and re-encodes it as a new URL.
 */
- (NSString *)stringByAddingQueryDictionary:(NSDictionary *)query;


// 是否有效邮箱
+ (BOOL)isValidEmail:(NSString *)email;
- (BOOL)isValidEmail;

// 是否有效的HTTP
+ (BOOL)isValidHttpURL:(NSString *)httpurl;
- (BOOL)isValidHttpURL;

+ (BOOL)isValidPhoneNumber:(NSString *)phoneNumber;
- (BOOL)isValidPhoneNumber;

@end

@interface NSString (Version)

//字符串版本号大小比较
- (BOOL)isVersionEqualAndGreaterThan:(NSString *)version;
- (BOOL)isVersionEqualAndLessThan:(NSString *)version;

@end

@interface NSString (NSData) <NSDataProtocol>

- (NSData*)data;

@end

@interface NSString(JSONCategories)

- (id)JSONValue;
@end



