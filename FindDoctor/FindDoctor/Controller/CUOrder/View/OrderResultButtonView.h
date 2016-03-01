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

@property (nonatomic, copy) ResultButtonAction checkAction;
@property (nonatomic, copy) ResultButtonAction backAction;

+ (float)defaultHeight;

@end
