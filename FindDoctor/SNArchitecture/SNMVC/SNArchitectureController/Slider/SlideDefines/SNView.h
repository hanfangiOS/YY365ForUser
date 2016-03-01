//
//  SNView.h
//  YiRen
//
//  Created by Nova on 13-8-12.
//  Copyright (c) 2013年. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SNViewDelegate <NSObject>

@optional
- (void)viewDidAddSubview:(UIView *)view;
- (void)viewDidBringSubviewToFront:(UIView *)view;

@end

@interface SNView : UIView
{
    BOOL suppressDelegate;
    id<SNViewDelegate> delegate;
}

@property (nonatomic, assign) id<SNViewDelegate> delegate;
@property (nonatomic, assign) BOOL suppressDelegate;

// 禁用delegate，防止死循环
- (void)suppressDelegateForAction:(void(^)(void))actionBlock;

@end