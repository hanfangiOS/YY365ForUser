//
//  MyTreatmentCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/19.
//  Copyright © 2016年 li na. All rights reserved.
//
#define MyTreatmentCellHeight 148

#import "MyTreatmentCell.h"
#import "UIImageView+WebCache.h"

@interface MyTreatmentCell ()
    
@property (strong,nonatomic)UIView      * headerView;
@property (strong,nonatomic)UILabel     * name;
@property (strong,nonatomic)UIView      * line;
@property (strong,nonatomic)UILabel     * finishLabel;

@property (strong,nonatomic)UIView      * infoView;
@property (strong,nonatomic)UIImageView * icon;
@property (strong,nonatomic)UILabel     * price;
@property (strong,nonatomic)UILabel     * info;
@property (strong,nonatomic)UILabel     * address;

@property (strong,nonatomic)UIButton    * commentBtn;
@property (strong,nonatomic)UIImageView * arrow;

@end

@implementation MyTreatmentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubViews];
        return self;
    }
    return nil;
}

+ (float)kDefaultHeight{
    return MyTreatmentCellHeight;
}

- (void)initSubViews{
    //上面一块view
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    [self addSubview:self.headerView];
    //朱军 教授 主治医生
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(10,0,180 , self.headerView.frameHeight)];
    self.name.textColor = [UIColor grayColor];
    self.name.font = [UIFont systemFontOfSize:12];
    self.name.textColor = kLightGrayColor;
    self.name.textAlignment = NSTextAlignmentLeft;
    [self.headerView addSubview:self.name];

    //线
    self.line = [[UIView alloc] initWithFrame:CGRectMake(8, self.headerView.frameHeight - 1, kScreenWidth - 8, 1)];
    self.line.backgroundColor = kblueLineColor;
    [self.headerView addSubview:self.line];
    //下面一块View 约诊人各种信息
    self.infoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.maxY, kScreenWidth, MyTreatmentCellHeight - self.headerView.frameHeight)];
    [self addSubview:self.infoView];
    //头像
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 58, 58)];
    self.icon.layer.cornerRadius = 5.0f;
    [self.infoView addSubview:self.icon];
    self.icon.backgroundColor = [UIColor blueColor];
    //¥100
    self.price = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.maxX + 15, 14, kScreenWidth - self.icon.maxX - 15 - 30, 15)];
    self.price.textColor = [UIColor orangeColor];
    self.price.font = [UIFont systemFontOfSize:18];
    [self.infoView addSubview:self.price];
    //罗威 1111-11-11 11:11
    self.info = [[UILabel alloc] initWithFrame:CGRectMake(self.price.frameX, self.price.maxY + 9, kScreenWidth - self.price.frameX - 30, 12)];
    self.info.textColor = kGrayTextColor;
    self.info.font = [UIFont systemFontOfSize:12];
    [self.infoView addSubview:self.info];
    //成都市青羊区金阳路358号
    self.address = [[UILabel alloc] initWithFrame:CGRectMake(self.info.frameX, self.info.maxY + 6, self.info.frameWidth, self.info.frameHeight)];
    self.address.textColor = kGrayTextColor;
    self.address.font = [UIFont systemFontOfSize:12];
    [self.infoView addSubview:self.address];
    
    
    //就诊完成
    self.finishLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.address.frameX, self.address.maxY + 12, 64, 20)];
    self.finishLabel.font = [UIFont systemFontOfSize:12];
    self.finishLabel.textColor = [UIColor whiteColor];
    self.finishLabel.text = @"就诊完成";
    self.finishLabel.textAlignment = NSTextAlignmentCenter;
    self.finishLabel.backgroundColor = kBlueTextColor;
    [self.infoView addSubview:self.finishLabel];
    
    //评价
    self.commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.finishLabel.maxX + 12,self.finishLabel.frameY , 64, 20)];
    [self.commentBtn setTitle:@"评价" forState:UIControlStateNormal];
    [self.commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    self.commentBtn.backgroundColor = [UIColor whiteColor];
    [self.commentBtn setTitleColor:kGrayTextColor forState:UIControlStateNormal];
    self.commentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.commentBtn.layer.borderColor = kLightLineColor.CGColor;
    self.commentBtn.layer.borderWidth = 1.0f;
    self.commentBtn.layer.cornerRadius = 2.0f;
    [self.commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    [self.infoView addSubview:self.commentBtn];
    //评价按钮里的那张小图片
    UIImageView * commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.commentBtn.frameWidth - 10.5)/2 - 16, (self.commentBtn.frameHeight - 10.5)/2, 10.5, 10.5)];
    commentIcon.image = [UIImage imageNamed:@"comment_icon_comment_gray@2x"];
    [self.commentBtn addSubview:commentIcon];
    
    //箭头
    self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 9 - 4, (self.infoView.frameHeight - 15)/2, 9, 15)];
    self.arrow.image = [UIImage imageNamed:@"common_icon_grayArrow@2x"];
    [self.infoView addSubview:self.arrow];
    
    //上线
    UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    topLine.backgroundColor = kblueLineColor;
    [self addSubview: topLine];
    //下线
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    bottomLine.backgroundColor = kblueLineColor;
    [self addSubview: bottomLine];
    
}

- (void)setData:(CUOrder *)data{
    _data = data;
    
    NSString * string = [NSString stringWithFormat:@"%@  %@  %@",_data.service.doctor.name,_data.service.doctor.levelDesc,_data.service.doctor.grade];
    NSMutableAttributedString * AtrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSInteger length = [_data.service.doctor.name length];
    [AtrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, length)];
    [AtrStr addAttribute:NSForegroundColorAttributeName
                   value:[UIColor blackColor]
                   range:NSMakeRange(0, length)];
    self.name.attributedText = AtrStr;
    
    [self.icon setImageWithURL:[NSURL URLWithString:_data.service.doctor.avatar]];
    
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString * strSymbol = [locale objectForKey:NSLocaleCurrencySymbol];
    self.price.text = [NSString stringWithFormat:@"%@%d",strSymbol,_data.service.doctor.price];
    
    NSString * diagnosisTimeStr = [[NSDate dateWithTimeIntervalSince1970:_data.service.doctor.diagnosisTime] stringWithDateFormat:@"yyyy-MM-dd HH:mm"];
    self.info.text = [NSString stringWithFormat:@"%@  %@",_data.service.patience.name,diagnosisTimeStr];
    
    self.address.text = [NSString stringWithFormat:@"%@",_data.service.doctor.address];
}

- (void)commentAction{
    if (self.clickCommentBtn) {
        self.clickCommentBtn();
    }
}

@end
