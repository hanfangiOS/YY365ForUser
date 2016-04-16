//
//  MyInfoAvatarCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#define MyInfoAvatarCellHeight 100

#import "MyInfoAvatarCell.h"

@implementation MyInfoAvatarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        return self;
    }
    return nil;
}

+ (float)cellDefaultHeight{
    return MyInfoAvatarCellHeight;
}

- (void)initSubViews{
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, (MyInfoAvatarCellHeight - 20)/2, 100, 20)];
    self.label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.label];
    
    self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 4 - 28, (MyInfoAvatarCellHeight - 28)/2, 28, 28)];
    self.arrow.image = [UIImage imageNamed:@""];
    [self addSubview:self.arrow];
    self.arrow.backgroundColor = [UIColor redColor];
    
    self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 4 - 28 - 64 - 4, (MyInfoAvatarCellHeight - 64)/2, 64, 64)];
    self.avatar.layer.cornerRadius = 64 / 2.f;
    self.avatar.clipsToBounds = YES;
    [self addSubview:self.avatar];
    self.avatar.backgroundColor = [UIColor yellowColor];

}

@end
