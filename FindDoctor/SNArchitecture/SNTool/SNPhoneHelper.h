//
//  PhoneHelper.h
//  HuiYangChe
//
//  Created by zhouzhenhua on 14-11-3.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNPhoneHelper : NSObject

+ (void)call:(NSString *)phone;
+ (void)sms:(NSString *)phone;



@end
