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

@interface HomeModel : NSObject

@property (strong, nonatomic) NSString * promotionInfo;//诊所活动推广信息
@property (assign, nonatomic) NSTimeInterval * activityTime;//活动时间
@property (nonatomic, strong) NSMutableArray * mainBannerList;//
@property (nonatomic, strong) NSMutableArray * subjectList;//
@property (nonatomic, strong) NSMutableArray * adverBannerList;//

@property (nonatomic, strong) NSMutableArray * goodDoctorList;//
@property (nonatomic, strong) NSMutableArray * goodClinicList;//
@property (nonatomic, strong) NSMutableArray * famousDoctorList;//

@end


@interface HomeSubViewController_Main : CUViewController

@property (nonatomic, strong) HomeModel * homeModel;

@end


