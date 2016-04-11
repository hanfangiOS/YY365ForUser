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

@protocol HFTitleViewDelegate <NSObject>

@optional
//重绘方法
- (void)redrawTitleView;

@end

@interface HFTitleView : UIView

@property (strong,nonatomic) UILabel * title;
@property (assign,nonatomic) BOOL      ifRedraw;//是否手动重绘 重绘需实现HFTitleViewDelegate中的redrawTitleView方法

- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame titleText:(NSString *)titleText;

- (instancetype)initWithFrame:(CGRect)frame titleText:(NSString *)titleText Style:(HFTitleViewStyle)style;

- (void)resetData;//刷新数据

@property (nonatomic, weak) id <HFTitleViewDelegate> delegate;

/*
 * HFTitleViewStyleDefault  -------- 标题 ---------
 */

@property (strong,nonatomic) UIImageView * leftLine;//左线
@property (strong,nonatomic) UIImageView * rightLine;//右线

/*
 * HFTitleViewStyleLoadMore  图片 标题            加载更多
 */

@property (strong,nonatomic) UIImageView * pic;//图片
@property (strong,nonatomic) UIButton * loadMoreBtn;//加载更多

@end




