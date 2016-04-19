//
//  AddMemberPickerCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//
#define AddMemberPickerCellHeight 65
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

    
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, (AddMemberPickerCellHeight - 36)/2 + 10, 36, 36)];
    self.icon.layer.cornerRadius = 36/2;
    self.icon.clipsToBounds = YES;
    [self addSubview:self.icon];
    
    self.Label = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.maxX + 5, (AddMemberPickerCellHeight - 20)/2 + 10, 40, 20)];
    self.Label.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.Label];
    
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(self.Label.maxX + 10, (AddMemberPickerCellHeight - 25)/2 + 10, kScreenWidth - (self.Label.maxX + 10 + 25), 25)];
    self.btn.layer.borderColor = [UIColor clearColor].CGColor;
    self.btn.layer.borderWidth = 0;
    self.btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:self.btn];
    
    self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 30 - 25, (AddMemberPickerCellHeight - 25)/2 + 10, 25, 25)];
    [self addSubview:self.arrow];
    self.arrow.backgroundColor = [UIColor redColor];
    
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(self.Label.frameX, kScreenHeight - 0.5, kScreenWidth - self.Label.frameX - 25, 0.5)];
    self.bottomLine.backgroundColor = [UIColor blackColor];
    [self addSubview:self.bottomLine];
}

@end
