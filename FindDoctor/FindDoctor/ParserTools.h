//
//  ParserTools.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/3/23.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface ParserTools : NSObject

+ (void)enumerateObjects:(id)item UsingBlockSafety:(void (^)(id  _Nonnull obj, NSUInteger idx, BOOL *stop))block;

@end


NS_ASSUME_NONNULL_END