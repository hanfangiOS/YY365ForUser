//
//  DoctorPraiseHeaderView.m
//  FindDoctor
//
//  Created by chai on 15/8/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "DoctorPraiseHeaderView.h"
#import "NSString+SNExtension.h"
#import "DoctorFlagView.h"
#import "DoctorZanView.h"

#define kDefaultScore 5.f

@interface DoctorPraiseHeaderView ()
{
    UIView *_scoreView;
    UILabel *_scoreLabel;
    UILabel *_statLabel;
    DoctorFlagView *_flagView;
    DoctorZanView *_zanView;
    
    UIImageView *_zanSignView;
    
    UILabel *_zanTotalLabel;
    
    UILabel *_totalLabel;
    
    UILabel *_praiseLabel;
}

@end

@implementation DoctorPraiseHeaderView

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
    self.backgroundColor = UIColorFromRGB(242, 251, 251);
    
//    _scoreView = [self gradeViewWithScore:5.0];
//    [self addSubview:_scoreView];
//    
//    _scoreLabel = [[UILabel alloc] init];
//    [self addSubview:_scoreLabel];
    
//    [self scoreFrameManager];
    
//    _statLabel = [[UILabel alloc] init];
//    _statLabel.textAlignment = NSTextAlignmentCenter;
//    _statLabel.font = kCommonDescFont;
//    [self addSubview:_statLabel];
//    _statLabel.frame = CGRectMake(0, CGRectGetMaxY(_scoreView.frame), kScreenWidth, 30);

    float padding_top = 10.f;
    float interval_y = 5.f;
    
    UIImage *zanSignImage = [UIImage imageNamed:@"praise_zan_sign"];
    
    _zanSignView = [[UIImageView alloc] init];
    _zanSignView.frame = (CGRect){(kScreenWidth-zanSignImage.size.width)/2.f,padding_top,zanSignImage.size};
    _zanSignView.image = zanSignImage;
    [self addSubview:_zanSignView];
    
    float total_label_height = SystemFont_22.lineHeight;
    
    _zanTotalLabel = [[UILabel alloc] init];
    _zanTotalLabel.frame = (CGRect){0,CGRectGetMaxY(_zanSignView.frame)+interval_y,kScreenWidth,total_label_height};
    _zanTotalLabel.textAlignment = NSTextAlignmentCenter;
    _zanTotalLabel.textColor = kLightGrayColor;
    _zanTotalLabel.font = SystemFont_14;
    [self addSubview:_zanTotalLabel];
    
    NSString *zanText = @"获取张三、李四等150人点赞";
    
    NSString *regularRegex = @"[0-9]+";
    
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regularRegex options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *results = [regular matchesInString:zanText options:0 range:NSMakeRange(0, zanText.length)];
    
    NSMutableAttributedString *zanAttributedStr = [[NSMutableAttributedString alloc] initWithString:zanText];
    
    for (int i=0; i<results.count; i++) {
        NSTextCheckingResult *result = results[i];
        [zanAttributedStr addAttributes:@{NSFontAttributeName:SystemFont_22,NSForegroundColorAttributeName:kOrangeColor} range:result.range];
    }
    
    _zanTotalLabel.attributedText = zanAttributedStr;
    
    _totalLabel = [[UILabel alloc] init];
    _totalLabel.frame = (CGRect){0,CGRectGetMaxY(_zanTotalLabel.frame)+interval_y,kScreenWidth,SystemFont_14.lineHeight};
    _totalLabel.textAlignment = NSTextAlignmentCenter;
    _totalLabel.textColor = kLightGrayColor;
    _totalLabel.text = @"优医就诊100人500次";
    _totalLabel.font = SystemFont_14;
    [self addSubview:_totalLabel];
    
    NSString *praiseText = @"积分10000    4.3分";
    
    _praiseLabel = [[UILabel alloc] init];
    _praiseLabel.frame = (CGRect){0,CGRectGetMaxY(_totalLabel.frame)+interval_y,kScreenWidth,SystemFont_22.lineHeight};
    _praiseLabel.textAlignment = NSTextAlignmentCenter;
    _praiseLabel.textColor = kLightGrayColor;
    _praiseLabel.font = SystemFont_14;
    [self addSubview:_praiseLabel];
    
    NSArray *praiseResults = [regular matchesInString:praiseText options:0 range:NSMakeRange(0, praiseText.length)];
    
    NSMutableAttributedString *praiseAttributedStr = [[NSMutableAttributedString alloc] initWithString:praiseText];
    
    for (int i=0; i<praiseResults.count; i++) {
        NSTextCheckingResult *result = praiseResults[i];
        [praiseAttributedStr addAttributes:@{NSFontAttributeName:SystemFont_22,NSForegroundColorAttributeName:kOrangeColor} range:result.range];
    }
    
    _praiseLabel.attributedText = praiseAttributedStr;
    
    _flagView = [[DoctorFlagView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_praiseLabel.frame)+interval_y, kScreenWidth, 160)];
    _flagView.editable = NO;
    [self addSubview:_flagView];
    
//    _zanView = [[DoctorZanView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_flagView.frame), kScreenWidth, 110)];
//    [self addSubview:_zanView];
}

- (void)setDoctor:(Doctor *)doctor
{
    _doctor = doctor;
    [self scoreFrameManager];
    
    _statLabel.text = [NSString stringWithFormat:@"汉方就诊%d人，%d张锦旗，%d个赞",1000,2000,3000];
}

//整合分数
- (void)scoreFrameManager
{
    [self scoreViewReload];
    
    CGRect scoreFrame = _scoreView.frame;
    
    NSString *scorelabelText = [NSString stringWithFormat:@"%0.1f",_doctor==nil?kDefaultScore:_doctor.rate];
    
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
    float start_y = 10;
    
    scoreFrame.origin.x = start_x;
    scoreFrame.origin.y = start_y;
    _scoreView.frame = scoreFrame;
    
    _scoreLabel.frame = (CGRect){CGRectGetMaxX(scoreFrame)+interval,start_y-(kScoreNumberFont.lineHeight-kScoreNumberFont.pointSize)/2.f,unitRect.size.width+numberRect.size.width,kScoreNumberFont.lineHeight};
    
    NSMutableAttributedString *scoreAttText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",scorelabelText,unitText] attributes:@{NSForegroundColorAttributeName:kYellowColor,NSFontAttributeName:kScoreNumberFont}];
    [scoreAttText addAttributes:@{NSFontAttributeName:kCommonDescFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(scorelabelText.length, unitText.length)];
    
    _scoreLabel.attributedText = scoreAttText;
}

//显示星星
- (UIView *)gradeViewWithScore:(float)score
{
    if (_scoreView == nil) {
        _scoreView = [[UIView alloc] init];
    }
    
    [_scoreView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImage *lightStarImage = [UIImage imageNamed:@"praise_grade_highlighted"];
    UIImage *normalStarImage = [UIImage imageNamed:@"praise_grade_normal"];
    
    float star_width = lightStarImage.size.width;
    float star_height = lightStarImage.size.height;
    
    NSInteger maxStar = 5;
    
    NSString *numberFormat = [NSString stringWithFormat:@"%0.1f",kDefaultScore];
    
    NSInteger lightStar = [[self decimalWithFormat:numberFormat floatValue:score] integerValue];
    
    for (int i=0; i<maxStar; i++) {
        UIImageView *starView = [[UIImageView alloc] init];
        starView.frame = CGRectMake(i*star_width, 0, star_width, star_height);
        if (i<lightStar) {
            starView.image = lightStarImage;
        }else{
            starView.image = normalStarImage;
        }
        [_scoreView addSubview:starView];
    }
    _scoreView.frame = CGRectMake(0, 0, lightStarImage.size.width*maxStar, lightStarImage.size.height);
    return _scoreView;
}

- (void)scoreViewReload
{
    _scoreView = [self gradeViewWithScore:_doctor.rate];
    if ([self.subviews containsObject:_scoreView]) {
        [_scoreView removeFromSuperview];
        [self addSubview:_scoreView];
    }
}

/***
 *
 *  !@浮点型四舍五入
 *
 ***/
- (NSString *)decimalWithFormat:(NSString *)format floatValue:(float)floatValue
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:format];
    return [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatValue]];
}

@end
