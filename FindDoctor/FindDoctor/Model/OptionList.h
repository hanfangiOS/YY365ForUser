//
//  OptionList.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/5/3.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OptionList : NSMutableDictionary

@end

//时间筛选条件
@interface DateOption : NSObject

@property (nonatomic) NSInteger ID;
@property (nonatomic, strong) NSString  *date;

@end

//地区筛选条件
@interface RegionOption : NSObject

@property (nonatomic) NSInteger ID;
@property (nonatomic, strong) NSString  *name;

@end

//病症子筛选条件
@interface SymptomSubOption : NSObject

@property (nonatomic) NSInteger ID;
@property (nonatomic, strong) NSString  *name;

@end


//病症筛选条件
@interface SymptomOption : NSObject

@property (nonatomic) NSInteger ID;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSMutableArray *symptomSubOptionArray;  //内部对象为SymptomSubOption

@end
