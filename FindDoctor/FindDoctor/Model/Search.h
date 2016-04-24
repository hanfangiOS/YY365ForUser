//
//  Search.h
//  FindDoctor
//
//  Created by zhuhaoran on 16/3/2.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Search : NSObject

@property (nonatomic, strong) NSString * brief;//医生（诊所）简介
@property (nonatomic, assign) NSInteger  dataID;//数据ID，doctorID,clinicID
@property (nonatomic, assign) NSInteger  dataType;//数据类型，6-医生，7-诊所
@property (nonatomic, strong) NSString * icon;//头像
@property (nonatomic, strong) NSString * name;//名称
@property (nonatomic, assign) NSInteger  numDiag;//就诊次数
@property (nonatomic, assign) NSInteger  orderState;//0无人约诊 //1有人约诊 2约诊满 // -1为不可约诊
@property (nonatomic, assign) NSString * skill;//医生（诊所）擅长技能
@property (nonatomic, assign) NSInteger  time;//不为0表示医生放号的最早时间，排序用
@property (nonatomic, assign) NSString * title;//头衔

@end



@interface SearchFilter : HFFilter

@property (nonatomic, strong) NSString * keyword;//搜索内容

@end