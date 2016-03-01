//
//  SNListEmptyView.h
//  CollegeUnion
//
//  Created by li na on 15/6/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SNListEmptyViewDelegate <NSObject>

- (void)emptyViewClicked;

@end

@interface SNListEmptyView : UIView

@property (nonatomic,strong) UIImageView * imgView;
@property (nonatomic,strong) UILabel * textLabel;
@property (nonatomic,assign) id<SNListEmptyViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

@end
