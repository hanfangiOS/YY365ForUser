//
//  MyInfoCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#define MyInfoCellHeight 44

#import "MyInfoCell.h"

@implementation MyInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        return self;
    }
    return nil;
}

+ (float)cellDefaultHeight{
    return MyInfoCellHeight;
}

- (void)initSubViews{
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, (MyInfoCellHeight - 20)/2, 100, 20)];
    self.label.textAlignment = NSTextAlignmentLeft;
    self.label.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.label];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(self.label.maxX + 12, (MyInfoCellHeight - 24)/2, kScreenWidth - (self.label.maxX + 12 + 12), 24)];
    self.textField.textAlignment = NSTextAlignmentRight;
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.layer.borderColor = [UIColor clearColor].CGColor;
    [self addSubview:self.textField];

    
}

@end
