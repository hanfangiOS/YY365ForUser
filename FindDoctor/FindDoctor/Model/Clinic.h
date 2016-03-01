//
//  Clinic.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/2/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Clinic : NSObject

@property NSInteger ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSURL *icon;
@property (strong, nonatomic) NSString *doctorsString;
@property (strong, nonatomic) NSString *breifInfo;
@property (strong, nonatomic) NSString *detailIntro;
@property (strong, nonatomic) NSString *skillTreat;

@property (strong, nonatomic) NSMutableArray *doctorsArray;
@property NSInteger state;
@property double latitude;
@property double longitude;

@property NSInteger numDiag;
@property NSInteger numConcern;
@property NSInteger goodRemark;
@property BOOL isConcern;

@property (strong, nonatomic) NSString *phone;

@end

@interface ClinicFilter : NSObject

@property NSInteger regionID;
@property double longitude;
@property double latitude;

@end

typedef NS_ENUM(NSInteger, MyClinicSortType) {
    MyClinicSortType1  = 1,
    MyClinicSortType2  = 2,
};
@interface MyClinicFilter : NSObject

@property MyClinicSortType sortType;

@end
