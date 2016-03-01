//
//  SNServerAPIResultData.h
//  SNArchitecture
//
//  Created by li na on 15/2/17.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    SNServerAPIErrorType_None = 0,
    SNServerAPIErrorType_NetWorkFailure,
    SNServerAPIErrorType_DataError
    
}SNServerAPIErrorType;



@interface SNServerAPIResultData : NSObject

@property (nonatomic,strong) NSDictionary * responseObject;// 是json，没有经过程序解析成为model
//@property (nonatomic,strong) SNBaseModel *
@property (nonatomic,strong) id parsedModelObject;// 解析成为model集合的object

@property (nonatomic,strong) NSError * error;// 解析产生的错误会赋值给他进行排错,网络错误也会赋值

@property (nonatomic,assign) BOOL hasError; // 有错误

@property (nonatomic,assign) SNServerAPIErrorType errorType;

@end
