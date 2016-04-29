//
//  DetailsHeaderView.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/18.
//  Copyright © 2016年 li na. All rights reserved.
//

#define DetailsHeaderViewHeight 92

#import "DetailsHeaderView.h"
#import "UIImageView+WebCache.h"

@interface DetailsHeaderView()

@property (strong,nonatomic)UIImageView * icon;
@property (strong,nonatomic)UILabel     * name;
@property (strong,nonatomic)UILabel     * brief;
@property (strong,nonatomic)UIImageView * arrow;

@end

@implementation DetailsHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        return self;
    }
    return nil;
}

+ (float)defaultHeight{
    
    return DetailsHeaderViewHeight;
}

- (void)initSubViews{
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, (DetailsHeaderViewHeight - 70)/2, 70, 70)];
    self.icon.layer.cornerRadius = 5.0f;
    [self addSubview:self.icon];
    self.icon.backgroundColor = [UIColor brownColor];
    
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.maxX + 6, self.icon.frameX + 2, kScreenWidth - self.icon.maxX - 6 - 50, 25)];
    self.name.font = [UIFont systemFontOfSize:12];
    self.name.textColor = kBlueColor;
    [self addSubview:self.name];
    
    self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 20, (DetailsHeaderViewHeight - 25)/2, 20, 25)];
    self.arrow.image = [UIImage imageNamed:@""];
    self.arrow.backgroundColor = [UIColor redColor];
    [self addSubview:self.arrow];
    
    self.brief = [[UILabel alloc] initWithFrame:CGRectMake(self.name.frameX, self.name.maxY + 4, kScreenWidth - self.name.frameX - self.arrow.frameWidth - 30, 40)];
    self.brief.font = [UIFont systemFontOfSize:10];
    self.brief.textColor = kLightGrayColor;
    self.brief.numberOfLines = 2;
    [self addSubview:self.brief];
}

- (void)setData:(Doctor *)data{
    _data = data;
    
    [self.icon setImageWithURL:[NSURL URLWithString:_data.avatar]];
    
    NSString * string = [NSString stringWithFormat:@"%@  %@  %@",_data.name,_data.levelDesc,_data.grade];
    NSMutableAttributedString * AtrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSInteger length = [_data.name length];
    [AtrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, length)];
    [AtrStr addAttribute:NSForegroundColorAttributeName
                   value:[UIColor blackColor]
                   range:NSMakeRange(0, length)];
    self.name.attributedText = AtrStr;
    
    self.brief.text = [NSString stringWithFormat:@"%@",_data.briefIntro];
}


@end
