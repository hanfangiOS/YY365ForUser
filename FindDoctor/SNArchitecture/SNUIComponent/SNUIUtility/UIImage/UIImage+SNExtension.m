//
//  UIImage+SNExtension.m
//  HuiYangChe
//
//  Created by li na on 14-9-14.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import "UIImage+SNExtension.h"

@implementation UIImage (SNExtension)

@end

@implementation UIImage (NSData)

- (NSData *)data
{
     NSData* data = UIImageJPEGRepresentation(self, (CGFloat)1.0);
    return data;
}

@end
