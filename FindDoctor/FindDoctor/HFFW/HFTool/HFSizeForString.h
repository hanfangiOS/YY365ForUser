//
//  HFSizeForString.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/5/28.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFSizeForString : NSObject

- (float)heightForString:(NSString *)string font:(UIFont *)font limitWidth:(float)limitWidth;

- (float)heightForString:(NSString *)string attributes:(NSDictionary *)attributes limitWidth:(float)limitWidth;

- (float)widthForString:(NSString *)string font:(UIFont *)font limitHeight:(float)limitHeight;

- (float)widthForString:(NSString *)string attributes:(NSDictionary *)attributes limitHeight:(float)limitHeight;

- (CGSize)sizeForString:(NSString *)string font:(UIFont *)font limitSize:(CGSize)limitSize;

- (CGSize)sizeForString:(NSString *)string attributes:(NSDictionary *)attributes limitSize:(CGSize)limitSize;

@end
