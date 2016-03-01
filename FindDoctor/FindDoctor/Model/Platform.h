//
//  Platform.h
//  EShiJia
//
//  Created by zhouzhenhua on 15/6/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Platform : NSObject <NSCoding>

@property (nonatomic, assign) NSInteger oldVersion;

- (void)setDefaultValue;

@end
