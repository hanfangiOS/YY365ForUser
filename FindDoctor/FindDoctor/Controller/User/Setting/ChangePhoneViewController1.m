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
    
    NSString * str = @"手机号是您登录优医365的唯一帐号，用于接收帐号通知，获取验证码等。您可以在这里更换当前账户的手机号。";
    CGSize size = [self sizeForString:str font:[UIFont systemFontOfSize:17] limitSize:CGSizeMake(kScreenWidth - 24 * 2, 0)];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(24, button.maxY + 40, size.width, size.height)];
    label.text = str;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = kLightGrayColor;
    [label sizeToFit];
    [self.contentView addSubview:label];
}

- (void)PushAction{
    ChangePhoneViewController2 *VC = [[ChangePhoneViewController2  alloc]initWithPageName:@"ChangePhoneViewController2"];
    [self.slideNavigationController pushViewController:VC  animated:YES];
}

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
}

- (CGSize)sizeForString:(NSString *)string font:(UIFont *)font limitSize:(CGSize)limitSize{
    
    CGFloat width = limitSize.width;
    CGFloat height = limitSize.height;
    if (!width) {
        width = CGFLOAT_MAX;
    }
    if (!height) {
        height = CGFLOAT_MAX;
    }
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, height)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    
    return rect.size;
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
