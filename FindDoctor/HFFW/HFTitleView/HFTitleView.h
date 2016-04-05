//
//  HFTitleView.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/4.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HFTitleViewStyle)
{
    HFTitleViewStyleDefault = 0,
    HFTitleViewStyleLoadMore = 1,
    HFTitleViewStyleNone = 2
};

@interface HFTitleView : UIView

@property (strong,nonatomic) UILabel * title;

- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame titleText:(NSString *)titleText;

- (instancetype)initWithFrame:(CGRect)frame titleText:(NSString *)titleText Style:(HFTitleViewStyle)style;

- (void)resetData;//刷新数据

- (void)redrawTitleView;//手动调整HFTitleView的UI

/*
 * HFTitleViewStyleLoadMore  图片 标题            加载更多
 */

typedef void(^LoadMoreAction)(void);//加载更多的Block

@property (strong,nonatomic) UIImageView * pic;//图片
@property (strong,nonatomic) UIButton * loadMoreBtn;//加载更多
@property (nonatomic, copy) LoadMoreAction loadMoreAction;//Block对象

- (void)setLoadMoreText:(NSString *)text;//设置加载更多文字

@end




