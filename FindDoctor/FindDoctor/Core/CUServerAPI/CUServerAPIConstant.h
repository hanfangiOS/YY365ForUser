//
//  CUServerAPIConstant.h
//  CollegeUnion
//
//  Created by li na on 15/2/26.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#ifndef CollegeUnion_CUServerAPIConstant_h
#define CollegeUnion_CUServerAPIConstant_h

#define CollegeUnion_Develop
//#define CollegeUnion_Distribution



// ------------------------ ERROR CODE ------------------------
#define ErrorCode_None 0

// ------------------------ COMMEN KEY ------------------------
#define Key_PageNum @"pageNum"
#define Key_PageSize @"pageSize"
#define Key_Search @"search"
#define Key_Token @"token"
#define Key_List @"list"

#define kPageSize 20

// ------------------------ URL ------------------------

/* 
 * Base URL
 */
#if defined(CollegeUnion_Develop)

// 李辉银
//#define URL_Base @"http://192.168.1.103:8080"

// 吴国庆
//#define URL_Base @"http://192.168.1.101:8888"

// 吴国庆
//#define URL_Base @"http://192.168.1.108:65534"

// 外网
#define URL_Base @"http://www.uyi365.com"

#elif defined(CollegeUnion_Distribution)

#define URL_Base @"http://www.uyi365.com"

#endif

#define URL_getCharge @"http://http://www.uyi365.com/baseFrame/base/getCharge.jmw"



/*
 * Business URL
 */

// { -----------图片相关

// 上传图片
#define URL_ImageUpload @"/baseFrame/base/FileUpload.jmv"
#define URL_ImageBase @"/baseFrame/base.jmv"
// }

// { -----------用户相关

// 获取手机验证码
#define URL_AfterBase @"/baseFrame/base/server.jmw"

// }

// -----------------------------------------------

/*
 * store file name
 */

#define Plist_User @"user"
#define Plist_AllCityServices @"AllCityServices"
#define Plist_CurrentCity @"CurrentCity"


#endif
