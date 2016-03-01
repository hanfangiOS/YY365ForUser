//
//  NSString+Safety.m
//  SNArchitecture
//


//

#import "NSString+SNExtension.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (SNExtension)

- (BOOL)isEmpty
{
    return ([self length] > 0)?NO:YES; // can be false when [string isEqualToString:@""] is true, because these are Unicode strings.
    //return (self == nil || [self isEqualToString:@""]);
}

- (BOOL)containsCharacterInSet:(NSCharacterSet *)searchSet
{
    NSRange characterRange = [self rangeOfCharacterFromSet:searchSet];
    return characterRange.length != 0;
}
- (BOOL)containsString:(NSString *)searchString options:(unsigned int)mask
{
    return !searchString || [searchString length] == 0 || [self rangeOfString:searchString options:mask].length > 0;
}
- (BOOL)containsString:(NSString *)searchString
{
    return !searchString || [searchString length] == 0 || [self rangeOfString:searchString].length > 0;
}

@end

@implementation NSString (Algorithm)

- (NSString *)MD5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end

@implementation NSString (HTML)

- (NSString *)stringByStrippingHTML
{
    NSRange r;
    NSString *s = self;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}


- (NSString *)htmlEntityDecoding
{
    // 常用转义字符：http://114.xixik.com/character/
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:@"<",@"&lt;",
                                      @">",@"&gt;",
                                      @"\"",@"&quot;",
                                      @"&",@"&amp;",
                                      @" ",@"&nbsp;" ,nil];

    __block NSString * htmlStr = self;
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL *stop)
    {
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:key withString:obj];
    }];
    
    return htmlStr;
}


@end

@implementation NSString (URL)

- (NSString *)URLEncoding
{
    __autoreleasing NSString * result = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
    return result;
}

- (NSString *)URLDecoding
{
    NSString * __autoreleasing result = (__bridge NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8);
    return result;
}

- (NSDictionary *)queryDictionaryUsingEncoding:(NSStringEncoding)encoding
{
    // Copied and pasted from http://www.mail-archive.com/cocoa-dev@lists.apple.com/msg28175.html
    NSCharacterSet *delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary *pairs = [NSMutableDictionary dictionary];
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
    while (![scanner isAtEnd])
    {
        NSString *pairString;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray *kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2)
        {
            NSString *key = [[kvPair objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString *value = [[kvPair objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}

- (NSString *)stringByAddingQueryDictionary:(NSDictionary *)query
{
    NSMutableArray *pairs = [NSMutableArray array];
    [query enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        NSString *value = [query objectForKey:key];
        value = [value stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
        value = [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        NSString *pair = [NSString stringWithFormat:@"%@=%@", key, value];
        [pairs addObject:pair];
    }];
    
    NSString *params = [pairs componentsJoinedByString:@"&"];
    if ([self rangeOfString:@"?"].location == NSNotFound)
    {
        return [self stringByAppendingFormat:@"?%@", params];
    }
    else
    {
        return [self stringByAppendingFormat:@"&%@", params];
    }
}

// 是否有效邮箱
+ (BOOL)isValidEmail:(NSString *)email
{
    // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];

}
- (BOOL)isValidEmail
{
    // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

// 是否有效的HTTP
+ (BOOL)isValidHttpURL:(NSString *)httpurl
{
    NSString *urlRegEx =
    @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:httpurl];
}
- (BOOL)isValidHttpURL
{
    NSString *urlRegEx =
    @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:self];
}

+ (BOOL)isValidPhoneNumber:(NSString *)phoneNumber
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:phoneNumber] == YES)
        || ([regextestcm evaluateWithObject:phoneNumber] == YES)
        || ([regextestct evaluateWithObject:phoneNumber] == YES)
        || ([regextestcu evaluateWithObject:phoneNumber] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL)isValidPhoneNumber
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0125-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|77|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end

@implementation NSString (Version)

- (BOOL)isVersionEqualAndGreaterThan:(NSString *)version
{
    NSArray *currentSepArr = [self componentsSeparatedByString:@"."];
    NSArray *targetSepArr = [version componentsSeparatedByString:@"."];
    NSInteger maxIdx = [targetSepArr count] >= [currentSepArr count] ? [currentSepArr count] + 1: [currentSepArr count] + 1;
    
    BOOL flag = NO;
    for (NSInteger idx = 0 ;idx < maxIdx; idx++) {
        
        NSString *targetBit = nil;
        if (idx < [targetSepArr count]) {
            targetBit = [targetSepArr objectAtIndex:idx];
        }
        
        NSString *currentBit = nil;
        if (idx < [currentSepArr count]) {
            currentBit = [currentSepArr objectAtIndex:idx];
        }
        
        if (targetBit && currentBit) {
            if (targetBit.integerValue > currentBit.integerValue) {
                flag = NO;
                break;
            }
            else if (targetBit.integerValue < currentBit.integerValue)
            {
                flag = YES;
                break;
            }
            else
            {
                continue;
            }
        }
        else if (targetBit && !currentBit)
        {
            flag = NO;
            break;
        }
        else if (!targetBit && currentBit)
        {
            flag = YES;
            break;
        }
        else
        {
            //都没有的时候，是相等的
            flag = YES;
            break;
        }
    }
    return flag;
}

- (BOOL)isVersionEqualAndLessThan:(NSString *)version
{
    NSArray *targetSepArr = [version componentsSeparatedByString:@"."];
    NSArray *currentSepArr = [self componentsSeparatedByString:@"."];
    NSInteger maxIdx = [targetSepArr count] >= [currentSepArr count] ? [targetSepArr count] + 1: [currentSepArr count] + 1;
    
    BOOL flag = NO;
    for (NSInteger idx = 0 ;idx < maxIdx; idx++) {
        
        NSString *targetBit = nil;
        if (idx < [targetSepArr count]) {
            targetBit = [targetSepArr objectAtIndex:idx];
        }
        
        NSString *currentBit = nil;
        if (idx < [currentSepArr count]) {
            currentBit = [currentSepArr objectAtIndex:idx];
        }
        
        if (targetBit && currentBit) {
            if (targetBit.integerValue > currentBit.integerValue) {
                flag = YES;
                break;
            }
            else if (targetBit.integerValue < currentBit.integerValue)
            {
                flag = NO;
                break;
            }
            else
            {
                continue;
            }
        }
        else if (targetBit && !currentBit)
        {
            flag = YES;
            break;
        }
        else if (!targetBit && currentBit)
        {
            flag = NO;
            break;
        }
        else
        {
            flag = YES;
            break;
        }
    }
    return flag;
}

@end

@implementation NSString (NSData)

- (NSData*)data
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

@end

@implementation NSString(JSONCategories)

-(id)JSONValue
{

    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}
@end

