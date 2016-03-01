//
//  ListMoneyView.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/23.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAccount.h"

@interface ListMoneyView : UIView <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) MyAccount *data;

@property (nonatomic, strong)  UITableView *costTableView;
@property (nonatomic, strong) UITableView *incomeTableView;

@property (nonatomic, strong) UIScrollView *contenScrollView;
- (void)costButtonAction;
- (void)incomeButtonAction;

@end
