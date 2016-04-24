//
//  ChangePhoneViewController1.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/20.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "ChangePhoneViewController1.h"
#import "ChangePhoneViewController2.h"

@interface ChangePhoneViewController1 ()

@end

@implementation ChangePhoneViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改手机号";
    // Do any additional setup after loading the view.
}

- (void)loadContentView{
    self.contentView.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    imageView.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:imageView];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(22, imageView.maxY + 10, kScreenWidth - 50, 37)];
    button.layer.backgroundColor = UIColorFromHex(0xf1a80b).CGColor;
    button.layer.cornerRadius = 3;
    [button setTitle:@"更换手机号" forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(PushAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
}

- (void)PushAction{
    ChangePhoneViewController2 *VC = [[ChangePhoneViewController2  alloc]initWithPageName:@"ChangePhoneViewController2"];
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
