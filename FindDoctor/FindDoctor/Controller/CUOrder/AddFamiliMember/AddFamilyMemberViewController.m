//
//  AddFamilyMemberViewController.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/2/20.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "AddFamilyMemberViewController.h"
#import "CUUserManager.h"





@interface AddFamilyMemberViewController ()<UITextFieldDelegate>{
    UIScrollView *_contentScrollView;
    UIView *topViewbackgroundView;
    UIView *mainMessageViewBackgroundView;
    NSInteger scrollViewY;
    
    messageInputView *sexView;

    
}

@end

@implementation AddFamilyMemberViewController

@synthesize nameView;
@synthesize sexChooseView;
@synthesize ageView;
@synthesize phoneView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadContentView{
    self.contentView.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
    [self loadContentScrollView];
    
    [self loadTopView];
    [self loadMainMessageView];
    [self loadCommitView];
}

- (void)loadContentScrollView{
    _contentScrollView = [[UIScrollView alloc]initWithFrame:self.contentView.bounds];
    _contentScrollView.backgroundColor =  UIColorFromHex(Color_Hex_ImageDefault);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_contentScrollView addGestureRecognizer:tap];
    [self.contentView addSubview:_contentScrollView];
}

- (void)loadTopView{
    topViewbackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 63)];
    topViewbackgroundView.backgroundColor = [UIColor whiteColor];
    topViewbackgroundView.userInteractionEnabled = YES;
    [_contentScrollView addSubview:topViewbackgroundView];
    
    UIImageView *littleTrumpetImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"littleTrumpet"]];
    littleTrumpetImageView.frame = CGRectMake(10, 18, [littleTrumpetImageView frameWidth], [littleTrumpetImageView frameHeight]);
    [topViewbackgroundView addSubview:littleTrumpetImageView];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(littleTrumpetImageView.frame)+7, 18,kScreenWidth - 7 - 20 - [littleTrumpetImageView frameWidth], 0)];
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:@"添加新约诊人，可以使用当前登录的优医365账户进行约诊、就诊，约诊人病例在当前账户统一管理。"];
    lable.attributedText = string;
    lable.font = [UIFont systemFontOfSize:12];
    lable.textColor = UIColorFromHex(Color_Hex_NavBackground);
    lable.textAlignment = NSTextAlignmentLeft;
    lable.numberOfLines = 0;
    [lable sizeToFit];
    [topViewbackgroundView addSubview:lable];
    
    topViewbackgroundView.frame = CGRectMake(topViewbackgroundView.frameX, topViewbackgroundView.frameY, topViewbackgroundView.frameWidth, lable.frameHeight+36);
}

- (void)loadMainMessageView{
    mainMessageViewBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(topViewbackgroundView.frame) +10 , kScreenWidth, 0)];
    mainMessageViewBackgroundView.backgroundColor = [UIColor whiteColor];
    mainMessageViewBackgroundView.userInteractionEnabled = YES;
    [_contentScrollView addSubview:mainMessageViewBackgroundView];
    
    nameView = [[messageInputView alloc]initWithFrame:CGRectMake(18, 14, kScreenWidth - 36, 24)];
    nameView.titleLabel.text = @"姓名";
    nameView.contentTextField.delegate = self;
    [mainMessageViewBackgroundView addSubview:nameView];
    
    sexView = [[messageInputView alloc]initWithFrame:CGRectMake(18, 14 + 40, kScreenWidth - 36, 24)];
    sexView.titleLabel.text = @"性别";
    sexView.contentTextField.hidden = YES;
    [mainMessageViewBackgroundView addSubview:sexView];
    
    sexChooseView = [[SexChooseView alloc]initWithFrame:sexView.contentTextField.frame];
    [sexView addSubview:sexChooseView];
    
    ageView = [[messageInputView alloc]initWithFrame:CGRectMake(18, 14 + 40*2, kScreenWidth - 36, 24)];
    ageView.titleLabel.text = @"年龄";
    ageView.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
    ageView.contentTextField.delegate = self;
    [mainMessageViewBackgroundView addSubview:ageView];
    
    phoneView = [[messageInputView alloc]initWithFrame:CGRectMake(18, 14 + 40*3, kScreenWidth - 36, 24)];
    phoneView.titleLabel.text = @"电话";
    phoneView.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneView.contentTextField.delegate = self;
    [mainMessageViewBackgroundView addSubview:phoneView];
    
    mainMessageViewBackgroundView.frame = CGRectMake(0,CGRectGetMaxY(topViewbackgroundView.frame) +10 , kScreenWidth, CGRectGetMaxY(phoneView.frame) + 18);
}

- (void)loadCommitView{
    UIView *commitBackgroundView = [[UIView alloc]init];
    commitBackgroundView.frame = CGRectMake(0, [self.contentView frameHeight] - 50, [self.contentView frameHeight], 50);
    commitBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:commitBackgroundView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromHex(0xeeeeee);
    [commitBackgroundView addSubview:lineView];
    
    
    UIButton   *commitButton = [[UIButton alloc]initWithFrame:CGRectMake(7, 7, kScreenWidth - 2*7, 50 - 2*7)];
    [commitButton setTitle:@"添          加" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitButton.layer.cornerRadius = 5.0;
    commitButton.layer.backgroundColor = UIColorFromHex(Color_Hex_NavBackground).CGColor;
    [commitButton addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    
    [commitBackgroundView addSubview:commitButton];
}

- (void)commitAction{
    if ([self checkData]){
        __weak __block AddFamilyMemberViewController *blockSelf = self;
        [[CUUserManager sharedInstance] AddDiagnosisMemberWithDiagnosisID:self.diagnosisID name:nameView.contentTextField.text sex:sexChooseView.sex age:[ageView.contentTextField.text integerValue] phone:[phoneView.contentTextField.text longLongValue] resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
            if (!result.hasError) {
                if (blockSelf.backBlock) {
                    NSInteger err_code = [[result.responseObject valueForKey:@"errorCode"]integerValue];
                    if (err_code == 0) {
                        NSInteger userId = [[[result.responseObject valueForKey:@"data"] valueForKey:@"accID"] integerValue];
                        CUUser *user = [[CUUser alloc]init];
                        user.name = [NSString stringWithFormat:@"%@", blockSelf.nameView.contentTextField.text];
                        user.gender = blockSelf.sexChooseView.sex;
                        user.age   = [blockSelf.ageView.contentTextField.text integerValue];
                        user.userId = userId;
                        user.cellPhone = blockSelf.phoneView.contentTextField.text;
                        
                        blockSelf.backBlock(user);
                        [blockSelf backAction];
                    }
                    else {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"添加失败" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }//errorCode
                }//backBlock
            }//!result.hasError
        } pageName:@"AddFamilyMemberViewController"];
    }
}

- (BOOL)checkData{
    BOOL mark = YES;
    NSString *message;
    if ([nameView.contentTextField.text isEmpty]) {
        message = @"请输入姓名";
        mark = NO;
    }
    if ([ageView.contentTextField.text isEmpty]) {
        message = @"请输入年龄";
        mark = NO;
    }
    if (phoneView.contentTextField.text.length != 11) {
        message = @"请输入正确的手机号";
        mark = NO;
    }
    if ([phoneView.contentTextField.text isEmpty]) {
        message = @"请输入姓名";
        mark = NO;
    }
    if (!mark) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    return mark;
}

#pragma mark - textFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    scrollViewY = _contentScrollView.contentOffset.y;
    
    if (textField == nameView.contentTextField) {
        NSInteger mark = [_contentScrollView frameHeight] - (CGRectGetMinY(nameView.frame) + mainMessageViewBackgroundView.frameX -  _contentScrollView.contentOffset.y) - 390;
        if (mark > 0) {
            return;
        }
        [_contentScrollView setContentOffset:CGPointMake(0,_contentScrollView.contentOffset.y - mark) animated:YES];
    }
    if (textField == ageView.contentTextField) {
        NSInteger mark = [_contentScrollView frameHeight] - (CGRectGetMinY(ageView.frame) + mainMessageViewBackgroundView.frameX -  _contentScrollView.contentOffset.y) - 390;
        if (mark > 0) {
            return;
        }
        [_contentScrollView setContentOffset:CGPointMake(0,_contentScrollView.contentOffset.y - mark) animated:YES];
    }
    if (textField == phoneView.contentTextField) {
        NSInteger mark = [_contentScrollView frameHeight] - (CGRectGetMinY(phoneView.frame) + mainMessageViewBackgroundView.frameX -  _contentScrollView.contentOffset.y) - 390;
        if (mark > 0) {
            return;
        }
        [_contentScrollView setContentOffset:CGPointMake(0,_contentScrollView.contentOffset.y - mark) animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [_contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEdit];
    return YES;
}

- (void)endEdit{
    [nameView.contentTextField resignFirstResponder];
    [ageView.contentTextField resignFirstResponder];
    [phoneView.contentTextField resignFirstResponder];
}

- (void)loadNavigationBar
{
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


@implementation messageInputView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 24)];
    _titleLabel.text = @"title";
    _titleLabel.textColor = UIColorFromHex(Color_Hex_Text_gray);
    _titleLabel.font = [UIFont systemFontOfSize:13];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(_titleLabel.frameX, (24 - _titleLabel.frameHeight)/2,46, _titleLabel.frameHeight);
    [self addSubview:_titleLabel];
    
    _contentTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame),0 ,self.frameWidth - CGRectGetMaxX(_titleLabel.frame), 24)];
    _contentTextField.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _contentTextField.layer.borderColor = UIColorFromHex(0xcccccc).CGColor;
    _contentTextField.layer.borderWidth = 0.5f;
    _contentTextField.font = [UIFont systemFontOfSize:13];
    [self addSubview:_contentTextField];
}
@end

@implementation SexChooseView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        imageActivated = [UIImage imageNamed:@"radioButtonActivated"];
        imageDisactivated = [UIImage imageNamed:@"radioButtonDisActivated"];
        [self initSubView];
        [self buttonMaleAction];
    }
    return self;
}

- (void)initSubView{
    buttonMale = [[UIButton alloc]initWithFrame:CGRectMake(5, (24 - imageActivated.size.height)/2, imageActivated.size.width, imageActivated.size.height)];
    [buttonMale addTarget:self action:@selector(buttonMaleAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonMale];
    
    UIButton *maleButton = [[UIButton alloc]init];
    [maleButton setTitle:@"男" forState:UIControlStateNormal];
    [maleButton setTitleColor:UIColorFromHex(Color_Hex_Text_gray) forState:UIControlStateNormal];
    maleButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [maleButton sizeToFit];
    maleButton.frame = CGRectMake(CGRectGetMaxX(buttonMale.frame) + 5, (self.frameHeight - maleButton.frameHeight)/2,maleButton.frameWidth, maleButton.frameHeight);
    [maleButton addTarget:self action:@selector(buttonMaleAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:maleButton];
    
    buttonFamale = [[UIButton alloc]initWithFrame:CGRectMake(53, (self.frameHeight - imageActivated.size.height)/2, imageActivated.size.width, imageActivated.size.height)];
    [buttonFamale addTarget:self action:@selector(buttonFamaleAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonFamale];
    
    UIButton *famaleButton = [[UIButton alloc]init];
    [famaleButton setTitle:@"女" forState:UIControlStateNormal];
    [famaleButton setTitleColor:UIColorFromHex(Color_Hex_Text_gray) forState:UIControlStateNormal];
    famaleButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [famaleButton sizeToFit];
    famaleButton.frame = CGRectMake(CGRectGetMaxX(buttonFamale.frame) + 5, (self.frameHeight - famaleButton.frameHeight)/2,famaleButton.frameWidth, famaleButton.frameHeight);
    [famaleButton addTarget:self action:@selector(buttonFamaleAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:famaleButton];
    
}

- (void)buttonMaleAction{
    _sex = 1;
    buttonMale.layer.contents = (id)imageActivated.CGImage;
    buttonFamale.layer.contents = (id)imageDisactivated.CGImage;
    [self setNeedsDisplay];
}

- (void)buttonFamaleAction{
    _sex = 0;
    buttonMale.layer.contents = (id)imageDisactivated.CGImage;
    buttonFamale.layer.contents = (id)imageActivated.CGImage;
    [self setNeedsDisplay];
}

@end