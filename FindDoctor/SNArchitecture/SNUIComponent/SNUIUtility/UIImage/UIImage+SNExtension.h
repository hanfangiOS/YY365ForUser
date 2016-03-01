//
//  UIImage+SNExtension.h
//  HuiYangChe
//
//  Created by li na on 14-9-14.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDataProtocol.h"

@interface UIImage (SNExtension)

@end

@interface UIImage (NSData) <NSDataProtocol>

- (NSData *)data;

@end