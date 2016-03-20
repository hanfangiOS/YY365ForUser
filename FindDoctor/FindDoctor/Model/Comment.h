//
//  Comment.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/3/14.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CUOrder.h"


//@interface Comment : NSObject
//
//@property (assign,nonatomic) NSInteger            score;//返回的点评积分（单次积分）
//@property (assign,nonatomic) NSTimeInterval       diagnosisTime;//就诊时间
//@property (strong,nonatomic) NSString           * doctorIcon;//医生头像
//@property (strong,nonatomic) NSString           * doctorName;//医生名
//@property (strong,nonatomic) NSString           * doctorTitle;//头衔
//@property (strong,nonatomic) NSString           * content;//点评内容
//@property (strong,nonatomic) NSString           * flagName;//锦旗名称
//@property (assign,nonatomic) NSInteger            numStar;//点评星级
//@property (assign,nonatomic) NSInteger            totalScore;//总分
//@property (assign,nonatomic) NSInteger            time;//点评时间
//
//@property (strong,nonatomic) NSString           * clinicAddress;//诊所地址
//@property (strong,nonatomic) NSString           * clinicName;//诊所名
//@property (strong,nonatomic) NSMutableArray     * flagList;//锦旗数据列表
////---------------------------------------------------------------------------------//
//@property (assign,nonatomic) NSInteger            averageStar;//星级  医生
//@property (strong,nonatomic) NSMutableArray     * remarkList;//锦旗数据列表
//@property (assign,nonatomic) NSInteger            totalConern;//总关注度
//@property (assign,nonatomic) NSInteger            totalDiagnosis;//总诊疗次数
//
//@end
//---------------------------------------------------------------------------------//
//锦旗数据列表
@interface FlagListInfo : NSObject

@property (assign,nonatomic) NSInteger                     ID;//锦旗ID
@property (strong,nonatomic) NSString                    * icon;//锦旗图标
@property (assign,nonatomic) NSInteger                      money;//锦旗给的钱
@property (strong,nonatomic) NSString                    * name;//锦旗名
@property (assign,nonatomic) NSInteger                     score;//（本次锦旗返回给医生的积分）
//---------------------------------------------------------------------------------//
@property (assign,nonatomic) NSInteger                     num;//锦旗数量

@end

//评论数据列表
@interface RemarkListInfo : NSObject

@property (strong,nonatomic) NSString                   * content;//评论内容
@property (strong,nonatomic) NSString                   * doctorName;//医生名
@property (strong,nonatomic) NSString                   * doctorTitle;//头衔
@property (strong,nonatomic) NSString                   * flagName;//锦旗名
@property (assign,nonatomic) NSInteger                    numStar;//评论星级
@property (assign,nonatomic) NSInteger                    time;//评论时间
@property (assign,nonatomic) NSInteger                    score;//
@property (strong,nonatomic) NSString                   * userName;//用户名
@property (assign,nonatomic) NSInteger                    flagID;//	锦旗ID
@property (assign,nonatomic) NSInteger                    num;//锦旗数量

@end


@interface CommentFilter : NSObject

@property (strong,nonatomic) CUOrder                    * order;
@property (strong,nonatomic) Doctor                     * doctor;
@property (strong,nonatomic) RemarkListInfo             * remarkListInfo;
@property (assign,nonatomic) NSInteger                    lastID;

@end



