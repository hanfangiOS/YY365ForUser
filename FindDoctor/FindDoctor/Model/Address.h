//
//  Address.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/15.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject

@property (nonatomic, strong) NSString *addressId;

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *cellPhone;

@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *area;

@property (nonatomic, strong) NSString *address;

@end
