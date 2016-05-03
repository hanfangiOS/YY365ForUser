//
//  HomeSubViewController_Main.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/4.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "CUViewController.h"
#import "Doctor.h"
#import "Clinic.h"
#import "HomeViewController.h"

@interface HomeModel : NSObject

@property (strong, nonatomic) NSString * promotionInfo;//诊所活动推广信息
@property (assign, nonatomic) NSTimeInterval * activityTime;//活动时间
@property (nonatomic, strong) NSMutableArray * mainBannerList;//主轮播图
@property (nonatomic, strong) NSMutableArray * subjectList;//科室列表
@property (nonatomic, strong) NSMutableArray * secondBannerList;//副轮播图

@property (nonatomic, strong) NSMutableArray * goodDoctorList;//好评医生
@property (nonatomic, strong) NSMutableArray * goodClinicList;//好评诊所
@property (nonatomic, strong) NSMutableArray * famousDoctorList;//优医馆

@end


@interface HomeSubViewController_Main : CUViewController

@property (nonatomic, strong) HomeModel * homeModel;

@property(strong,nonatomic)HomeViewController * homeViewController;

@end


