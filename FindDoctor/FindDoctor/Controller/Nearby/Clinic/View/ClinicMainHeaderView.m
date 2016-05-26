//
//  ClinicMainHeaderView.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/2/26.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "ClinicMainHeaderView.h"
#import "UIImageView+WebCache.h"
#import "BlueDotLabelInDoctorHeaderView.h"
#import "CUClinicManager.h"
#import "CUUserManager.h"
#import "LoginViewController.h"
#import "TipHandler+HUD.h"

@interface ClinicMainHeaderView(){
    UIImageView *imageView;
    UIButton    *zhenSuoFengCaiButton;
    UILabel     *descLabel;
    UIButton    *guanzhuButton;
    UILabel     *addressLabel;
    UILabel     *phoneLabel;
    UIImageView *phoneImageView;
    
    BlueDotLabelInDoctorHeaderView *zhenLiaoNumberLabel;
    BlueDotLabelInDoctorHeaderView *guanZhuNumberLabel;
    BlueDotLabelInDoctorHeaderView *haoPingNumberLabel;
}


@end


@implementation ClinicMainHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    self.backgroundColor = [UIColor whiteColor];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(14, 8, 85, 110)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.layer.borderColor = [UIColor blackColor].CGColor;
    imageView.layer.borderWidth = 0.5;
    [self addSubview:imageView];
    
    zhenSuoFengCaiButton = [[UIButton alloc]initWithFrame:CGRectMake(imageView.frameX, CGRectGetMaxY(imageView.frame)+7, imageView.frameWidth, 25)];

    zhenSuoFengCaiButton.layer.borderColor = UIColorFromHex(0xf4732a).CGColor;
    zhenSuoFengCaiButton.layer.backgroundColor = [UIColor clearColor].CGColor;
    zhenSuoFengCaiButton.layer.borderWidth = 0.5;
    [zhenSuoFengCaiButton setTitle:@"诊所风采" forState:UIControlStateNormal];
    [zhenSuoFengCaiButton setTitleColor: UIColorFromHex(0xf4732a) forState:UIControlStateNormal];
    zhenSuoFengCaiButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:zhenSuoFengCaiButton];
    
    descLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+imageView.frameX, imageView.frameY + 5, self.frameWidth - imageView.frameX*4 - imageView.frameWidth , imageView.frameHeight/2)];
    descLabel.numberOfLines = 0;
    descLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:descLabel];
    
    UIImage *guanzhuImage = [UIImage imageNamed:@"doctor_waitForConcen"];
    guanzhuButton = [[UIButton alloc]initWithFrame:CGRectMake([self frameWidth]-guanzhuImage.size.width, 0, guanzhuImage.size.width, guanzhuImage.size.height)];
    guanzhuButton.layer.contents = (id)guanzhuImage.CGImage;
    [guanzhuButton addTarget:self action:@selector(guanZhuButtonAction) forControlEvents:UIControlEventTouchUpInside    ];
    [self addSubview:guanzhuButton];
    
    addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(descLabel.frameX, CGRectGetMaxY(descLabel.frame)+10, descLabel.frameWidth+imageView.frameX, 14)];
    addressLabel.font = descLabel.font;
    addressLabel.textColor = UIColorFromHex(Color_Hex_Text_gray);
    addressLabel.numberOfLines = 2;
    [self addSubview:addressLabel];
    
    phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(addressLabel.frameX, CGRectGetMaxY(addressLabel.frame)+10, addressLabel.frameWidth, 14)];
    phoneLabel.font = descLabel.font;
    phoneLabel.textColor = UIColorFromHex(Color_Hex_Text_gray);
    phoneLabel.numberOfLines = 1;
    phoneLabel.userInteractionEnabled = YES;
    [self addSubview:phoneLabel];
    
    phoneImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clinic_icon_phoneButton"]];
    phoneImageView.contentMode = 1;
    phoneImageView.userInteractionEnabled = YES;
    [self addSubview:phoneImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(phoneAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [phoneLabel addGestureRecognizer:tap];
    [phoneImageView addGestureRecognizer:tap];
    
    CGFloat padding = 15.0;
    zhenLiaoNumberLabel = [[BlueDotLabelInDoctorHeaderView alloc]initWithFrame:CGRectMake(padding, CGRectGetMaxY(zhenSuoFengCaiButton.frame) + 10, 150, 12) title:@"诊疗" contents:[NSString stringWithFormat:@"%ld",(long)_data.numDiag] unit:@"次" hasDot:YES];
    [self addSubview:zhenLiaoNumberLabel];
    
    guanZhuNumberLabel = [[BlueDotLabelInDoctorHeaderView alloc]initWithFrame:CGRectMake(padding + (kScreenWidth - padding * 2)/3.f, CGRectGetMaxY(zhenSuoFengCaiButton.frame) + 10, 150, 12) title:@"关注" contents:[NSString stringWithFormat:@"%ld",(long)_data.numConcern] unit:@"次" hasDot:YES];
    [self addSubview:guanZhuNumberLabel];
    
    haoPingNumberLabel = [[BlueDotLabelInDoctorHeaderView alloc]initWithFrame:CGRectMake(padding + (kScreenWidth - padding * 2)/3.f*2, CGRectGetMaxY(zhenSuoFengCaiButton.frame) + 10, 150, 12) title:@"好评率" contents:[NSString stringWithFormat:@"%ld",(long)_data.goodRemark] unit:@"" hasDot:YES];
    [self addSubview:haoPingNumberLabel];
}

- (void)setData:(Clinic *)data{
    _data = data;
    [imageView setImageWithURL:[NSURL URLWithString:_data.icon] placeholderImage:[UIImage imageNamed:@"temp_clinic"]];
    descLabel.text = _data.detailIntro;
    
    NSString *title = @"地址: ";
    NSString *str = [NSString stringWithFormat:@"%@%@",title,_data.address];
    NSMutableAttributedString *atrStr = [[NSMutableAttributedString alloc]initWithString:str];
    [atrStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromHex(Color_Hex_NavBackground)} range:[str rangeOfString:title]];
    addressLabel.attributedText = atrStr;
    [addressLabel sizeToFit];
    
    title = @"电话: ";
    str = [NSString stringWithFormat:@"%@%@",title,_data.phone];
    atrStr = [[NSMutableAttributedString alloc]initWithString:str];
    [atrStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromHex(Color_Hex_NavBackground)} range:[str rangeOfString:title]];
    phoneLabel.attributedText = atrStr;
    [phoneLabel sizeToFit];
    
    [self resetguanzhuButton];
    
    [zhenLiaoNumberLabel setTitle:@"诊疗" contents:[NSString stringWithFormat:@"%ld",(long)_data.numDiag] unit:@"次"];
    [guanZhuNumberLabel setTitle:@"关注" contents:[NSString stringWithFormat:@"%ld",(long)_data.numConcern] unit:@"次"];
    [haoPingNumberLabel setTitle:@"好评率" contents:[NSString stringWithFormat:@"%ld",(long)_data.goodRemark] unit:@"%"];
    
    int intervalY = 7;
    
    self.frame = CGRectMake(self.frameX, self.frameY, self.frameWidth, CGRectGetMaxY(haoPingNumberLabel.frame) + intervalY);
    
    descLabel.frame = CGRectMake(descLabel.frameX, intervalY, descLabel.frameWidth, self.frameHeight - intervalY - phoneLabel.frameHeight - addressLabel.frameHeight - intervalY*4 - haoPingNumberLabel.frameHeight);
    addressLabel.frame = CGRectMake(addressLabel.frameX, CGRectGetMaxY(descLabel.frame)+intervalY, addressLabel.frameWidth, addressLabel.frameHeight);
    phoneLabel.frame = CGRectMake(phoneLabel.frameX, CGRectGetMaxY(addressLabel.frame)+intervalY,phoneLabel.frameWidth , phoneLabel.frameHeight);
    phoneImageView.frame = CGRectMake(CGRectGetMaxX(phoneLabel.frame) + intervalY*3, phoneLabel.frameY - 2, phoneLabel.frameHeight +4, phoneLabel.frameHeight +4);
    

    
    [self setNeedsDisplay];
}

- (void)phoneAction{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_data.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)guanZhuButtonAction{
    
    if ([CUUserManager sharedInstance].user.token) {
        __weak __block ClinicMainHeaderView *blockSelf = self;
        [[CUClinicManager sharedInstance] clinicConcernWithClinic:blockSelf.data resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
            if (!result.hasError) {
                if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                    blockSelf.data.isConcern = !blockSelf.data.isConcern;
                    [blockSelf resetguanzhuButton];
                    if (self.data.isConcern) {
                        [TipHandler showTipOnlyTextWithNsstring:@"关注成功"];
                    }
                    else{
                        [TipHandler showTipOnlyTextWithNsstring:@"已取消关注"];
                    }
    
                }
            }
        } pageName:@"ClinicMainHeaderView"];
    }else{
        //未登录
        LoginViewController * vc = [[LoginViewController alloc] initWithPageName:@"LoginViewController"];
        [vc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self.fatherVC.slideNavigationController presentViewController:vc animated:YES completion:nil];
    }

}

- (void)resetguanzhuButton{
    if (self.data.isConcern) {
        guanzhuButton.layer.contents = (id)[UIImage imageNamed:@"doctor_HasConcen"].CGImage;
    }
    else{
        guanzhuButton.layer.contents = (id)[UIImage imageNamed:@"doctor_waitForConcen"].CGImage;
    }
}

@end
