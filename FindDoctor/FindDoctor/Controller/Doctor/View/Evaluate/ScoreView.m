//
//  ScoreView.m
//  FindDoctor
//
//  Created by chai on 15/8/31.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "ScoreView.h"
#import "StarRatingView.h"

#define kDefaultScore 5.f

@interface ScoreView ()
{
    UILabel *_titleLabel;
    StarRatingView *_starView;
    UILabel *_scoreLabel;
    UIView *_lineView;
}

@end

@implementation ScoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    
    float title_width = kCommonDescFont.pointSize*4;
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = kDarkGrayColor;
    [self addSubview:_lineView];
    
    UIImage *starImage = [UIImage imageNamed:@"praise_grade_normal.png"];

    float title_height = 30.f;
    
    float start_y = (self.frame.size.height-title_height-starImage.size.height)/2.f;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = kCommonDescFont;
    _titleLabel.frame = CGRectMake((kScreenWidth-title_width)/2.f, start_y, title_width, title_height);
    _titleLabel.text = @"服务评分";
    _titleLabel.backgroundColor = kCommonBackgroundColor;
    _titleLabel.textColor = kGreenColor;
    [self addSubview:_titleLabel];
    
    float line_margin_left = 64.f;
    
    _lineView.frame = (CGRect){line_margin_left,CGRectGetMidY(_titleLabel.frame),kScreenWidth-line_margin_left*2.f,1.f};
    
    _scoreLabel = [[UILabel alloc] init];
    [self addSubview:_scoreLabel];
    
    float image_space = 3.f;
    int start_count = 5;
    
    CGRect scoreFrame = (CGRect){0,0,starImage.size.width*start_count+image_space*(start_count-1),starImage.size.height};
    
    
    NSString *scorelabelText = [NSString stringWithFormat:@"%0.1f",_score<=0?kDefaultScore:_score];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect numberRect = [scorelabelText boundingRectWithSize:CGSizeMake(100, 100)
                                                     options:NSStringDrawingUsesFontLeading
                                                  attributes:@{NSFontAttributeName:kScoreNumberFont,NSParagraphStyleAttributeName:paragraph}
                                                     context:nil];
    
    NSString *unitText = [NSString stringWithFormat:@"星"];
    
    CGRect unitRect = [unitText boundingRectWithSize:CGSizeMake(100, 100)
                                             options:NSStringDrawingUsesFontLeading
                                          attributes:@{NSFontAttributeName:kCommonDescFont,NSParagraphStyleAttributeName:paragraph}
                                             context:nil];
    
    float interval = 12.f;
    
    float start_x = (kScreenWidth-scoreFrame.size.width-numberRect.size.width-unitRect.size.width-interval)/2.f;
    float score_start_y = CGRectGetMaxY(_titleLabel.frame);
    
    scoreFrame.origin.x = start_x;
    scoreFrame.origin.y = score_start_y;
    
    _starView = [[StarRatingView alloc] initWithFrame:scoreFrame type:StarTypeLarge];
    _starView.editable = YES;
    _starView.rate = _score>0?_score:kDefaultScore;
    [self addSubview:_starView];
    
    _scoreLabel.frame = (CGRect){CGRectGetMaxX(scoreFrame)+interval,score_start_y-(kScoreNumberFont.lineHeight-kScoreNumberFont.pointSize)/2.f,unitRect.size.width+numberRect.size.width,kScoreNumberFont.lineHeight};
    
    NSMutableAttributedString *scoreAttText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",scorelabelText,unitText] attributes:@{NSForegroundColorAttributeName:kYellowColor,NSFontAttributeName:kScoreNumberFont}];
    [scoreAttText addAttributes:@{NSFontAttributeName:kCommonDescFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(scorelabelText.length, unitText.length)];
    
    _scoreLabel.attributedText = scoreAttText;

    
}

@end
