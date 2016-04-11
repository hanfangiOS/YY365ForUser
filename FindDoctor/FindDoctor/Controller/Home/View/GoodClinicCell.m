//
//  GoodClinicCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/7.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "GoodClinicCell.h"
#import "ScoreLabel.h"
#import "UIImageView+WebCache.h"

#define CelldefaultHeight 105 * VFixRatio6
#define CelldefaultWidth ((kScreenWidth - 30 * HFixRatio6)/2)

@implementation GoodClinicCell{
    UIImageView     * clinicIcon;
    UIView          * nameContainerView;
    UILabel         * name;
    UIImageView     * smallIcon;
    UILabel         * subject;
    UILabel         * goodCommentLabel;
    ScoreLabel      * goodComment;
}

+ (float)defaultHeight{
    return CelldefaultHeight;
}

+ (float)defaultWidth{
    return CelldefaultWidth;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    //诊所照片
    clinicIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CelldefaultWidth, CelldefaultHeight - 24 * VFixRatio6)];
    [self addSubview:clinicIcon];
    //诊所名字背景
    nameContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, CelldefaultHeight - 24 * VFixRatio6 * 2, CelldefaultWidth, 24 * VFixRatio6)];
//    nameContainerView.ba
    [clinicIcon addSubview:nameContainerView];
    //诊所名
    name = [[UILabel alloc] initWithFrame:nameContainerView.bounds];
    name.textColor = [UIColor whiteColor];
    name.textAlignment = NSTextAlignmentLeft;
    [nameContainerView addSubview:name];
    //小图标
    
    //内科、外科

    //100分
    
}

- (void)setData:(Clinic *)data{
    _data = data;
    
    [self clearCach];
    
    
}

- (void)clearCach{
    name.text = nil;
    subject.text = nil;
    goodComment.text = nil;
}


@end

