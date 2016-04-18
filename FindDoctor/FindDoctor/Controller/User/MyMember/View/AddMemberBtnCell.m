//
//  AddMemberBtnCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/17.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "AddMemberBtnCell.h"

@implementation AddMemberBtnCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        return self;
    }
    return nil;
}

- (void)initSubViews{
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(24, 20, kScreenWidth - 24 * 2, 40)];
    [self.btn setTitle:@"保存" forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btn.backgroundColor = [UIColor orangeColor];
    self.btn.layer.cornerRadius = 5.0f;
    [self addSubview:self.btn];
}

@end
