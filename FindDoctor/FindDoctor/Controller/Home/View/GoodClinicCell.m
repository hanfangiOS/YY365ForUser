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
    clinicIcon.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:clinicIcon];
    //诊所名字背景
    nameContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, CelldefaultHeight - 24 * VFixRatio6 * 2, CelldefaultWidth, 24 * VFixRatio6)];
    nameContainerView.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.4f];
    [clinicIcon addSubview:nameContainerView];
    //诊所名
    name = [[UILabel alloc] initWithFrame:nameContainerView.bounds];
    name.textColor = [UIColor whiteColor];
    name.textAlignment = NSTextAlignmentLeft;
    [nameContainerView addSubview:name];
    //小图标
    smallIcon = [[UIImageView alloc] initWithFrame:CGRectMake(4 * HFixRatio6, clinicIcon.maxY + 6 * VFixRatio6, 12 * HFixRatio6, 12 * VFixRatio6)];
    smallIcon.image = [UIImage imageNamed:@""];
    [self addSubview:smallIcon];
    //100分
    goodComment = [[ScoreLabel alloc] initWithFrame:CGRectMake(CelldefaultWidth - [ScoreLabel defaultWidth] - 2 * HFixRatio6,clinicIcon.maxY + 5 * VFixRatio6, [ScoreLabel defaultWidth], [ScoreLabel defaultHeight])];
    [self addSubview:goodComment];
    //内科、外科
    subject = [[UILabel alloc] initWithFrame:CGRectMake(smallIcon.maxX + 2 * HFixRatio6, smallIcon.frameY, CelldefaultWidth - (smallIcon.maxX + 2 * HFixRatio6 + [ScoreLabel defaultWidth] + 4 * HFixRatio6), smallIcon.frameHeight)];
    [self addSubview:subject];
    
    
}

- (void)setData:(Clinic *)data{
    _data = data;
    
    [self clearCach];
    
    [clinicIcon setImageWithURL:_data.icon];
    
    name.text = _data.name;
    name.backgroundColor = [UIColor blackColor];
    
    subject.text = _data.skillTreat;
    subject.backgroundColor = [UIColor blueColor];
    
    goodComment.text = [NSString stringWithFormat:@"%ld分",(long)_data.goodRemark];
    goodComment.backgroundColor = [UIColor purpleColor];
    
    smallIcon.backgroundColor = [UIColor greenColor];
    
}

- (void)clearCach{
    name.text = nil;
    subject.text = nil;
    goodComment.text = nil;
}


@end

