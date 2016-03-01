//
//  AddressDetailController.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/15.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUViewController.h"
#import "Address.h"

typedef void(^AddressAction)(Address *address);

typedef NS_ENUM(NSInteger, AddressEditType) {
    AddressEditTypeNone   = 0,  // 查看
    AddressEditTypeAdd    = 1,  // 添加
    AddressEditTypeModify = 2   // 修改
};

@interface AddressDetailController : CUViewController

@property (nonatomic, strong) Address *address;
@property (nonatomic, strong) Address *tempAddress;

@property AddressEditType editType;
@property (nonatomic, copy) AddressAction addBlock;
@property (nonatomic, copy) AddressAction deleteBlock;
@property (nonatomic, copy) AddressAction editBlock;

@end
