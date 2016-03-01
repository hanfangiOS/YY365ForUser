//
//  NSDateFormatter+SNExtension.h
//  SNArchitecture
//
//  功能描述：避免多次创建dataFormatter引起性能问题，将所有fromatter保存在一个字典里，以format为Key

#import <Foundation/Foundation.h>

@interface NSDateFormatter (SNExtension)

+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format;

// @"yyyy-MM"
+ (NSString *)dateWithoutDayFormatString;

// @"yyyy-MM-dd"
+ (NSString *)dateFormatString;

// @"HH:mm:ss"
+ (NSString *)timeFormatString;

// @"HH:mm"
+ (NSString *)timeWithoutSecondFormatString;

//@"yyyy-MM-dd HH:mm:ss"
+ (NSString *)timestampFormatString;

//@"yyyy-MM-dd HH:mm"
+ (NSString *)timestampWithoutSecondFormatString;

@end
