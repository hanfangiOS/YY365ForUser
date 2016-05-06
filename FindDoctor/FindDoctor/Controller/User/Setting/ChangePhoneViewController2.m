//
//  ChangePhoneViewController2.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/20.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "ChangePhoneViewController2.h"
#import "ChangePhoneViewController3.h"
#import "SettingTextFeildView.h"
#import "CUUserManager.h"

@interface ChangePhoneViewController2 ()

@end

@implementation ChangePhoneViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写验证码";
    // Do any additional setup after loading the view.
}
- (void)loadContentView{
    self.contentView.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
    
    UIImage *image = [UIImage imageNamed:@"setting_changePwd2"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, image.size.height/image.size.width*kScreenWidth)];
    imageView.image = image;
    [self.contentView addSubview:imageView];
    
    UILabel *labelTop = [[UILabel alloc]initWithFrame:CGRectMake(0, image.size.height/5, kScreenWidth, 20)];
    labelTop.textColor = [UIColor whiteColor];
    labelTop.font = [UIFont systemFontOfSize:17];
    labelTop.textAlignment = NSTextAlignmentCenter;
    labelTop.text = [NSString stringWithFormat:@"当前手机号：%@",[CUUserManager sharedInstance].user.cellPhone];
    [imageView addSubview:labelTop];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, imageView.maxY + 23, kScreenWidth, 16*2 + 35)];
    view.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:view];
    
    int textFeildHeight = 35;
    
    SettingTextFeildView *textFeild = [[SettingTextFeildView alloc]initWithFrame:CGRectMake(20, (view.frameHeight - textFeildHeight)/2, kScreenWidth - 40, textFeildHeight) Title:@"请填写验证码"];
    textFeild.imageView.image = [UIImage imageNamed:@"setting_icon_checkTransparent"];
    [view addSubview:textFeild];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(22, view.maxY + 23, kScreenWidth - 50, 37)];
    button.layer.backgroundColor = UIColorFromHex(0xf1a80b).CGColor;
    button.layer.cornerRadius = 3;
    [button setTitle:@"绑定新的手机号" forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(PushAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
}

- (void)PushAction{
    ChangePhoneViewController3 *VC = [[ChangePhoneViewController3  alloc]initWithPageName:@"ChangePhoneViewController3"];
    [self.slideNavigationController pushViewController:VC  animated:YES];
}
- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
