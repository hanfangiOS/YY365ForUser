//
//  MyMemberCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#define MyMemberCellHeight 44

#import "MyMemberCell.h"

@interface MyMemberCell ()

@property (strong,nonatomic)UIImageView * sex;
@property (strong,nonatomic)UILabel     * name;
@property (strong,nonatomic)UILabel     * age;
@property (strong,nonatomic)UILabel     * phone;
@property (strong,nonatomic)UIImageView * arrow;

@end

@implementation MyMemberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubViews];
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        return self;
    }
    return nil;
}

+ (float)defaultCellHeight{
    return MyMemberCellHeight;
}

- (void)initSubViews{
//    //性别图标
//    self.sex = [[UIImageView alloc] initWithFrame:CGRectMake(15, (MyMemberCellHeight - 25)/2, 25, 25)];
//    [self addSubview:self.sex];
//    self.sex.backgroundColor = [UIColor yellowColor];
//    //名字
//    self.name = [[UILabel alloc] initWithFrame:CGRectMake(self.sex.maxX + 10, (MyMemberCellHeight - 20)/2, 70, 20)];
//    self.name.font = [UIFont systemFontOfSize:17];
//    self.name.textColor = [UIColor blackColor];
//    self.name.textAlignment = NSTextAlignmentLeft;
//    [self addSubview:self.name];
//     //年龄
//    self.age = [[UILabel alloc] initWithFrame:CGRectMake(self.name.maxX + 5, (MyMemberCellHeight - 15)/2, 48, 15)];
//    self.age.font = [UIFont systemFontOfSize:12];
//    self.age.textColor = kLightGrayColor;
//    self.age.textAlignment = NSTextAlignmentLeft;
//    [self addSubview:self.age];
//     //电话
//    self.phone = [[UILabel alloc] initWithFrame:CGRectMake(self.age.maxX + 10, (MyMemberCellHeight - 15)/2, 100, 15)];
//    self.phone.font = [UIFont systemFontOfSize:12];
//    self.phone.textColor = kLightGrayColor;
//    self.phone.textAlignment = NSTextAlignmentLeft;
//    [self addSubview:self.phone];
//     //箭头
//    self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 30 - 5, (MyMemberCellHeight - 30)/2, 30, 30)];
//    self.arrow.image = [UIImage imageNamed:@""];
//    [self addSubview:self.arrow];
//    self.arrow.backgroundColor = [UIColor redColor];

}

- (void)setData:(CUUser *)data{
    _data = data;
    
    if (_data.gender == CUUserGenderFemale) {
        self.imageView.image = [UIImage imageNamed:@"member_icon_gender_f"];
    }
    if (_data.gender == CUUserGenderMale) {
        self.imageView.image = [UIImage imageNamed:@"member_icon_gender_m"];
    }
    
    self.textLabel.text = _data.name;
    
    self.detailTextLabel.text = [NSString stringWithFormat:@"%ld岁 %@",(long)_data.age,_data.cellPhone];
    self.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
//    self.name.text = _data.name;
//    
//    self.age.text = [NSString stringWithFormat:@"%ld岁",(long)_data.age];
//    
//    self.phone.text = _data.cellPhone;
    
}

@end
