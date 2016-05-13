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

#define CelldefaultHeight 105
#define CelldefaultWidth ((kScreenWidth - 30)/2)

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

- (void)setDefaultValue{
    goodComment.text = @"100分";
    name.text = @"－－";
    subject.text = @"－－";
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
    clinicIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CelldefaultWidth, CelldefaultHeight - 24)];
    [self addSubview:clinicIcon];
    //诊所名字背景
    nameContainerView = [[UIView alloc] initWithFrame:CGRectMake(1, CelldefaultHeight - 24 * 2, CelldefaultWidth - 1, 24)];
    nameContainerView.backgroundColor = [UIColor colorWithRed:138/255 green:138/255 blue:138/255 alpha:0.54];
    [clinicIcon addSubview:nameContainerView];
    //诊所名
    name = [[UILabel alloc] initWithFrame:CGRectMake(6, 0, nameContainerView.frameWidth, nameContainerView.frameHeight)];
    name.textColor = [UIColor whiteColor];
    name.textAlignment = NSTextAlignmentLeft;
    name.font = [UIFont systemFontOfSize:11];
    [nameContainerView addSubview:name];
    //小图标
    smallIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8, clinicIcon.maxY + 7, 10, 10)];
    smallIcon.image = [UIImage imageNamed:@"main_icon_clinicGoodAt@2x"];
    [self addSubview:smallIcon];
    //100分
    goodComment = [[ScoreLabel alloc] initWithFrame:CGRectMake(CelldefaultWidth - [ScoreLabel defaultWidth] - 2,clinicIcon.maxY + 4, [ScoreLabel defaultWidth], [ScoreLabel defaultHeight])];
    [self addSubview:goodComment];
    //内科、外科
    subject = [[UILabel alloc] initWithFrame:CGRectMake(smallIcon.maxX + 2, smallIcon.frameY, CelldefaultWidth - (smallIcon.maxX + 2 + [ScoreLabel defaultWidth] + 4), smallIcon.frameHeight)];
    subject.font = [UIFont systemFontOfSize:10];
    subject.textColor = kGrayTextColor;
    [self addSubview:subject];
    
    [self setDefaultValue];
}

- (void)setData:(Clinic *)data{
    _data = data;
    
    [clinicIcon setImageWithURL:[NSURL URLWithString: _data.icon] placeholderImage:[UIImage imageNamed:@"temp_goodClinic"]];
    
    if (_data.name) {
        name.text = _data.name;
    }
    
    if (_data.skillTreat) {
        subject.text = _data.skillTreat;
    }
    
    if (_data.goodRemark) {
        goodComment.text = [NSString stringWithFormat:@"%ld分",(long)_data.goodRemark];
    }
}


@end

