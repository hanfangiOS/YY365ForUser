//
//  OrderResultButtonView.h
//  CommentTest
//
//  Created by zhouzhenhua on 14-9-15.
//  Copyright (c) 2014年 zhouzhenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ResultButtonAction)(void);

@interface OrderResultButtonView : UIView

@property (nonatomic, copy) ResultButtonAction leftAction;
@property (nonatomic, copy) ResultButtonAction rightAction;

@property (nonatomic, strong) UIButton     *leftButton;
@property (nonatomic, strong) UIButton     *rightButton;

+ (float)defaultHeight;

@end
