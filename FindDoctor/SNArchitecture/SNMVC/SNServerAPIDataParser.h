//
//  SNServerAPIDataParser.h
//  SNArchitecture
//
//  Created by li na on 15/2/17.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNSingleton.h"

@interface SNServerAPIDataParser : NSObject

//@property (nonatomic,readwrite,assign) BOOL        hasError;
//@property (nonatomic,readonly,assign) NSInteger   errorCode;
//@property (nonatomic,readonly,strong) NSString  *  errorMessage;
//@property (nonatomic,readonly,strong) NSError   *  error;

@property (nonatomic,readwrite,assign) BOOL hasError;
@property (nonatomic,readwrite,assign) NSInteger errorCode;
@property (nonatomic,readwrite,strong) NSString * errorMessage;
@property (nonatomic,readwrite,strong) NSError * error;

SINGLETON_DECLARE(SNServerAPIDataParser);

@end
