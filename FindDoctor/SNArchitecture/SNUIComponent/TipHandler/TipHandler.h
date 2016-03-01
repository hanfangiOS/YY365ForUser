//
//  TipHandler.h
//  YiRen
//
//  Created by  on 12-7-23.
//  Copyright (c) 2012年. All rights reserved.
//  跟业务逻辑相关，viewcontroller调用

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TipStateSuccess,
    TipStateFail,
} TipState;

@interface TipHandler : NSObject

+ (void)showNetWorkFailedOnlyTextWithResponseStatus:(NSInteger)responseStatus;

+ (void)showDataErrorTextOnly;

+ (void)showNewWorkNotReachable;

+ (void)showTipOnlyTextWithNsstring:(NSString*)string;
+ (void)showTipOnlyTextWithNsstring:(NSString*)string andShowTime:(CGFloat)time;

+ (void)showSmallStringTipWithText:(NSString *)text;

+ (void)showTipTextWithNsstring:(NSString*)string state:(TipState)state;

@end
