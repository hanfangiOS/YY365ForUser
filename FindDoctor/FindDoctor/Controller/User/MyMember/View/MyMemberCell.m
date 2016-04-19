//
//  MyMemberCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#define MyMemberCellHeight 50

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
        return self;
    }
    return nil;
}

+ (float)defaultCellHeight{
    return MyMemberCellHeight;
}

- (void)initSubViews{
    self.sex = [[UIImageView alloc] initWithFrame:CGRectMake(15, (MyMemberCellHeight - 25)/2, 25, 25)];
    [self addSubview:self.sex];
    self.sex.backgroundColor = [UIColor yellowColor];
    
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(self.sex.maxX + 10, (MyMemberCellHeight - 20)/2, 70, 20)];
    self.name.font = [UIFont systemFontOfSize:14];
    self.name.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.name];
    self.name.backgroundColor = [UIColor redColor];
    
    self.age = [[UILabel alloc] initWithFrame:CGRectMake(self.name.maxX + 5, (MyMemberCellHeight - 15)/2, 48, 15)];
    self.age.font = [UIFont systemFontOfSize:12];
    self.age.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.age];
    self.age.backgroundColor = [UIColor yellowColor];
    
    self.phone = [[UILabel alloc] initWithFrame:CGRectMake(self.age.maxX + 10, (MyMemberCellHeight - 15)/2, 100, 15)];
    self.phone.font = [UIFont systemFontOfSize:12];
    self.phone.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.phone];
    self.phone.backgroundColor = [UIColor blueColor];
    
    self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 30 - 5, (MyMemberCellHeight - 30)/2, 30, 30)];
    self.arrow.image = [UIImage imageNamed:@""];
    [self addSubview:self.arrow];
    self.arrow.backgroundColor = [UIColor redColor];

}

- (void)setData:(CUUser *)data{
    _data = data;
}

@end
