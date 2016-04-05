//
//  Clinic.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/2/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Clinic : NSObject

@property NSInteger ID;
@property (strong, nonatomic) NSString *name;//名字
@property (strong, nonatomic) NSString *address;//就诊地址
@property (strong, nonatomic) NSURL    *icon;//图片
@property (strong, nonatomic) NSString *doctorsString;//地图页面显示的诊所医生字符串
@property (strong, nonatomic) NSString *breifInfo;//简介
@property (strong, nonatomic) NSString *detailIntro;//详细介绍
@property (strong, nonatomic) NSString *skillTreat;//擅长科目

@property (strong, nonatomic) NSMutableArray *doctorsArray;//诊所详情页面用到的医生，对象为Doctor
@property NSInteger state;
@property double latitude;
@property double longitude;

@property NSInteger numDiag;//就诊次数
@property NSInteger numConcern;//被关注次数
@property NSInteger goodRemark;//好评率
@property BOOL isConcern;

@property (strong, nonatomic) NSString *phone;

@end

@interface ClinicFilter : NSObject

@property NSInteger regionID;
@property double longitude;
@property double latitude;

@end

typedef NS_ENUM(NSInteger, MyClinicSortType) {
    MyClinicSortType1  = 1,
    MyClinicSortType2  = 2,
};
@interface MyClinicFilter : NSObject

@property MyClinicSortType sortType;

@end
