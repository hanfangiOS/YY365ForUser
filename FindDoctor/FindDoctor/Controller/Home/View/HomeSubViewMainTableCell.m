//
//  HomeSubViewMainTableCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/6.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "HomeSubViewMainTableCell.h"
#import "ScoreLabel.h"
#import "UIImageView+WebCache.h"

#define  kCellHeight     120.0

@implementation HomeSubViewMainTableCell{
    UIImageView * icon;
    UILabel     * name;
    UILabel     * briefLabel;
    UILabel     * brief;
    UILabel     * goodAtLabel;
    UILabel     * goodAt;
    ScoreLabel  * score;
    UIView      * bottomLine;
}

+ (CGFloat)defaultHeight
{
    return kCellHeight;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    //头像
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(10 * HFixRatio6, 16 * VFixRatio6, 53 * VFixRatio6, 53 * HFixRatio6)];
    [self addSubview:icon];
    
    //评分
    score = [[ScoreLabel alloc] initWithFrame:CGRectMake(kScreenWidth - 12 * HFixRatio6 - [ScoreLabel defaultWidth], 15 * VFixRatio6, [ScoreLabel defaultWidth], [ScoreLabel defaultHeight])];
    //刘渊 教授
    name = [[UILabel alloc] init];
    name.font = [UIFont systemFontOfSize:14];
    name.textAlignment = NSTextAlignmentLeft;
    name.textColor = UIColorFromHex(Color_Hex_NavBackground);
    name.frame = CGRectMake(icon.maxX + 12 * HFixRatio6, icon.frameX, 30 * HFixRatio6, 15 * VFixRatio6);
    //简介
    briefLabel = [[UILabel alloc] initWithFrame:CGRectMake(name.frameX, name.maxX + 10 * VFixRatio6, 35 * HFixRatio6, 13 * VFixRatio6)];
    briefLabel.text = @"简介：";
    briefLabel.textAlignment = NSTextAlignmentLeft;
    briefLabel.textColor = kLightGrayColor;
    //中西医结合XXXXX
    brief = [[UILabel alloc] initWithFrame:CGRectMake(briefLabel.maxX + 5 * HFixRatio6, briefLabel.frameY, kScreenWidth - briefLabel.maxX - 10 * HFixRatio6, 25 * VFixRatio6)];
    brief.numberOfLines = 2;
    brief.textColor = kLightGrayColor;
    brief.textAlignment = NSTextAlignmentLeft;
    //擅长
    goodAtLabel = [[UILabel alloc] initWithFrame:CGRectMake(briefLabel.frameX, briefLabel.maxY + 25 * VFixRatio6, briefLabel.frameWidth, briefLabel.frameHeight)];
    goodAtLabel.text = @"擅长；";
    goodAtLabel.textAlignment = NSTextAlignmentLeft;
    goodAtLabel.textColor = kLightGrayColor;
    //擅长内儿科治疗XXXX
    goodAt = [[UILabel alloc] initWithFrame:CGRectMake(goodAtLabel.maxX + 5 * HFixRatio6, goodAtLabel.frameY, kScreenWidth - goodAtLabel.maxX - 10 * HFixRatio6, 25 * VFixRatio6)];
    goodAt.numberOfLines = 2;
    goodAt.textColor = kLightGrayColor;
    goodAt.textAlignment = NSTextAlignmentLeft;
    
    bottomLine = [[UIView alloc] initWithFrame:CGRectMake(10 * HFixRatio6, kCellHeight - 0.5 * VFixRatio6, kScreenWidth - 2 * 5 * HFixRatio6, 0.5 * VFixRatio6)];
    bottomLine.backgroundColor = kLightLineColor;
}

- (void)setData:(Doctor *)data{
    
    [icon setImageWithURL:[NSURL URLWithString:_data.avatar]];
    
    NSString * string = [NSString stringWithFormat:@"%@ %@",_data.name,_data.levelDesc];
    name.text = string;
    NSMutableAttributedString * AtrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSInteger length = [_data.name length];
    [AtrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, length)];
    [AtrStr addAttribute:NSForegroundColorAttributeName
                   value:[UIColor blackColor]
                       range:NSMakeRange(0, length)];
    score.text = [NSString stringWithFormat:@"%ld分",(long)_data.goodRemark];
    
    brief.text = _data.briefIntro;
    
    goodAt.text = _data.skillTreat;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
