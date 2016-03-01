//
//  DoctorEvaluateController.m
//  FindDoctor
//
//  Created by chai on 15/8/31.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "DoctorEvaluateController.h"
#import "ScoreView.h"
#import "DoctorFlagView.h"

@interface DoctorEvaluateController ()
{
    UIButton *_zanButton;
    ScoreView *_serveScoreView;
    ScoreView *_treatScoreView;
    DoctorFlagView *_flagView;
    UIScrollView *_baseView;
    
    UIView *_lineView;
    UILabel *_titleLabel;
    UITextView *_commentView;
    
    UIButton *_submitbutton;
}

@end

@implementation DoctorEvaluateController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

- (void)loadContentView
{
    self.title = @"点评XXX医生";
    self.contentView.backgroundColor = kCommonBackgroundColor;
    
    float width = 40.f*kScreenRatio;
    
    _baseView = [[UIScrollView alloc] init];
    _baseView.frame = self.contentView.bounds;
    [self.contentView addSubview:_baseView];
    
    _zanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _zanButton.frame = CGRectMake((kScreenWidth-width)/2.f, 20*kScreenRatio, width, width);
    [_zanButton setImage:[UIImage imageNamed:@"comment_zan_button.png"] forState:UIControlStateNormal];
    _zanButton.layer.cornerRadius = width/2.f;
    _zanButton.layer.masksToBounds = YES;
    [_baseView addSubview:_zanButton];
    
    float score_height = 80.f;
    
    _serveScoreView = [[ScoreView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_zanButton.frame), kScreenWidth, score_height)];
    _serveScoreView.backgroundColor = kCommonBackgroundColor;
    [_baseView addSubview:_serveScoreView];
    
    _treatScoreView = [[ScoreView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_serveScoreView.frame), kScreenWidth, score_height)];
    _treatScoreView.backgroundColor = kCommonBackgroundColor;
    [_baseView addSubview:_treatScoreView];
    
    float flag_height = 160.f;
    
    _flagView = [[DoctorFlagView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_treatScoreView.frame), kScreenWidth, flag_height)];
    _flagView.editable = YES;
    [_baseView addSubview:_flagView];
    
    float title_width = kCommonDescFont.pointSize*11;
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = kDarkGrayColor;
    [_baseView addSubview:_lineView];
    
    float title_height = 40.f;
    
    float start_y = CGRectGetMaxY(_flagView.frame);
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = kCommonDescFont;
    _titleLabel.frame = CGRectMake((kScreenWidth-title_width)/2.f, start_y, title_width, title_height);
    _titleLabel.text = @"点评内容（十个字以上）";
    _titleLabel.backgroundColor = kCommonBackgroundColor;
    _titleLabel.textColor = kGreenColor;
    [_baseView addSubview:_titleLabel];
    
    float line_margin_left = 34.f;
    
    _lineView.frame = (CGRect){line_margin_left,CGRectGetMidY(_titleLabel.frame),kScreenWidth-line_margin_left*2.f,1.f};
    
    _commentView = [[UITextView alloc] init];
    _commentView.frame = CGRectMake(line_margin_left, CGRectGetMaxY(_titleLabel.frame), kScreenWidth-line_margin_left*2, 90*kScreenRatio);
    _commentView.backgroundColor = [UIColor whiteColor];
    _commentView.layer.cornerRadius = 6;
    _commentView.layer.masksToBounds = YES;
    _commentView.layer.borderWidth = 1.f;
    _commentView.font = kCommonDescFont;
    _commentView.layer.borderColor = kTableViewCellGrayColor.CGColor;
    [_baseView addSubview:_commentView];
    
    float submit_height = 50.f*kScreenRatio;
    
    _submitbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitbutton.frame = CGRectMake(0, _baseView.frame.size.height-submit_height, kScreenWidth, submit_height);
    _submitbutton.backgroundColor = kGreenColor;
    _submitbutton.titleLabel.font = kCommonTitleFont;
    [_submitbutton setTitle:@"提交" forState:UIControlStateNormal];
    [_baseView addSubview:_submitbutton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
