
//  CUServerAPIConstant.h
//  CollegeUnion
//
//  Created by li na on 15/2/26.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#ifndef CollegeUnion_CUServerAPIConstant_h
#define CollegeUnion_CUServerAPIConstant_h

//#define CollegeUnion_Distribution
#define CollegeUnion_Develop



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


//#define URL_Base @"http://192.168.1.101:8888"//
#define URL_Base @"http://192.168.1.123:8080"//威
//#define URL_Base @"http://192.168.1.115:8080"//银
//#define URL_Base @"http://192.168.0.210:8080"//军


#elif defined(CollegeUnion_Distribution)

#define URL_Base @"http://www.uyi365.com"


#endif
/*
 * Business URL
 */

// { -----------图片相关

// 上传图片
#define URL_ImageUpload @"/baseFrame/base/FileUpload.jmv"
#define URL_ImageBase @"/baseFrame/base.jmv"
// }

// { -----------用户相关

#if defined(CollegeUnion_Develop)

#define URL_AfterBase @"/baseFrame/base/server.jmm"
//#define kGetChargeUrl @"http://www.uyi365.com/baseFrame/base/getCharge.jmm" // 你的服务端创建并返回 charge 的 URL 地址

#define kGetChargeUrl  @"http://192.168.1.101:8888/baseFrame/base/PayDiagnosisOK.jmm"


#define kVerifyOrderStateUrl @"/baseFrame/base/verify_order_state.jmm"

#elif defined(CollegeUnion_Distribution)

#define URL_AfterBase @"/baseFrame/base/server.jmw"
#define kGetChargeUrl @"http://www.uyi365.com/baseFrame/base/getCharge.jmw" // 你的服务端创建并返回 charge 的 URL 地址

#define kVerifyOrderStateUrl @"/baseFrame/base/verify_order_state.jmw"

#endif

// }

// -----------------------------------------------

/*
 * store file name
 */

#define Plist_User @"user"
#define Plist_AllCityServices @"AllCityServices"
#define Plist_CurrentCity @"CurrentCity"


#endif
