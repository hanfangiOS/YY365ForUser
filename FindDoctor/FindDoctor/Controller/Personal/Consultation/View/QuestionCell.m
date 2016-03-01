//
//  QuestionCell.m
//  FindDoctor
//
//  Created by chai on 15/9/15.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "QuestionCell.h"

#define kButtonHeight 40.f

@interface QuestionCell ()
{
    UIButton *_showMore;
    UILabel *_questionLabel;
}
@end

@implementation QuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createSubViews
{
    _questionLabel = [[UILabel alloc] init];
    _questionLabel.textColor = kBlackColor;
    _questionLabel.numberOfLines = 0;
    _questionLabel.font = SystemFont_12;
    [self.contentView addSubview:_questionLabel];
    
    _showMore = [UIButton buttonWithType:UIButtonTypeCustom];
    _showMore.titleLabel.font = SystemFont_12;
    [_showMore setTitleColor:kBlueColor forState:UIControlStateNormal];
    [self.contentView addSubview:_showMore];
}

- (void)setQuestion:(NSString *)questionText
{
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    
    float margin_x = 10;
    float margin_y = 10;
    
    CGSize questionSize = [questionText boundingRectWithSize:CGSizeMake(kScreenWidth-margin_x*2, MAXFLOAT)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:SystemFont_12,NSParagraphStyleAttributeName:paragraph}
                                                     context:nil].size;
    _questionLabel.frame = (CGRect){margin_x,margin_y,questionSize};
    _questionLabel.text  = questionText;
    
    _showMore.frame = (CGRect){0,CGRectGetMaxY(_questionLabel.frame)+margin_y,kScreenWidth,kButtonHeight};
    [_showMore setTitle:@"查看更多" forState:UIControlStateNormal];
}

+ (float)contentHeight:(NSString *)questionText
{
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    
    float margin_x = 10;
    float margin_y = 10;
    
    CGSize questionSize = [questionText boundingRectWithSize:CGSizeMake(kScreenWidth-margin_x*2, MAXFLOAT)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:SystemFont_12,NSParagraphStyleAttributeName:paragraph}
                                                     context:nil].size;
    return questionSize.height+margin_y*2+kButtonHeight;
}


@end
