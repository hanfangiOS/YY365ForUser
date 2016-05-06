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
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16, 53, 53)];
    [self addSubview:icon];
    
    //评分
    score = [[ScoreLabel alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - [ScoreLabel defaultWidth], 15, [ScoreLabel defaultWidth], [ScoreLabel defaultHeight])];
    [self addSubview:score];
    //刘渊 教授
    name = [[UILabel alloc] init];
    name.font = [UIFont systemFontOfSize:11];
    name.textAlignment = NSTextAlignmentLeft;
    name.textColor = kBlueTextColor;
    name.frame = CGRectMake(icon.maxX + 12, icon.frameY, 160, 15 );
    [self addSubview:name];
    //简介
    briefLabel = [[UILabel alloc] initWithFrame:CGRectMake(name.frameX, name.maxY + 9, 40, 15)];
    briefLabel.text = @"简介:";
    briefLabel.textAlignment = NSTextAlignmentLeft;
    briefLabel.font = [UIFont systemFontOfSize:11];
    briefLabel.textColor = kGrayTextColor;
    [self addSubview:briefLabel];
    //中西医结合XXXXX
    brief = [[UILabel alloc] initWithFrame:CGRectMake(briefLabel.maxX + 2, briefLabel.frameY - 0.5, kScreenWidth - briefLabel.maxX - 10, 28)];
    brief.numberOfLines = 2;
    brief.textColor = kGrayTextColor;
    brief.textAlignment = NSTextAlignmentLeft;
    brief.font = [UIFont systemFontOfSize:11];
    [self addSubview:brief];
    //擅长
    goodAtLabel = [[UILabel alloc] initWithFrame:CGRectMake(briefLabel.frameX, briefLabel.maxY + 22, briefLabel.frameWidth, briefLabel.frameHeight)];
    goodAtLabel.text = @"擅长:";
    goodAtLabel.textAlignment = NSTextAlignmentLeft;
    goodAtLabel.font = [UIFont systemFontOfSize:11];
    goodAtLabel.textColor = kGrayTextColor;
    [self addSubview:goodAtLabel];
    //擅长内儿科治疗XXXX
    goodAt = [[UILabel alloc] initWithFrame:CGRectMake(goodAtLabel.maxX + 2, goodAtLabel.frameY - 0.5, kScreenWidth - goodAtLabel.maxX - 10, 28)];
    goodAt.numberOfLines = 2;
    goodAt.textColor = kGrayTextColor;
    goodAt.textAlignment = NSTextAlignmentLeft;
    goodAt.font = [UIFont systemFontOfSize:11];
    [self addSubview:goodAt];
    
    bottomLine = [[UIView alloc] initWithFrame:CGRectMake(10, kCellHeight - 1, kScreenWidth - 2 * 5, 1)];
    bottomLine.backgroundColor = kblueLineColor;
    [self addSubview:bottomLine];
}

- (void)setData:(Doctor *)data{
    
    _data = data;
    
    [icon setImageWithURL:[NSURL URLWithString:_data.avatar]];
    
    NSString * string = [NSString stringWithFormat:@"%@ %@ %@",_data.name,_data.levelDesc,_data.grade];
    
    NSMutableAttributedString * AtrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSInteger length = [_data.name length];
    if (length) {
        [AtrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, length)];
        [AtrStr addAttribute:NSForegroundColorAttributeName
                       value:[UIColor blackColor]
                       range:NSMakeRange(0, length)];
        
        name.attributedText = AtrStr;
    }
    
    score.text = [NSString stringWithFormat:@"%ld分",(long)_data.goodRemark];
    
    brief.text = _data.briefIntro;
    
    goodAt.text = _data.skillTreat;
    
    icon.backgroundColor = [UIColor yellowColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
