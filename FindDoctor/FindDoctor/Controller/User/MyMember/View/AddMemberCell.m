//
//  AddMemberCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//
#define AddMemberCellHeight 54

#import "AddMemberCell.h"

@implementation AddMemberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        return self;
    }
    return nil;
}

+ (float)defaultCellHeight{
    return AddMemberCellHeight;
}

- (void)initSubViews{
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(22, (AddMemberCellHeight - 27)/2 + 8, 27, 27)];
    self.icon.layer.cornerRadius = 27/2;
    self.icon.clipsToBounds = YES;
    [self addSubview:self.icon];
    
    self.Label = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.maxX + 12, (AddMemberCellHeight - 20)/2 + 8, 40, 20)];
    self.Label.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.Label];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(self.Label.maxX + 10, (AddMemberCellHeight - 25)/2 + 8, kScreenWidth - (self.Label.maxX + 10 + 24 + 20), 25)];
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.textAlignment = NSTextAlignmentRight;
    self.textField.textColor = kGrayTextColor;
    [self addSubview:self.textField];
    
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(self.Label.frameX, AddMemberCellHeight - 1, kScreenWidth - self.Label.frameX - 24, 1)];
    self.bottomLine.backgroundColor = kLightLineColor;
    [self addSubview:self.bottomLine];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)tapAction{
    [self.textField becomeFirstResponder];
}

@end
