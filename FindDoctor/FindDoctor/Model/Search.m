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
        self.Region = [[RegionOption alloc]init];
        self.Region.ID = 510000;
        self.Region.name = @"-1";
        self.SymptomID = -1;
    }
    return self;
}

@end