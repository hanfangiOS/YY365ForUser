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
    self.icon = icon;
    [self addSubview:self.icon];
    
    UILabel * label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:17];
    self.label = label;
    [self addSubview:self.label];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.icon.frame = CGRectMake(12, 12, 28, 22);
    
    CGSize size = [self sizeForString:self.label.text font:self.label.font limitSize:CGSizeMake(self.frameWidth - (40 + 15 + 25), 0)];
    self.label.frame = CGRectMake(self.icon.maxX + 15, self.icon.frameY, size.width, size.height);
}

- (void)setData:(TipMessageData *)data{
    _data = data;
    
    self.label.text = _data.title;
    if (_data.type == 0) {
        self.icon.image = [UIImage imageNamed:@""];
        self.icon.backgroundColor = [UIColor redColor];
    }
    if (_data.type == 1) {
        self.icon.image = [UIImage imageNamed:@""];
        self.icon.backgroundColor = [UIColor blueColor];
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
