//
//  SearchTooBar.h
//  HuiYangChe
//
//  Created by yutao on 14-9-22.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  SearchTooBarDelegate;

@interface SearchTooBar : UIView

@property (nonatomic, weak) id<SearchTooBarDelegate> delegate;
@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic) BOOL showCancelButton;

- (void)becomeFirstResponder;
- (void)resignFirstResponder;

@end

@protocol SearchTooBarDelegate <NSObject>

@optional
- (void)backClick;
- (void)cancelClick;
- (void)searchClickWithString:(NSString *)searchStr;
- (void)searchStringDidChange:(NSString *)searchStr;

@end