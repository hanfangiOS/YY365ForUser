//
//  Doctor.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/13.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, DoctorSortType) {
    DoctorSortTypeRate      = 1,  // 按评分
    DoctorSortTypeDistance  = 2,  // 按距离
    DoctorSortTypeAvailable = 3,  // 按可预约
    DoctorSortTypeNone      = 0
};

@interface Doctor : NSObject


@property                     NSInteger doctorId;//医生ID
@property (nonatomic, strong) NSString *name;//姓名
@property (nonatomic, strong) NSString *avatar;//头像图片
@property (nonatomic, strong) NSString *phoneNumber;//
@property (nonatomic, strong) NSString *city;//
@property (nonatomic, strong) NSString *area;//
@property (nonatomic, strong) NSString *address;//
@property (nonatomic, strong) NSString *desc;//
@property (nonatomic, strong) NSString *levelDesc;//
@property (nonatomic, strong) NSString *subject;//
@property (nonatomic, strong) NSString *availableTime;//
@property (nonatomic, strong) NSString *background;//
@property (nonatomic, strong) NSMutableArray *appointmentList;//
@property                     NSInteger appointmentSelectedIndex;//

@property                     NSInteger numDiag; //医生就诊次数
@property                     NSInteger numConcern; //医生被关注次数
@property                     NSInteger goodRemark; //医生好评率


@property (nonatomic, strong) NSString *skilledDisease;  // 擅长疾病
@property (nonatomic, strong) NSString *skilledSubject;  // 擅长科目

@property (nonatomic, assign)CLLocationDegrees latitude;  // 纬度
@property (nonatomic, assign)CLLocationDegrees longitude;  // 经度

@property BOOL isAvailable;
@property NSInteger doctorState; //0无人约诊 //1有人约诊 2约诊满 // -1为不可约诊
@property CGFloat rate;
@property double price;
@property NSInteger zhenLiaoAmount;
@property BOOL didConcern;

//@property NSInteger queueNumber;  // 已预约数量
//@property NSInteger queueCount;   // 可预约总数

- (NSString *)availableDesc;

@end

@interface DoctorAppointmentListItem : NSObject

@property (strong, nonatomic) NSString      *clinicAddr;//
@property (strong, nonatomic) NSString      *clinicName;//
@property                     NSInteger     fee;//
@property                     NSInteger     numOrder;//
@property                     NSInteger     numRelease;//
@property                     NSInteger     orderState;//
@property                     long long     releaseID;//
@property (strong, nonatomic) NSString      *releaseTime;//
@property                     NSInteger     time;//
@property (strong, nonatomic) NSMutableArray *selectOrderTimeArray;//

@end

@interface SelectOrderTime : NSObject

@property (strong, nonatomic) NSString      *house;//
@property                     NSInteger     isOrdered;//
@property                     NSInteger     orderID;//
@property (strong, nonatomic) NSString      *orderTime;//

@end

@interface DoctorFilter : NSObject

@property CGFloat longitude;
@property CGFloat latitude;
@property NSInteger level;
@property NSInteger typeId;
@property NSInteger subTypeId;
@property NSMutableArray *symptomOptionArray;
@property DoctorSortType sortType;
@property NSInteger classNumber;
@property (nonatomic, strong) NSString *orderDate;

@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *priceRange;

typedef NS_ENUM(NSInteger, MyDoctorSortType) {
    MyDoctorSortType1  = 1,
    MyDoctorSortType2  = 2,
};
@end

@interface MyDoctorFilter : NSObject

@property MyDoctorSortType sortType;

@end





