//
//  SNUISystemConstant.h
//  CollegeUnion
//
//  Created by li na on 15/3/3.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#ifndef CollegeUnion_SNUISystemConstant_h
#define CollegeUnion_SNUISystemConstant_h

// 系统版本号枚举
#define IOS_2_0 @"2.0"
#define IOS_3_0 @"3.0"
#define IOS_4_0 @"4.0"
#define IOS_5_0 @"5.0"
#define IOS_6_0 @"6.0"
#define IOS_7_0 @"7.0"
#define IOS_8_0 @"8.0"


//#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_7_0) (0)


// detect current system version upon v
// >=
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
// >
#define SYSTEM_VERSION_GREATER_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
// ==
#define SYSTEM_VERSION_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)


#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define GreaterThanIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ([[UIScreen mainScreen] currentMode].size.height > 960) : NO)


#define Simulator ([[[UIDevice currentDevice] name] hasSuffix:@"Simulator"] ? YES : NO)

#define kScreenWidth             ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight            ([UIScreen mainScreen].bounds.size.height)

#endif
