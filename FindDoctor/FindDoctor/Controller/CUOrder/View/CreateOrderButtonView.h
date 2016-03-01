//
//  CreateOrderButtonView.h
//  EShiJia
//
//  Created by zhouzhenhua on 15-4-19.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickAction)(void);

@interface CreateOrderButtonView : UIView

@property (nonatomic, copy) ClickAction onClickAction;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *amountTitle;
@property (nonatomic, strong) UIFont *amountFont;

@property (nonatomic) double amount;
@property (nonatomic) BOOL showAmount;
@property (nonatomic) BOOL enable;

+ (float)defaultHeight;

@end
