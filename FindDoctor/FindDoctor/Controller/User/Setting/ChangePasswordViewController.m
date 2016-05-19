    //
//  ChangePasswordViewController.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/20.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "CUUserManager.h"
#import "SettingTextFeildView.h"
#import "TipHandler.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>

@property (strong,nonatomic)UIScrollView            * scrollViiew;

@property (strong,nonatomic)UIView                  * beforePwdBackgroundView;
@property (strong,nonatomic)SettingTextFeildView    * beforePwdView;

@property (strong,nonatomic)UIView                  * nowPwdBackgroundView;
@property (strong,nonatomic)SettingTextFeildView    * nowPwdView;
@property (strong,nonatomic)SettingTextFeildView    * confirmPwdView;
@property (strong,nonatomic)UIButton                * button;


@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showProgressView];
    __weak __block ChangePasswordViewController *blockSelf = self;
    [[CUUserManager sharedInstance] checkIfHasOldPasswordWithResultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        [blockSelf hideProgressView];
        if (!result.hasError)
        {
            if (!result.hasError && ![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]){
                NSInteger isExistNum = [[result.responseObject dictionaryForKeySafely:@"data"] integerForKeySafely:@"isExist"];
                if (isExistNum) {
                    NSLog(@"存在旧密码， 启用旧密码+新密码形式改密码");
                    [self.scrollViiew addSubview:self.beforePwdBackgroundView];
                    [self.scrollViiew addSubview:self.nowPwdBackgroundView];
                    [self.scrollViiew addSubview:self.button];
                }
                else{
                    self.nowPwdBackgroundView.frameY = 10;
                    [self.scrollViiew addSubview:self.nowPwdBackgroundView];
                    self.button.frameY = self.nowPwdBackgroundView.maxY + 23;
                    [self.scrollViiew addSubview:self.button];
                    NSLog(@"不存在旧密码， 直接设置新密码");
                }
            }
        }
    } pageName:@"ChangePasswordViewController"];
}

- (void)loadContentView{
    self.scrollViiew = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    self.scrollViiew.scrollEnabled = YES;
    self.scrollViiew.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:self.scrollViiew];
    
    //第一块view
    self.beforePwdBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 90)];
    self.beforePwdBackgroundView.backgroundColor = [UIColor whiteColor];
    
    //旧密码
    self.beforePwdView = [[SettingTextFeildView alloc] initWithFrame:CGRectMake(22, (self.beforePwdBackgroundView.frameHeight - [SettingTextFeildView defaultHeight])/2, kScreenWidth - 22 * 2 , [SettingTextFeildView defaultHeight]) Title:@"旧密码"];
    self.
    self.beforePwdView.imageView.image = [UIImage imageNamed:@"setting_icon_password"];
    self.beforePwdView.contentTextFeild.delegate = self;
    [self.beforePwdBackgroundView addSubview:self.beforePwdView];
    //第二块View
    self.nowPwdBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,self.beforePwdBackgroundView.maxY + 10, kScreenWidth, 150)];
    self.nowPwdBackgroundView.backgroundColor = [UIColor whiteColor];
    
    //新密码
    self.nowPwdView = [[SettingTextFeildView alloc] initWithFrame:CGRectMake(22, 25, kScreenWidth - 22 * 2 , [SettingTextFeildView defaultHeight]) Title:@"新密码"];
    self.nowPwdView.imageView.image = [UIImage imageNamed:@"setting_icon_password"];
    self.nowPwdView.contentTextFeild.delegate = self;
    [self.nowPwdBackgroundView addSubview:self.nowPwdView];
    [self.nowPwdView.contentTextFeild addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    //确认密码
    self.confirmPwdView = [[SettingTextFeildView alloc] initWithFrame:CGRectMake(22,self.nowPwdView.maxY + 25, kScreenWidth - 22 * 2 , [SettingTextFeildView defaultHeight]) Title:@"确认密码"];
    self.confirmPwdView.imageView.image = [UIImage imageNamed:@"setting_icon_password"];
    self.confirmPwdView.contentTextFeild.delegate = self;
    [self.nowPwdBackgroundView addSubview:self.confirmPwdView];
    [self.confirmPwdView.contentTextFeild addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(22, self.nowPwdBackgroundView.maxY + 23, kScreenWidth - 50, 37)];
    self.button.layer.backgroundColor = UIColorFromHex(0xf1a80b).CGColor;
    self.button.layer.cornerRadius = 3;
    [self.button setTitle:@"确认绑定" forState:UIControlStateNormal];
    self.button.titleLabel.textColor = [UIColor whiteColor];
    [self.button addTarget:self action:@selector(CommitAction) forControlEvents:UIControlEventTouchUpInside];

}

- (void)CommitAction{
    if ([self.nowPwdView.contentTextFeild.text isEmpty]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"密码不能为空" delegate:self cancelButtonTitle:@
                              "确定"otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![self checkPassword:self.nowPwdView.contentTextFeild.text]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"密码格式错误" message:@"密码首字符必须为英文字母，6~20位" delegate:self cancelButtonTitle:@
                              "确定"otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![self.confirmPwdView.contentTextFeild.text isEqualToString:self.nowPwdView.contentTextFeild.text]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确认密码不一致" delegate:self cancelButtonTitle:@
                              "确定"otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self request];
}

- (void)request{
    [[CUUserManager sharedInstance] updateUser:[CUUserManager sharedInstance].user oldPassword:self.beforePwdView.contentTextFeild.text newPassword:self.confirmPwdView.contentTextFeild.text resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject objectForKeySafely:@"errorCode"];
            if (![errorCode integerValue]){
                [TipHandler showTipOnlyTextWithNsstring:@"修改密码成功"];
                [self performSelector:@selector(backAction) withObject:nil afterDelay:2];
            }
            else{
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject stringForKeySafely:@"data"]];
            }
        }
        else {
            [TipHandler showTipOnlyTextWithNsstring:@"网络连接失败，请检查网络"];
        }
    } pageName:self.pageName];
}

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
}

#pragma mark textFeildDelegate
- (void)textFieldEditChanged:(UITextField *)textFeild{
    if (textFeild == self.nowPwdView.contentTextFeild) {
        if (self.nowPwdView.clicked) {
            if ([self checkPassword:self.nowPwdView.contentTextFeild.text]) {
                self.nowPwdView.imageView.image = [UIImage imageNamed:@"setting_icon_YES"];
            }
            else{
                self.nowPwdView.imageView.image = [UIImage imageNamed:@"setting_icon_NO"];
            }
        }
    }
    if (textFeild == self.confirmPwdView.contentTextFeild) {
        if ([self.confirmPwdView.contentTextFeild.text isEqualToString:self.nowPwdView.contentTextFeild.text] && ![self.confirmPwdView.contentTextFeild.text isEmpty]) {
            self.confirmPwdView.imageView.image = [UIImage imageNamed:@"setting_icon_YES"];
            self.confirmPwdView.clicked = YES;
        }
        if (self.confirmPwdView.clicked) {
            if ([self.confirmPwdView.contentTextFeild.text isEqualToString:self.nowPwdView.contentTextFeild.text] && ![self.confirmPwdView.contentTextFeild.text isEmpty]) {
                self.confirmPwdView.imageView.image = [UIImage imageNamed:@"setting_icon_YES"];
            }
            else{
                self.confirmPwdView.imageView.image = [UIImage imageNamed:@"setting_icon_NO"];
            }
        }
    }
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField == self.nowPwdView.contentTextFeild) {
        if ([self checkPassword:textField.text]) {
            self.nowPwdView.imageView.image = [UIImage imageNamed:@"setting_icon_YES"];
        }
        else{
            self.nowPwdView.imageView.image = [UIImage imageNamed:@"setting_icon_NO"];
        }
        self.nowPwdView.clicked = YES;
    }
    if (textField == self.confirmPwdView.contentTextFeild) {
        if ([textField.text isEqualToString:self.nowPwdView.contentTextFeild.text] && ![textField.text isEmpty]) {
            self.confirmPwdView.imageView.image = [UIImage imageNamed:@"setting_icon_YES"];
        }
        else{
            self.confirmPwdView.imageView.image = [UIImage imageNamed:@"setting_icon_NO"];
        }
        self.confirmPwdView.clicked = YES;
    }
    return  YES;
}

- (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^(?![0-9]*$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
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
