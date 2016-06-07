//
//  HFModelVerify.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/5/26.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFModelVerify : NSObject

/*
 * 对数组进行单步校验(包含项仅支持基础类型和NSString)，如果含有Null或空值，返回NO
 *
 * array是被校验的数组
 */
+ (BOOL)VerifyWithArray:(NSArray *)array;

@end
