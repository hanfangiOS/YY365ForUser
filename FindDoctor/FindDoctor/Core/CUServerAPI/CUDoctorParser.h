//
//  CUDoctorParser.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/13.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUServerAPIDataBaseParser.h"

@interface CUDoctorParser : CUServerAPIDataBaseParser

- (id)parseDoctorListWithDict:(NSDictionary *)dict;
- (id)parseDoctorDetailWithDict:(NSDictionary *)dict;

/***
 *
 *  !@brief 转化为subobject model
 *
 *
 ***/
- (id)parseSubObjectListWithDict:(NSDictionary *)dict;

/***
 *
 *  !brief 转化为医生的口碑对象
 *
 ****/
//- (id)parsePraise

@end
