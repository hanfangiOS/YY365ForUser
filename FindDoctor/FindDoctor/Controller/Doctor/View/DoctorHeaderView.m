//
//  DoctorHeaderView.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "DoctorHeaderView.h"
#import "UIImageView+WebCache.h"
#import "StarRatingView.h"
#import "BlueDotLabelInDoctorHeaderView.h"
#import "CUDoctorManager.h"



#define kDoctorHeaderViewHeight   178.0

@implementation DoctorHeaderView
{
    UIImageView     *imageView;
    UILabel         *nameLabel;
    UILabel         *titleLabel;
    StarRatingView  *rateView;
    UILabel         *rateLabel;
    UIButton        *commentButton;
    
    UIButton        *guanzhuButton;
    
    UIImageView    *maskView;

    UILabel        *introLabel;
    
    BlueDotLabelInDoctorHeaderView *zhenLiaoNumberLabel;
    BlueDotLabelInDoctorHeaderView *guanZhuNumberLabel;
    BlueDotLabelInDoctorHeaderView *haoPingNumberLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
//        self.backgroundColor = kLightBlueColor;
        self.backgroundColor = [UIColor whiteColor];
        
        [self initSubviews];
    }
    
    return self;
}

+ (CGFloat)defaultHeight
{
    return kDoctorHeaderViewHeight;
}

- (void)initSubviews
{
    CGFloat padding = 15.0;
    
    CGFloat imageOriginX = padding + 5;
    CGFloat imageWidth = 50.0;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageOriginX, imageOriginX, imageWidth, imageWidth)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self addSubview:imageView];
    
    imageView.layer.cornerRadius = imageWidth / 2;
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 20, CGRectGetMinY(imageView.frame)+5, 1  , 16)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textColor = kDarkGrayColor;

    [self addSubview:nameLabel];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 20, CGRectGetMinY(imageView.frame)+35, 1  , 16)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = kDarkGrayColor;
    
    [self addSubview:titleLabel];
    
    rateView = [[StarRatingView alloc] initWithFrame:CGRectMake(nameLabel.frameX, CGRectGetMaxY(nameLabel.frame) + 10,105, 14) type:StarTypeSmall starSpace:0];
    rateView.editable = NO;
//    rateView.backgroundColor = [UIColor redColor];
    [self addSubview:rateView];
    
    rateLabel = [[UILabel alloc]initWithFrame:CGRectMake(rateView.maxX + 2, rateView.frameY, 40, 18)];
//    rateLabel.backgroundColor = [UIColor redColor];
    rateLabel.textColor = UIColorFromHex(0xfdbd06);
    rateLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:rateLabel];
    
    commentButton = [[UIButton alloc]initWithFrame:CGRectMake(rateLabel.maxX, rateLabel.frameY, 50, 18)];
    [commentButton setTitle:@"口碑" forState:UIControlStateNormal];
    [commentButton setTitleColor:UIColorFromHex(0xfdbd06) forState:UIControlStateNormal];
    commentButton.titleLabel.font = [UIFont systemFontOfSize:12];
    commentButton.layer.borderColor = UIColorFromHex(0xfdbd06).CGColor;
    commentButton.layer.borderWidth = 1;
    commentButton.layer.cornerRadius = commentButton.frameHeight/2.f;
    [commentButton addTarget:self action:@selector(commentBlockAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:commentButton];
    
    UIImage *guanzhuImage = [UIImage imageNamed:@"doctor_waitForConcen"];
    guanzhuButton = [[UIButton alloc]initWithFrame:CGRectMake([self frameWidth]-guanzhuImage.size.width, 0, guanzhuImage.size.width, guanzhuImage.size.height)];
    guanzhuButton.layer.contents = (id)guanzhuImage.CGImage;
    [guanzhuButton addTarget:self action:@selector(guanZhuButtonAction) forControlEvents:UIControlEventTouchUpInside    ];
    [self addSubview:guanzhuButton];
    
    zhenLiaoNumberLabel = [[BlueDotLabelInDoctorHeaderView alloc]initWithFrame:CGRectMake(padding, CGRectGetMaxY(imageView.frame) + 10, 150, 12) title:@"诊疗" contents:[NSString stringWithFormat:@"%ld",(long)_data.numDiag] unit:@"次" hasDot:YES];
    [self addSubview:zhenLiaoNumberLabel];
    
    guanZhuNumberLabel = [[BlueDotLabelInDoctorHeaderView alloc]initWithFrame:CGRectMake(padding + (kScreenWidth - padding * 2)/3.f, CGRectGetMaxY(imageView.frame) + 10, 150, 12) title:@"关注" contents:[NSString stringWithFormat:@"%ld",(long)_data.numConcern] unit:@"次" hasDot:YES];
    [self addSubview:guanZhuNumberLabel];
    
    haoPingNumberLabel = [[BlueDotLabelInDoctorHeaderView alloc]initWithFrame:CGRectMake(padding + (kScreenWidth - padding * 2)/3.f*2, CGRectGetMaxY(imageView.frame) + 10, 150, 12) title:@"好评率" contents:[NSString stringWithFormat:@"%ld%",(long)_data.goodRemark] unit:@"" hasDot:YES];
    [self addSubview:haoPingNumberLabel];
    
    introLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(zhenLiaoNumberLabel.frame) + 10, (kScreenWidth - 2*padding), 105)];
    introLabel.font = [UIFont systemFontOfSize:12];
    introLabel.textColor = UIColorFromHex(Color_Hex_Text_gray);
    introLabel.numberOfLines = 0;
    [self addSubview:introLabel];
}

- (void)guanZhuButtonAction{
    [[CUDoctorManager sharedInstance]doctorConcernWithDoctorID:self.data.doctorId isConcern:(self.data.didConcern ? 0:1) resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                self.data.didConcern = !self.data.didConcern;
                if (self.data.didConcern) {
                    guanzhuButton.layer.contents = (id)[UIImage imageNamed:@"doctor_HasConcen"].CGImage;
                }
                else{
                    guanzhuButton.layer.contents = (id)[UIImage imageNamed:@"doctor_waitForConcen"].CGImage;
                }
            }
        }
    } pageName:@""];
}

- (void)setData:(Doctor *)data
{
    _data = data;
    if(_data){
        [imageView setImageWithURL:[NSURL URLWithString:self.data.avatar] placeholderImage:[UIImage imageNamed:@"temp_icon_doctor.jpg"]];
        
        NSString *str = [NSString stringWithFormat:@"%@      %@",self.data.name,self.data.levelDesc];
        NSMutableAttributedString *atrStr = [[NSMutableAttributedString alloc]initWithString:str];
        
        [atrStr addAttributes:@{NSFontAttributeName:SystemFont_14,NSForegroundColorAttributeName:kBlackColor} range:[str rangeOfString:self.data.name]];
        nameLabel.attributedText = atrStr;
        [nameLabel sizeToFit];
        
        rateView.rate = _data.rate;
        rateLabel.text = [NSString stringWithFormat:@"%.1f",_data.rate];
        NSString *desc = _data.briefIntro;
        
        [zhenLiaoNumberLabel setTitle:@"诊疗" contents:[NSString stringWithFormat:@"%ld",(long)_data.numDiag] unit:@"次"];
        [guanZhuNumberLabel setTitle:@"关注" contents:[NSString stringWithFormat:@"%ld",(long)_data.numConcern] unit:@"次"];
        [haoPingNumberLabel setTitle:@"好评率" contents:[NSString stringWithFormat:@"%ld",(long)_data.goodRemark] unit:@"%"];
        
        introLabel.text = desc;
        [introLabel sizeToFit];
        self.frame = CGRectMake([self frameX], [self frameY], [self frameWidth], CGRectGetMaxY(introLabel.frame)+5);
        
        if (self.data.didConcern) {
            guanzhuButton.layer.contents = (id)[UIImage imageNamed:@"doctor_HasConcen"].CGImage;
        }
        else{
            guanzhuButton.layer.contents = (id)[UIImage imageNamed:@"doctor_waitForConcen"].CGImage;
        }
    }
}

- (void)commentBlockAction
{
    if (self.commentBlock) {
        self.commentBlock();
    }
}

@end
