//
//  GoodDoctorCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/7.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "GoodDoctorCell.h"
#import "ScoreLabel.h"
#import "UIImageView+WebCache.h"

#define CelldefaultHeight 85
#define CelldefaultWidth (kScreenWidth/2)
#define BottomLineTag 1000

@implementation GoodDoctorCell{
    UIImageView * icon;
    UILabel     * name;
    UILabel     * goodAtLabel;
    UILabel     * goodAt;
    UILabel     * goodCommentLabel;
    ScoreLabel  * goodComment;

}

+ (float)defaultHeight{
    return CelldefaultHeight;
}

+ (float)defaultWidth{
    return CelldefaultWidth;
    
}

+ (NSInteger)bottomLineTag{
    return BottomLineTag;
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
    //头像
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, (CelldefaultHeight - 52)/2, 52, 52)];
    icon.backgroundColor = [UIColor redColor];
    [self addSubview:icon];
     //刘渊 教授
    name = [[UILabel alloc] initWithFrame:CGRectMake(icon.maxX + 7, icon.frameY, CelldefaultWidth - (icon.maxX + 10), 15)];
    name.font = [UIFont systemFontOfSize:11];
    name.textColor = [UIColor blackColor];
    [self addSubview:name];
    //擅长
    goodAtLabel = [[UILabel alloc] initWithFrame:CGRectMake(name.frameX, name.maxY + 3.5, 29 , 15)];
    goodAtLabel.text = @"擅长:";
    goodAtLabel.textColor = [UIColor lightGrayColor];
    goodAtLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:goodAtLabel];
    //内科、外科
    goodAt = [[UILabel alloc] initWithFrame:CGRectMake(goodAtLabel.maxX + 2, goodAtLabel.frameY, CelldefaultWidth - (goodAtLabel.maxX + 2 + 2), goodAtLabel.frameHeight)];
    goodAt.textColor = [UIColor lightGrayColor];
    goodAt.font = [UIFont systemFontOfSize:11];
    [self addSubview:goodAt];
    //好评
    goodCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodAtLabel.frameX, goodAtLabel.maxY + 3.5, goodAtLabel.frameWidth, goodAtLabel.frameHeight)];
    goodCommentLabel.text = @"好评:";
    goodCommentLabel.textColor = [UIColor lightGrayColor];
    goodCommentLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:goodCommentLabel];
    //100分
    goodComment = [[ScoreLabel alloc] initWithFrame:CGRectMake(goodCommentLabel.maxX + 2, goodCommentLabel.frameY, [ScoreLabel defaultWidth], [ScoreLabel defaultHeight])];
    [self addSubview:goodComment];

}

- (void)setData:(Doctor *)data{
    _data = data;
    
    [self clearCach];
    
    [icon setImageWithURL:[NSURL URLWithString:_data.avatar]];
    
    NSString * string = [NSString stringWithFormat:@"%@ %@",_data.name,_data.levelDesc];
    NSMutableAttributedString * AtrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSInteger length = [_data.name length];
    
    if (length) {
        [AtrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, length)];
        [AtrStr addAttribute:NSForegroundColorAttributeName
                       value:kBlueTextColor
                       range:NSMakeRange(0, length)];
        name.attributedText = AtrStr;
    }
    
    goodAt.text = [NSString stringWithFormat:@"%@",_data.skillTreat];
    
    goodComment.text = [NSString stringWithFormat:@"%ld分",(long)_data.goodRemark];

}

- (void)clearCach{
    name.text = nil;
    goodAt.text = nil;
    goodComment.text = nil;
}

@end
