//
//  DoctorPraise.h
//  FindDoctor
//
//  Created by chai on 15/8/30.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoctorPraise : NSObject

@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSDictionary *page_info;
@property (nonatomic, assign) float rate;
@property (nonatomic, assign) int flag_count;
@property (nonatomic, assign) int zan_count;
@property (nonatomic, assign) int patience_count;

@end
