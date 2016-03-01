//
//  myAcount.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/23.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAccount : NSObject

@property double totalCost;
@property double totalIncome;
@property (nonatomic, strong) NSMutableArray *costDetailList;
@property (nonatomic, strong) NSMutableArray *incomeDetailList;

//@property

@end

@interface CostDetail : NSObject

@property NSTimeInterval timeStamp;
@property (nonatomic, strong) NSString *massage;
@property double fee;

@end

@interface IncomeDetail : NSObject

@property NSTimeInterval timeStamp;
@property (nonatomic, strong) NSString *massage;
@property double fee;

@end
