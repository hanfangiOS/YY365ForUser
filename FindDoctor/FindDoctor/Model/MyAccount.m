//
//  myAcount.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/23.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "MyAccount.h"

@implementation MyAccount

- (instancetype)init{
    self = [super init];
    if (self) {
        self.costDetailList = [NSMutableArray new];
        self.incomeDetailList = [NSMutableArray new];
    }
    return self;
}

@end

@implementation CostDetail

@end

@implementation IncomeDetail

@end



