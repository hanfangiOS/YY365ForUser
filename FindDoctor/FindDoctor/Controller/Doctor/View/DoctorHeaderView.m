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
    UILabel         *doctorTitleLabel;
    
    UIButton        *guanzhuButton;
    
    UIImageView    *maskView;
    StarRatingView *rateView;
    UILabel        *introLabel;
    
    BlueDotLabelInDoctorHeaderView *zhenLiaoNumberLabel;
    BlueDotLabelInDoctorHeaderView *guanZhuNumberLabel;
    BlueDotLabelInDoctorHeaderView *haoPingNumberLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = kLightBlueColor;
        
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
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageOriginX + 20, imageOriginX, imageWidth, imageWidth)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self addSubview:imageView];
    
    imageView.layer.cornerRadius = imageWidth / 2;
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 30, CGRectGetMinY(imageView.frame)+5, 100  , 16)];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = UIColorFromHex(Color_Hex_Text_Normal);

    [self addSubview:nameLabel];
    
    doctorTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 30, CGRectGetMinY(imageView.frame) + 45-14, 100, 14)];
    doctorTitleLabel.font = [UIFont systemFontOfSize:14];
    doctorTitleLabel.textColor = UIColorFromHex(Color_Hex_Text_gray);
    [self addSubview:doctorTitleLabel];
    
    UIImage *guanzhuImage = [UIImage imageNamed:@"guanzhu"];
    guanzhuButton = [[UIButton alloc]initWithFrame:CGRectMake([self frameWidth]-guanzhuImage.size.width, 0, guanzhuImage.size.width, guanzhuImage.size.height)];
    guanzhuButton.layer.contents = (id)guanzhuImage.CGImage;
    [guanzhuButton addTarget:self action:@selector(guanZhuButtonAction) forControlEvents:UIControlEventTouchUpInside    ];
    [self addSubview:guanzhuButton];
    
    zhenLiaoNumberLabel = [[BlueDotLabelInDoctorHeaderView alloc]initWithFrame:CGRectMake(padding, CGRectGetMaxY(imageView.frame) + 10, 150, 12) title:@"诊疗" contents:[NSString stringWithFormat:@"%d",_data.numDiag] unit:@"次" hasDot:YES];
    [self addSubview:zhenLiaoNumberLabel];
    
    guanZhuNumberLabel = [[BlueDotLabelInDoctorHeaderView alloc]initWithFrame:CGRectMake(padding + (kScreenWidth - padding * 2)/3.f, CGRectGetMaxY(imageView.frame) + 10, 150, 12) title:@"关注" contents:[NSString stringWithFormat:@"%d",_data.numConcern] unit:@"次" hasDot:YES];
    [self addSubview:guanZhuNumberLabel];
    
    haoPingNumberLabel = [[BlueDotLabelInDoctorHeaderView alloc]initWithFrame:CGRectMake(padding + (kScreenWidth - padding * 2)/3.f*2, CGRectGetMaxY(imageView.frame) + 10, 150, 12) title:@"好评率" contents:[NSString stringWithFormat:@"%d%",_data.goodRemark] unit:@"" hasDot:YES];
    [self addSubview:haoPingNumberLabel];
    
//    rateView = [[StarRatingView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + padding - 5, 60, 14) type:StarTypeSmall starSpace:1];
//    rateView.editable = NO;
//    rateView.centerX = imageView.centerX;
//    [self addSubview:rateView];
    
    introLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(zhenLiaoNumberLabel.frame) + 10, (kScreenWidth - 2*padding), 105)];
    introLabel.font = [UIFont systemFontOfSize:12];
    introLabel.textColor = UIColorFromHex(Color_Hex_Text_gray);
    introLabel.numberOfLines = 0;
    [self addSubview:introLabel];
    
//    descLabel = [[UILabel alloc] initWithFrame:introLabel.frame];
//    descLabel.frameY = CGRectGetMaxY(introLabel.frame);
////    descLabel.frameHeight = 20;
//    descLabel.font = [UIFont systemFontOfSize:12];
//    descLabel.textColor = kDarkGrayColor;
//    descLabel.numberOfLines = 0;
//    [self addSubview:descLabel];
    
//    CGFloat btnWidth = 95.0;
//    CGFloat btnHeight = 30.0;
//    CGFloat btnLPadding = 30.0;
//    CGFloat btnBPadding = 20.0;
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(btnLPadding, CGRectGetHeight(self.bounds) - btnBPadding - btnHeight, btnWidth, btnHeight);
//    [leftBtn setTitle:@"咨询" forState:UIControlStateNormal];
//    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    leftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
//    [leftBtn setBackgroundImage:[[UIImage imageNamed:kButtonGreenNor] stretchableImageByCenter] forState:UIControlStateNormal];
//    [leftBtn setBackgroundImage:[[UIImage imageNamed:kButtonGreenSel] stretchableImageByCenter] forState:UIControlStateHighlighted];
//    [self addSubview:leftBtn];
    
//    leftBtn.backgroundColor = kGreenColor;
//    leftBtn.layer.cornerRadius = 3;
//    leftBtn.clipsToBounds = YES;
//    
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(CGRectGetWidth(self.bounds) - btnWidth - btnLPadding, CGRectGetHeight(self.bounds) - btnBPadding - btnHeight, btnWidth, btnHeight);
//    [rightBtn setTitle:@"选择日期" forState:UIControlStateNormal];
//    [rightBtn setTitleColor:kGreenColor forState:UIControlStateNormal];
//    rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
////    [rightBtn setBackgroundImage:[[UIImage imageNamed:kButtonWhiteNor] stretchableImageByCenter] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(selectDateButtonMethod) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:rightBtn];
//    
//    rightBtn.backgroundColor = [UIColor whiteColor];
//    rightBtn.layer.cornerRadius = 3;
//    rightBtn.layer.borderColor = kGreenColor.CGColor;
//    rightBtn.layer.borderWidth = kDefaultLineHeight;
//    rightBtn.clipsToBounds = YES;
//    
//    _dateLable = [[UILabel alloc] initWithFrame:rightBtn.frame];
//    _dateLable.frameX -= 110;
//    _dateLable.font = [UIFont systemFontOfSize:12];
//    _dateLable.textColor = [UIColor orangeColor];
//    _dateLable.textAlignment = NSTextAlignmentRight;
//    [self addSubview:_dateLable];
}

- (void)guanZhuButtonAction{
    [[CUDoctorManager sharedInstance]doctorConcernWithDoctorID:self.data.doctorId isConcern:(self.data.didConcern ? 0:1) resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError) {
            if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                self.data.didConcern = !self.data.didConcern;
                if (self.data.didConcern) {
                    guanzhuButton.layer.contents = (id)[UIImage imageNamed:@"haveguanzhu"].CGImage;
                }
                else{
                    guanzhuButton.layer.contents = (id)[UIImage imageNamed:@"guanzhu"].CGImage;
                }
            }
        }
    } pageName:@""];
}

- (void)setData:(Doctor *)data
{
    _data = data;
    
    [imageView setImageWithURL:[NSURL URLWithString:self.data.avatar] placeholderImage:nil];
    nameLabel.text = _data.name;
    doctorTitleLabel.text = _data.levelDesc;
    
    rateView.rate = self.data.rate;
    
    NSString *desc = self.data.briefIntro;
    
    [zhenLiaoNumberLabel resetTitle:@"诊疗" contents:[NSString stringWithFormat:@"%d",_data.numDiag] unit:@"次"];
    [guanZhuNumberLabel resetTitle:@"关注" contents:[NSString stringWithFormat:@"%d",_data.numConcern] unit:@"次"];
    [haoPingNumberLabel resetTitle:@"好评率" contents:[NSString stringWithFormat:@"%d",_data.goodRemark] unit:@"%"];
    
    introLabel.text = desc;
    [introLabel sizeToFit];
    self.frame = CGRectMake([self frameX], [self frameY], [self frameWidth], CGRectGetMaxY(introLabel.frame)+5);
    
    if (self.data.didConcern) {
        guanzhuButton.layer.contents = (id)[UIImage imageNamed:@"haveguanzhu"].CGImage;
    }
    else{
        guanzhuButton.layer.contents = (id)[UIImage imageNamed:@"guanzhu"].CGImage;
    }
}

- (void)selectDateButtonMethod
{
    if (self.selectDateBlock) {
        self.selectDateBlock();
    }
}

@end
