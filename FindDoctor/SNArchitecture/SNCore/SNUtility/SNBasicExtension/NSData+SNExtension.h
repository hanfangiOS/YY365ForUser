//
//  NSData+SNExtension.h
//  HuiYangChe
//
//  Created by li na on 14-9-14.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDataProtocol.h"
#import <UIKit/UIKit.h>

@interface NSData (SNExtension) <NSDataProtocol>

- (NSArray*)array;
- (NSDictionary*)dictionary;
- (UIImage*)image;
- (NSData*)data;
- (NSString*)UTF8String;

@end
