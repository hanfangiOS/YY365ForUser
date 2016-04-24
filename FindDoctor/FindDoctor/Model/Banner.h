//
//  Banner.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/4.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFFilter.h"

@interface Banner : NSObject

@property (assign,nonatomic) long long                    activityId;//活动id
@property (strong,nonatomic) NSString                   * imagePath;//Banner图路径
@property (strong,nonatomic) NSString                   * type;//跳转类型
@property (assign,nonatomic) NSInteger                    redirectId;//跳转后需要

@end

@interface BannerFilter : HFFilter

@end