//
//  NSDateFormatter+SNExtension.m
//  SNArchitecture
//


#import "NSDateFormatter+SNExtension.h"
#import "SNSingleton.h"

static NSMutableDictionary * formatters = nil;

//@interface SNFormatterDictionary : NSMutableDictionary
//
////SINGLETON_DECLARE(SNFormatterDictionary);
//+ (SNFormatterDictionary *)sharedInstance;
//
//@end
//
//@implementation SNFormatterDictionary
//
//+ (SNFormatterDictionary *)sharedInstance
//{
//    static SNFormatterDictionary *sharedInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedInstance = [[SNFormatterDictionary alloc] init];
//    });
//    
//    return sharedInstance;
//}
//
//
////SINGLETON_IMPLENTATION(SNFormatterDictionary);
//
//
//@end

@implementation NSDateFormatter (SNExtension)

+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format
{
//    SNFormatterDictionary * formatterDic = [SNFormatterDictionary sharedInstance];
    NSMutableDictionary * formatterDic = [self formatters];
    NSDateFormatter * formatter = [formatterDic objectForKey:format];
    if (nil == formatter && format != nil)
    {
        NSDateFormatter * temp = [[NSDateFormatter alloc] init];
        [temp setDateFormat:format];
        [formatterDic setObject:temp forKey:format];
        
        formatter = [formatterDic objectForKey:format];
    }
    
    return formatter;

}

// @"yyyy-MM"
+ (NSString *)dateWithoutDayFormatString
{
    return @"yyyy-MM";
}

+ (NSString *)dateFormatString {
	return @"yyyy-MM-dd";
}

+ (NSString *)timeFormatString {
	return @"HH:mm:ss";
}

+ (NSString *)timeWithoutSecondFormatString
{
    return @"HH:mm";
}

+ (NSString *)timestampFormatString {
	return @"yyyy-MM-dd HH:mm:ss";
}

+ (NSString *)timestampWithoutSecondFormatString
{
    return @"yyyy-MM-dd HH:mm";
}

+ (NSMutableDictionary *)formatters
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!formatters)
        {
            formatters = [[NSMutableDictionary alloc] init];
        }
    });
    
    return formatters;
}

@end



