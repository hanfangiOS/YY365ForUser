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

#define CelldefaultHeight 85 * VFixRatio6
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
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(10 * HFixRatio6, (CelldefaultHeight - 52 * VFixRatio6)/2, 52 * HFixRatio6, 52 * VFixRatio6)];
    icon.backgroundColor = [UIColor redColor];
    [self addSubview:icon];
     //刘渊 教授
    name = [[UILabel alloc] initWithFrame:CGRectMake(icon.maxX + 10 * HFixRatio6, icon.frameY, CelldefaultWidth - (icon.maxX + 10 * HFixRatio6), 15 * VFixRatio6)];
    UIColorFromHex(Color_Hex_NavBackground);
    name.font = [UIFont systemFontOfSize:13];
    [self addSubview:name];
    //擅长
    goodAtLabel = [[UILabel alloc] initWithFrame:CGRectMake(name.frameX, name.maxY + 3.5 * VFixRatio6, 32 * HFixRatio6, 15 * VFixRatio6)];
    goodAtLabel.text = @"擅长:";
    goodAtLabel.textColor = [UIColor lightGrayColor];
    goodAtLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:goodAtLabel];
    //内科、外科
    goodAt = [[UILabel alloc] initWithFrame:CGRectMake(goodAtLabel.maxX + 10 * HFixRatio6, goodAtLabel.frameY, CelldefaultWidth - (goodAtLabel.maxX + 10 * HFixRatio6), goodAtLabel.frameHeight)];
    goodAt.textColor = [UIColor lightGrayColor];
    goodAt.font = [UIFont systemFontOfSize:13];
    [self addSubview:goodAt];
    //好评
    goodCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(goodAtLabel.frameX, goodAtLabel.maxY + 3.5 * VFixRatio6, goodAtLabel.frameWidth, goodAtLabel.frameHeight)];
    goodCommentLabel.text = @"好评:";
    goodCommentLabel.textColor = [UIColor lightGrayColor];
    goodCommentLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:goodCommentLabel];
    //100分
    goodComment = [[ScoreLabel alloc] initWithFrame:CGRectMake(goodCommentLabel.maxX + 10 * HFixRatio6, goodCommentLabel.frameY, CelldefaultWidth - (goodCommentLabel.maxX + 10 * HFixRatio6), goodCommentLabel.frameHeight)];
    [self addSubview:goodComment];

}

- (void)setData:(Doctor *)data{
    _data = data;
    
    [self clearCach];
    
    [icon setImageWithURL:[NSURL URLWithString:_data.avatar]];
    
    NSString * string = [NSString stringWithFormat:@"%@   %@",_data.name,_data.levelDesc];
    name.text = string;
    NSMutableAttributedString * AtrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSInteger length = [_data.name length];
    [AtrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, length)];
    [AtrStr addAttribute:NSForegroundColorAttributeName
                   value:[UIColor blackColor]
                   range:NSMakeRange(0, length)];
    
    goodAt.text = [NSString stringWithFormat:@"%@",_data.skillTreat];
    
    goodComment.text = [NSString stringWithFormat:@"%ld分",(long)_data.goodRemark];

}

- (void)clearCach{
    name.text = nil;
    goodAt.text = nil;
    goodComment.text = nil;
}

@end
