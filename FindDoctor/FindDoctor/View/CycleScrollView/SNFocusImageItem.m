//
//  SNFocusImageItem.m
//  iCar
//
//  Created by yutao on 14-9-8.
//  Copyright (c) 2014年 yutao. All rights reserved.
//

#import "SNFocusImageItem.h"

@implementation SNFocusImageItem
- (id)initWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        self.title = title;
        self.imageUrlString = image;
        self.tag = tag;
    }
    
    return self;
}

@end
