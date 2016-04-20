//
//  Doctor.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/13.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class FlagListInfo;
@class RemarkListInfo;


typedef NS_ENUM(NSInteger, DoctorSortType) {
    DoctorSortTypeRate      = 1,  // 按评分
    DoctorSortTypeDistance  = 2,  // 按距离
    DoctorSortTypeAvailable = 3,  // 按可预约
    DoctorSortTypeNone      = 0
};

@interface Doctor : NSObject


@property  long long                    doctorId;//医生ID
@property (nonatomic, strong) NSString *name;//姓名
@property (nonatomic, strong) NSString *avatar;//头像图片
@property (nonatomic, strong) NSString *phoneNumber;//

@property (nonatomic, strong) NSString *address;//医生就诊地址
@property (nonatomic, strong) NSString *clinicName;//就诊诊所名
@property (nonatomic, assign) NSInteger diagnosisTime;//就诊时间
@property (nonatomic, strong) NSString *levelDesc;//医生头衔， 如教授、主任等
@property (nonatomic, strong) NSString *subject;//医生诊疗科目
@property (nonatomic, strong) NSString *availableTime;//

@property (nonatomic, strong) NSMutableArray *appointmentList;//
@property                     NSInteger appointmentSelectedIndex;//

@property                     NSInteger numDiag; //医生就诊次数
@property                     NSInteger numConcern; //医生被关注次数
@property                     NSInteger goodRemark; //医生好评率

@property (nonatomic, strong) NSString *briefIntro;// 简介
@property (nonatomic, strong) NSString *skillTreat;  // 擅长科目

@property (nonatomic, strong) NSString *detailIntro;  // 详细介绍

@property (nonatomic, assign)CLLocationDegrees latitude;  // 纬度
@property (nonatomic, assign)CLLocationDegrees longitude;  // 经度

//@property BOOL isAvailable;
@property NSInteger doctorState; //0无人约诊 //1有人约诊 2约诊满 // -1为不可约诊

@property NSInteger price; // 诊疗价格，以分为单位
@property BOOL didConcern; //是否被关注

//@property NSInteger queueNumber;  // 已预约数量
//@property NSInteger queueCount;   // 可预约总数
@property CGFloat rate; //评星， 预留接口
@property                     NSInteger score; //积分
//@property (nonatomic, strong) NSString *city;//预留， 暂时不用


@property (nonatomic, strong) NSMutableArray        * flagList;//锦旗列表
@property (nonatomic, strong) NSMutableArray        * remarkList;//评论列表

@end

@interface DoctorAppointmentListItem : NSObject

@property (strong, nonatomic) NSString      *clinicAddr;// 诊疗点地理位置
@property (strong, nonatomic) NSString      *clinicName;// 诊疗点名称
@property                     NSInteger     fee;//         医生放此号的诊疗价格
@property                     NSInteger     numOrder;//    放号数量
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





