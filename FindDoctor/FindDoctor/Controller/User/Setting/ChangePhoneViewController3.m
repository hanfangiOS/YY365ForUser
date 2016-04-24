//
//  ChangePhoneViewController3.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/20.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "ChangePhoneViewController3.h"
#import "SettingTextFeildView.h"

@interface ChangePhoneViewController3 (){
    SettingTextFeildView *_phoneTextFeild;
    SettingTextFeildView *_codeTextFeild;
}

@end

@implementation ChangePhoneViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认绑定";
    // Do any additional setup after loading the view.
}

- (void)loadContentView{
    self.contentView.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    imageView.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:imageView];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, imageView.maxY + 10, kScreenWidth, 16*3 + 35*2)];
    view.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:view];
    
    int textFeildHeight = 35;
    
    _phoneTextFeild = [[SettingTextFeildView alloc]initWithFrame:CGRectMake(20,16, kScreenWidth - 40, textFeildHeight) Title:@"手机号"];
    [view addSubview:_phoneTextFeild];
    
    _codeTextFeild = [[SettingTextFeildView alloc]initWithFrame:CGRectMake(20,_phoneTextFeild.maxY+16, kScreenWidth - 40, textFeildHeight) Title:@"验证码"];
    [view addSubview:_codeTextFeild];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(22, view.maxY + 10, kScreenWidth - 50, 37)];
    button.layer.backgroundColor = UIColorFromHex(0xf1a80b).CGColor;
    button.layer.cornerRadius = 3;
    [button setTitle:@"确认绑定" forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(PushAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
}

- (void)PushAction{

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
