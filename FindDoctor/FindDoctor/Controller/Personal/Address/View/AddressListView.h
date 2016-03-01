//
//  AddressListView.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/17.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Address.h"

typedef void(^AddressDeleteAction)(NSInteger index);

@interface AddressListView : UIView

@property (nonatomic, copy) CUCommomButtonAction addBlock;
@property (nonatomic, copy) AddressDeleteAction deleteBlock;

+ (CGFloat)defaultHeight;

- (void)reloadData:(NSArray *)dataArray;

@end
