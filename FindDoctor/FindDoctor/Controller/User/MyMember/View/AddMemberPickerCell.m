//
//  AddMemberPickerCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//
#define AddMemberPickerCellHeight 54
#import "AddMemberPickerCell.h"

@implementation AddMemberPickerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        return self;
    }
    return nil;
}

+ (float)defaultCellHeight{
    return AddMemberPickerCellHeight;
}

- (void)initSubViews{

    
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, (AddMemberPickerCellHeight - 27)/2 + 8, 27, 27)];
    [self addSubview:self.icon];
    
    self.Label = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.maxX + 12, (AddMemberPickerCellHeight - 20)/2 + 8, 40, 20)];
    self.Label.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.Label];
    
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(self.Label.maxX + 10, (AddMemberPickerCellHeight - 25)/2 + 8, kScreenWidth - (self.Label.maxX + 10 + 25), 25)];
    self.btn.layer.borderColor = [UIColor clearColor].CGColor;
    self.btn.layer.borderWidth = 0;
    self.btn.titleLabel.textAlignment = NSTextAlignmentRight;
    self.btn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    self.btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.btn setTitleColor:kGrayTextColor forState:UIControlStateNormal];
    [self addSubview:self.btn];
    
    self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 30 - 9, (AddMemberPickerCellHeight - 15)/2 + 8, 9, 15)];
    self.arrow.image = [UIImage imageNamed:@"common_icon_grayArrow@2x"];
    [self addSubview:self.arrow];
    
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(self.Label.frameX, AddMemberPickerCellHeight - 1, kScreenWidth - self.Label.frameX - 24, 1)];
    self.bottomLine.backgroundColor = kLightLineColor;
    [self addSubview:self.bottomLine];
}

@end
