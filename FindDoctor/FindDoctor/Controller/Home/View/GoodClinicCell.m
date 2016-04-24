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
//    clinicIcon.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:clinicIcon];
    //诊所名字背景
    nameContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, CelldefaultHeight - 24 * 2, CelldefaultWidth, 24)];
    nameContainerView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2f];
    [clinicIcon addSubview:nameContainerView];
    //诊所名
    name = [[UILabel alloc] initWithFrame:CGRectMake(6, 0, nameContainerView.frameWidth, nameContainerView.frameHeight)];
    name.textColor = [UIColor whiteColor];
    name.textAlignment = NSTextAlignmentLeft;
    name.font = [UIFont systemFontOfSize:14];
    [nameContainerView addSubview:name];
    //小图标
    smallIcon = [[UIImageView alloc] initWithFrame:CGRectMake(4, clinicIcon.maxY + 6, 12, 12)];
    smallIcon.image = [UIImage imageNamed:@""];
    [self addSubview:smallIcon];
    //100分
    goodComment = [[ScoreLabel alloc] initWithFrame:CGRectMake(CelldefaultWidth - [ScoreLabel defaultWidth] - 2,clinicIcon.maxY + 5, [ScoreLabel defaultWidth], [ScoreLabel defaultHeight])];
    [self addSubview:goodComment];
    //内科、外科
    subject = [[UILabel alloc] initWithFrame:CGRectMake(smallIcon.maxX + 2, smallIcon.frameY, CelldefaultWidth - (smallIcon.maxX + 2 + [ScoreLabel defaultWidth] + 4), smallIcon.frameHeight)];
    subject.font = [UIFont systemFontOfSize:11];
    [self addSubview:subject];
    
    
}

- (void)setData:(Clinic *)data{
    _data = data;
    
    [self clearCach];
    
    [clinicIcon setImageWithURL:[NSURL URLWithString: _data.icon]];
    
    name.text = _data.name;
    
    subject.text = _data.skillTreat;
    
    goodComment.text = [NSString stringWithFormat:@"%ld分",(long)_data.goodRemark];
    
    smallIcon.backgroundColor = [UIColor greenColor];
    
}

- (void)clearCach{
    name.text = nil;
    subject.text = nil;
    goodComment.text = nil;
}


@end
