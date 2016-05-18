//
//  Banner.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/4.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFFilter.h"

typedef NS_ENUM (NSInteger,Type){
    WebType = 0,//跳网页
    DoctorType = 1,//跳医生详情
    ClinicType = 2//跳诊所详情
};

@interface Banner : NSObject

@property (assign,nonatomic) long long                    activityId;//活动id
@property (strong,nonatomic) NSString                   * imagePath;//Banner图路径
@property (assign,nonatomic) NSInteger                    redirectId;//跳转后需要
@property (assign,nonatomic) Type                         type;//跳转类型


@end

@interface BannerFilter : HFFilter

@end