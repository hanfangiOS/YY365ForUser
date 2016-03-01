//
//  SNFocusImageItem.h
//  iCar
//
//  Created by yutao on 14-9-8.
//  Copyright (c) 2014年 yutao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNFocusImageItem : NSObject
/**图片描述**/
@property (nonatomic, strong)  NSString     *title;
/**图片地址**/
@property (nonatomic, strong)  NSString     *imageUrlString;
/**图片标记**/
@property (nonatomic, assign)  NSInteger    tag;

- (id)initWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag;
@end
