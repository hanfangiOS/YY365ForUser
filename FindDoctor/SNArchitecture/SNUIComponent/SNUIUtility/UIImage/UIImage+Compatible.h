//
//  UIImage+Compatible.h
//  SinaNews
//
//  Created by nova on 12-10-18.
//  Copyright (c) 2012年 sina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compatible)

+ (UIImage *)compatibleImageNamed:(NSString *)name;
+ (UIImage *)compatibleImageNamed:(NSString *)name andNameOf4Inch:(NSString *)nameOf4Inch;

+ (UIImage *)compatibleImageNamed:(NSString *)name shouldCache:(BOOL)cache;
+ (UIImage *)compatibleImageNamed:(NSString *)name andNameOf4Inch:(NSString *)nameOf4Inch shouldCache:(BOOL)cache;

@end
