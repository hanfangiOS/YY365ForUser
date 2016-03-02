//
//  Diagnosis.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/3/2.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CUHerb : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *herbid;
@property (nonatomic, copy) NSString *herbFirstLetter;
@property (nonatomic, assign) NSInteger weight;

@end


@interface Diagnosis : NSObject

@property (nonatomic, strong) NSString *diagnosisText;
@property (nonatomic, strong) NSString *herbPic;
@property (nonatomic, strong) NSMutableArray *herbArray;  //对象为CUHerb
@property (nonatomic, assign) NSInteger recipeNum;

@end
