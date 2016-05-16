//
//  DetailsHeaderView.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/18.
//  Copyright © 2016年 li na. All rights reserved.
//

#define DetailsHeaderViewHeight 88

#import "DetailsHeaderView.h"
#import "UIImageView+WebCache.h"

@interface DetailsHeaderView()

@property (strong,nonatomic)UIImageView * icon;
@property (strong,nonatomic)UILabel     * name;
@property (strong,nonatomic)UILabel     * brief;
@property (strong,nonatomic)UIImageView * arrow;

@end

@implementation DetailsHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        return self;
    }
    return nil;
}

+ (float)defaultHeight{
    
    return DetailsHeaderViewHeight;
}

- (void)setDefaultValue{
    self.name.text = @"－－";
    self.brief.text = @"－－";
}

- (void)initSubViews{
    //头像
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(9, (DetailsHeaderViewHeight - 60)/2, 60, 60)];
    self.icon.layer.cornerRadius = 5.0f;
    [self addSubview:self.icon];
    //朱军 教授 主治医师
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.maxX + 8, self.icon.frameX + 10, kScreenWidth - self.icon.maxX - 8 - 50, 16)];
    self.name.font = [UIFont systemFontOfSize:12];
    self.name.textColor = kBlueTextColor;
    [self addSubview:self.name];
    //箭头
    self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 9 - 4, (DetailsHeaderViewHeight - 15)/2, 9, 15)];
    self.arrow.image = [UIImage imageNamed:@"common_icon_grayArrow@2x"];
    [self addSubview:self.arrow];
    //
    self.brief = [[UILabel alloc] initWithFrame:CGRectMake(self.name.frameX, self.name.maxY + 6, kScreenWidth - self.name.frameX - self.arrow.frameWidth - 30, 30)];
    self.brief.font = [UIFont systemFontOfSize:10];
    self.brief.textColor = kGrayTextColor;
    self.brief.numberOfLines = 2;
    [self addSubview:self.brief];
    
    //上线
    UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    topLine.backgroundColor = kblueLineColor;
    [self addSubview:topLine];
    
    //下线
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frameHeight - 1, kScreenWidth, 1)];
    topLine.backgroundColor = kblueLineColor;
    [self addSubview:bottomLine];
    
    [self setDefaultValue];
}

- (void)setData:(Doctor *)data{
    _data = data;
    
    [self.icon setImageWithURL:[NSURL URLWithString:_data.avatar] placeholderImage:[UIImage imageNamed:@"temp_icon_doctor"]];
    
    if (_data.name && _data.levelDesc && _data.grade) {
        NSString * string = [NSString stringWithFormat:@"%@ %@ %@",_data.name,_data.levelDesc,_data.grade];
        NSMutableAttributedString * AtrStr = [[NSMutableAttributedString alloc] initWithString:string];
        NSInteger length = [_data.name length];
        [AtrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, length)];
        [AtrStr addAttribute:NSForegroundColorAttributeName
                       value:[UIColor blackColor]
                       range:NSMakeRange(0, length)];
        self.name.attributedText = AtrStr;
    }
    
    if (_data.skillTreat) {
        self.brief.text = [NSString stringWithFormat:@"%@",_data.skillTreat];
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self.brief.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.firstLineHeadIndent = 0;
        paragraphStyle.lineSpacing = 6;
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
        self.brief.attributedText = attributedString;
    }

}


@end
