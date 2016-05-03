//
//  CUService.m
//  CollegeUnion
//
//  Created by li na on 15/2/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUService.h"

@implementation CUService

- (instancetype)init
{
    if (self = [super init])
    {
        self.doctor = [[Doctor alloc] init];
        self.patience = [[CUUser alloc] init];
        self.disease = [[Disease alloc] init];
        self.diagnosis = [[Diagnosis alloc] init];
    }
    return self;
}
@end

@implementation MyDiagnosisRecordsFilter

@end