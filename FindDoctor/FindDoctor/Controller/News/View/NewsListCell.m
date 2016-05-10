//
//  NewsListCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/13.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "NewsListCell.h"

@interface NewsListCell()

@property (weak,nonatomic)UIImageView   * icon;
@property (weak,nonatomic)UILabel       * label;
@property (weak,nonatomic)UIView        * topLine;
@property (weak,nonatomic)UIView        * bottomLine;

@end

@implementation NewsListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        return self;
    }
    return nil;
}

- (void)initSubViews{
    
    UIImageView * icon = [[UIImageView alloc] init];
    icon.contentMode = UIViewContentModeScaleAspectFill;
    self.icon = icon;
    [self addSubview:self.icon];
    
    UILabel * label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:16];
    self.label = label;
    [self addSubview:self.label];
    //上线
    UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    topLine.backgroundColor = kblueLineColor;
    self.topLine = topLine;
    [self addSubview:self.topLine];
    //下线
    UIView * bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = kblueLineColor;
    self.bottomLine = bottomLine;
    [self addSubview:self.bottomLine];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.icon.frame = CGRectMake(15, 15, 15, 16);
    
    CGSize size = [self sizeForString:self.label.text font:self.label.font limitSize:CGSizeMake(self.frameWidth - (15 + 15 + 16 + 24), 0)];
    self.label.frame = CGRectMake(self.icon.maxX + 16, self.icon.frameY, size.width, size.height);
    
    self.bottomLine.frame = CGRectMake(0, (size.height + 15 + 15) - 1, kScreenWidth, 1);
}


- (void)setData:(TipMessageData *)data{
    _data = data;
    
    self.label.text = _data.title;
    if (_data.type == 0) {
        self.icon.image = [UIImage imageNamed:@"msg_icon_trumpet"];
    }
    if (_data.type == 1) {
        self.icon.image = [UIImage imageNamed:@"msg_icon_bell"];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (CGSize)sizeForString:(NSString *)string font:(UIFont *)font limitSize:(CGSize)limitSize{
    
    CGFloat width = limitSize.width;
    CGFloat height = limitSize.height;
    if (!width) {
        width = CGFLOAT_MAX;
    }
    if (!height) {
        height = CGFLOAT_MAX;
    }
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, height)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    
    return rect.size;
}

@end
