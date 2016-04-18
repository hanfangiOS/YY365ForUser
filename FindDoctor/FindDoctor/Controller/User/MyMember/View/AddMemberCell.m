//
//  AddMemberCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//
#define AddMemberCellHeight 65

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
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, (AddMemberCellHeight - 36)/2 + 10, 36, 36)];
    self.icon.layer.cornerRadius = 36/2;
    self.icon.clipsToBounds = YES;
    [self addSubview:self.icon];
    
    self.Label = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.maxX + 5, (AddMemberCellHeight - 20)/2 + 10, 40, 20)];
    self.Label.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.Label];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(self.Label.maxX + 10, (AddMemberCellHeight - 25)/2 + 10, kScreenWidth - (self.Label.maxX + 10 + 50), 25)];
    self.textField.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.textField];
    
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(self.Label.frameX, kScreenHeight - 0.5, kScreenWidth - self.Label.frameX - 25, 0.5)];
    self.bottomLine.backgroundColor = [UIColor blackColor];
    [self addSubview:self.bottomLine];
}

@end
