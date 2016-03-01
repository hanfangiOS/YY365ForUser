//
//  HYCAnnotation.h
//  HuiYangChe
//
//  Created by zhouzhenhua on 14-12-13.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMKPointAnnotation.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

#define kAnnotationImageNor     @"map_icon_location"
#define kAnnotationImageSel     @"map_icon_location_highlighted"

@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;

@end

@interface TapLocationAnnotation : BMKPointAnnotation

@end

@interface UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end
