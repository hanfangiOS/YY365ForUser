//
//  SNServerAPIDataParser.m
//  SNArchitecture
//
//  Created by li na on 15/2/17.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "SNServerAPIDataParser.h"

NSInteger ParserDataFormatErrorCode = 0;

NSString * const ParserDataFormatErrorMessage = @"数据错误";

@interface SNServerAPIDataParser ()

@end


@implementation SNServerAPIDataParser

SINGLETON_IMPLENTATION(SNServerAPIDataParser);

- (instancetype)init
{
    if (self = [super init])
    {
        self.hasError     = NO;
        self.errorCode    = ParserDataFormatErrorCode;
        self.errorMessage = ParserDataFormatErrorMessage;
    }
    return self;
}

- (NSError *)error
{
    _error = [[NSError alloc] initWithDomain:@"SNServerAPIDataParser" code:self.errorCode userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.errorMessage,NSLocalizedDescriptionKey,nil]];
    return _error;
}

@end
