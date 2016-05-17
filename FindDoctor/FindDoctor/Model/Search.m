//
//  Search.m
//  FindDoctor
//
//  Created by zhuhaoran on 16/3/2.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "Search.h"

//@implementation Search
//
//@end

@implementation SearchFilter

- (instancetype)init{
    self = [super init];
    if (self) {
        self.keyword = @"-1";
        self.date = @"-1";
        self.region = [[RegionOption alloc]init];
        self.region.ID = 510000;
        self.region.name = @"-1";
        self.symptomID = -1;
    }
    return self;
}

@end