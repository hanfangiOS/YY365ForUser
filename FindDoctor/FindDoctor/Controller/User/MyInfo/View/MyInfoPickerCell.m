//
//  MyInfoPickerCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/19.
//  Copyright © 2016年 li na. All rights reserved.
//
#define MyInfoPickerCellHeight 50

#import "MyInfoPickerCell.h"

@implementation MyInfoPickerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        return self;
    }
    return nil;
}

+ (float)cellDefaultHeight{
    return MyInfoPickerCellHeight;
}

- (void)initSubViews{
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, (MyInfoPickerCellHeight - 20)/2, 100, 20)];
    self.label.textAlignment = NSTextAlignmentLeft;
    self.label.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.label];
    
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(self.label.maxX + 12, (MyInfoPickerCellHeight - 24)/2, kScreenWidth - (self.label.maxX + 12 + 12), 24)];
    self.btn.titleLabel.textAlignment = NSTextAlignmentRight;
    self.btn.layer.borderColor = [UIColor clearColor].CGColor;
    self.btn.layer.borderWidth = 1.0f;
    [self.btn setTitleColor:kGrayTextColor forState:UIControlStateNormal];
    self.btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.btn];
    
    
}

@end
