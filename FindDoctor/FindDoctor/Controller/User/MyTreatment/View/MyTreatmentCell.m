//
//  MyTreatmentCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/19.
//  Copyright © 2016年 li na. All rights reserved.
//
#define MyTreatmentCellHeight 170

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

+ (float)defaultHeight{
    return MyTreatmentCellHeight;
}

- (void)initSubViews{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    [self addSubview:self.headerView];
    
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(10,0,160 , self.headerView.frameHeight)];
    self.name.textColor = [UIColor grayColor];
    self.name.font = [UIFont systemFontOfSize:13];
    self.name.textAlignment = NSTextAlignmentLeft;
    [self.headerView addSubview:self.name];
    
    self.finishLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 70 - 20, (self.headerView.frameHeight - 22)/2, 70, 22)];
    self.finishLabel.font = [UIFont systemFontOfSize:13];
    self.finishLabel.textColor = [UIColor whiteColor];
    self.finishLabel.text = @"就诊完成";
    self.finishLabel.textAlignment = NSTextAlignmentCenter;
    self.finishLabel.backgroundColor = [UIColor blueColor];
    [self.headerView addSubview:self.finishLabel];

    self.line = [[UIView alloc] initWithFrame:CGRectMake(10, self.headerView.frameHeight - 0.5, kScreenWidth - 10, 0.5)];
    self.line.backgroundColor = [UIColor grayColor];
    [self.headerView addSubview:self.line];
    
    self.infoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.maxY, kScreenWidth, MyTreatmentCellHeight - self.headerView.frameHeight)];
    [self addSubview:self.infoView];
    
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 72, 72)];
    self.icon.layer.cornerRadius = 5.0f;
    [self.infoView addSubview:self.icon];
    self.icon.backgroundColor = [UIColor blueColor];
    
    self.price = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.maxX + 15, 14, kScreenWidth - self.icon.maxX - 15 - 30, 22)];
    self.price.textColor = [UIColor yellowColor];
    [self.infoView addSubview:self.price];
    self.price.backgroundColor = [UIColor purpleColor];
    
    self.info = [[UILabel alloc] initWithFrame:CGRectMake(self.price.frameX, self.price.maxY + 4, kScreenWidth - self.price.frameX - 30, 20)];
    self.info.textColor = [UIColor grayColor];
    [self.infoView addSubview:self.info];
    self.info.backgroundColor = [UIColor blackColor];
    
    self.address = [[UILabel alloc] initWithFrame:CGRectMake(self.info.frameX, self.info.maxY + 2, self.info.frameWidth, self.info.frameHeight)];
    self.address.textColor = [UIColor grayColor];
    [self.infoView addSubview:self.address];
    self.address.backgroundColor = [UIColor orangeColor];
    
    self.commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.address.frameX, self.address.maxY + 10, 80, 25)];
    [self.commentBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [self.commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    self.commentBtn.backgroundColor = [UIColor whiteColor];
    [self.commentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.commentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.commentBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.commentBtn.layer.borderWidth = 1.0f;
    self.commentBtn.layer.cornerRadius = 2.0f;
    [self.commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [self.infoView addSubview:self.commentBtn];
    
    UIImageView * commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.commentBtn.frameWidth - 15)/2 - 25, (self.commentBtn.frameHeight - 15)/2, 15, 15)];
    commentIcon.image = [UIImage imageNamed:@""];
    commentIcon.backgroundColor = [UIColor redColor];
    [self.commentBtn addSubview:commentIcon];
    
    self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 25 - 2, (self.infoView.frameHeight - 25)/2, 20, 25)];
    self.arrow.image = [UIImage imageNamed:@""];
    [self.infoView addSubview:self.arrow];
    self.arrow.backgroundColor = [UIColor greenColor];
    
}

- (void)setData:(CUOrder *)data{
    _data = data;
    
    NSString * string = [NSString stringWithFormat:@"%@   %@",_data.service.doctor.name,_data.service.doctor.levelDesc];
    self.name.text = string;
    NSMutableAttributedString * AtrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSInteger length = [_data.service.doctor.name length];
    [AtrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, length)];
    [AtrStr addAttribute:NSForegroundColorAttributeName
                   value:[UIColor blackColor]
                   range:NSMakeRange(0, length)];
    
    
    [self.icon setImageWithURL:[NSURL URLWithString:_data.service.doctor.avatar]];
    
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString * strSymbol = [locale objectForKey:NSLocaleCurrencySymbol];
    self.price.text = [NSString stringWithFormat:@"%@%d",strSymbol,_data.service.doctor.price];
    
    self.address.text = [NSString stringWithFormat:@"%@",_data.service.doctor.address];
}

- (void)commentAction{
    if (self.clickCommentBtn) {
        self.clickCommentBtn();
    }
}

@end
