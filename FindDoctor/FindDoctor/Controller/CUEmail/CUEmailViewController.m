//
//  CUEmailViewController.m
//  FindDoctor
//
//  Created by Tom Zhang on 15/11/23.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CUEmailViewController.h"
#import "CUServerAPIConstant.h"
#import "CUUIContant.h"
#import "CUUserManager.h"
#import "MBProgressHUD.h"
#import "TipHandler+HUD.h"
#import "UIImage+Color.h"
#import "UIConstants.h"

#define kHeight_Field            35.0
#define kTextFieldTPadding      25.0

#define kEmailCellHeight        (kHeight_Field + kTextFieldTPadding)

#define kButtonLeftMargin_Email      40.0
#define kButtonTopMargin_Email       30.0
#define kButtonHeight_Email          40.0

#define kEmailTextColor     UIColorFromRGB(38, 98, 101)

@interface CUEmailViewController ()

@property (nonatomic,strong) UIView *contentView1;
@property (nonatomic,strong) UITextField *emailField;
@property (nonatomic,strong) UIButton *confirmButton;

@end

@implementation CUEmailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.pageName = @"CUEmailViewController";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置邮箱";
    
    UITapGestureRecognizer *backTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    [self.contentView1 addGestureRecognizer:backTapGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self endEditing];
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

- (void)loadContentView
{
    CGFloat leftPadding = kButtonLeftMargin_Email;
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.clipsToBounds = YES;
    
    self.contentView1 = [[UIView alloc] initWithFrame:self.contentView.bounds];
    self.contentView1.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.contentView1];
    
    //    [self loadHeaderImage];
    
    //    CGFloat headerHeight = CGRectGetMaxY(headerImage.frame);
    CGFloat headerHeight = 144.0;
    
    UILabel *hint = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, headerHeight - 20, CGRectGetWidth(self.contentView.bounds)- leftPadding * 2, kEmailCellHeight)];
    hint.backgroundColor = [UIColor clearColor];
    hint.font = [UIFont systemFontOfSize:14];
    hint.textColor = [UIColor whiteColor];
    hint.text = @"请输入邮箱便于接收诊金、诊金券赠送和就诊处方单信息。";
    hint.numberOfLines = 2;
    [self.contentView addSubview:hint];
    
    UIView *emailTextView = [[UIView alloc] initWithFrame:hint.frame];
    emailTextView.frameY = CGRectGetMaxY(hint.frame);
    emailTextView.frameHeight = kEmailCellHeight;
    emailTextView.backgroundColor = [UIColor clearColor];
    
    _emailField = [[UITextField alloc] initWithFrame:CGRectMake(0, kTextFieldTPadding, emailTextView.frameWidth, kHeight_Field)];
    _emailField.delegate = self;
    _emailField.returnKeyType = UIReturnKeyDone;
    _emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入邮箱地址" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _emailField.font = [UIFont systemFontOfSize:14];
    _emailField.textColor = [UIColor whiteColor];
    [emailTextView addSubview:_emailField];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, emailTextView.frameHeight - kDefaultLineHeight,  emailTextView.frameWidth, kDefaultLineHeight)];
    lineView1.backgroundColor = [UIColor whiteColor];
    [emailTextView addSubview:lineView1];
    
    [self.contentView addSubview:emailTextView];
    
    //
    self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(kButtonLeftMargin_Email, CGRectGetMaxY(emailTextView.frame) + kButtonTopMargin_Email, self.contentView.frameWidth - kButtonLeftMargin_Email *2, kButtonHeight_Email)];
    [self.confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.confirmButton setBackgroundImage:[UIImage createImageWithColor:kGreenColor] forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.contentView1 addSubview:self.confirmButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Action

- (void)endEditing
{
    [self textFieldResignFirstResponder];
}

- (void)backAction
{
    [self endEditing];
    
    [super backAction];
}

- (void)backToRoot
{
    [self endEditing];
    
    [self.slideNavigationController popToRootViewControllerAnimated:YES];
}

- (void)closeAction
{
    [self endEditing];
    
    [self.slideNavigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmButtonAction
{
    [self endEditing];
    [self showProgressView];
    
    __block __weak CUEmailViewController * blockSelf = self;
    SNServerAPIResultBlock handler = ^(SNHTTPRequestOperation *request, SNServerAPIResultData *result)
    {
        [blockSelf hideProgressView];
        
        if (!result.hasError)//连接正常
        {
            //服务器内部正常
            if (![(NSNumber *)[result.responseObject valueForKey:@"err_code"] integerValue]) {
                
                [TipHandler showHUDText:@"邮箱设置成功" inView:blockSelf.contentView];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[[result.responseObject valueForKey:@"data"] valueForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                
                [alert show];
                
//                [blockSelf performSelector:@selector(backToRoot) withObject:nil afterDelay:0.5];
            }
            else {
                [TipHandler showHUDText:[result.responseObject valueForKey:@"data"] inView:blockSelf.contentView];
                //                [[CUUserManager sharedInstance] clear];
            }
        }
        else {
            [TipHandler showHUDText:[result.error.userInfo valueForKey:NSLocalizedDescriptionKey] inView:blockSelf.contentView];
        }
    };
    
    [[CUUserManager sharedInstance] updateUser:[CUUserManager sharedInstance].user emailAddress:_emailField.text resultBlock:handler pageName:@"CUEmailViewController"];
}

- (void)editingStateDidChanged:(BOOL)isEditing
{
    if (Is_Phone4) {
        if (isEditing) {
            if (self.contentView1.frameY == 0) {
                [UIView animateWithDuration:.3 animations:^{
                    self.contentView1.frameY = 0 - 100;
                }];
            }
        }
        else {
            if (self.contentView1.frameY < 0) {
                [UIView animateWithDuration:.3 animations:^{
                    self.contentView1.frameY = 0;
                }];
            }
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldResignFirstResponder
{
    [_emailField resignFirstResponder];
    
    if ([self respondsToSelector:@selector(editingStateDidChanged:)]) {
        [self editingStateDidChanged:NO];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (0 == buttonIndex) {
        [self performSelector:@selector(backToRoot) withObject:nil afterDelay:0.5];
    }
}
@end
