//
//  NSMutableArray+NullReplacement.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/5/28.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (NullReplacement)

/*
 * 对需检验的数组(包含项仅支持基础类型和NSString)进行单步校验，如果为Null或空值则进行相应的替换
 *
 * replacingArray是用于替换array的数组，每一替换项按顺序一一对应，其中int，float等基础类型在转入前须先转化为NSNumber
 */
- (instancetype)arrayByReplacingNullWithArray:(NSArray *)replacingArray;

@end
