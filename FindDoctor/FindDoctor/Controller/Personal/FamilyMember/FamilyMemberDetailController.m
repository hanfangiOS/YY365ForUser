//
//  FamilyMemberDetailController.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/8.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "FamilyMemberDetailController.h"
#import "TipHandler+HUD.h"
#import "CUUserManager+FamilyMember.h"
#import "UIImageView+WebCache.h"
#import "FamilyMemberDetailController+UploadAvartar.h"

#define kHeadHeight     39.0
#define kRowNumber      3
#define kRowHeight      44.0

#define kTextTitleColor kDarkGrayColor
#define kTextColor      kBlackColor
#define kTextGrayColor  UIColorFromHex(0xc6c6c6)

#define kLineColor      UIColorFromRGB(200,200,200)

#define kTextFont       [UIFont systemFontOfSize:14]

#define kFooterHeight     64.0

#define kNameMaxLength    32   // 姓名最多16个汉字，即32个字符

#define kPhoneMaxLength   11

#define kAlertViewDelete  99
#define kAlertViewSave    100

@interface FamilyMemberDetailController () <UITextFieldDelegate, UITextViewDelegate>

@end

@implementation FamilyMemberDetailController
{
    UIScrollView      *_contentScrollView;
        
    UITextField       *_nameField;
    UITextField       *_phoneField;
    UITextField       *_genderField;
    UITextField       *_ageField;
    UITextField       *_relationField;

    UIView            *_whiteView;
    
    float              _contentMaxY;
    
    UIButton          *_setDefaultButton;
    UIButton          *_confirmButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"家庭成员";
    if (self.editType == FamilyMemberEditTypeAdd) {
        self.title = @"添加新成员";
    }
    else if (self.editType == FamilyMemberEditTypeModify) {
        self.title = @"修改成员信息";
    }
    
    [self initTempMember];
    [self initSubviews];
    [self fillData];
    
    //[self showTopTipIfNeed];
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

- (void)initBottomView
{
    
}

- (void)initSubviews
{
    [self initNavigationBar];
    [self initContentView];
    [self initFooterView];
}

- (void)initContentView
{
    float originY = 0;
    float viewWidth = self.contentView.frameWidth;
    CGFloat viewHeight = self.contentView.frameHeight;
    CGFloat footerHeight = (self.editType == FamilyMemberEditTypeNone) ? 0 : kFooterHeight;
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight - footerHeight)];
    _contentScrollView.backgroundColor = kLightBlueColor;
    [self.contentView addSubview:_contentScrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [_contentScrollView addGestureRecognizer:tap];
    
    CGFloat headerHeight = 190.0;
    UIImageView *avartarHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _contentScrollView.frameWidth, headerHeight)];
    avartarHeader.image = [UIImage imageNamed:@"family_detail_deader_bg"];
    [_contentScrollView addSubview:avartarHeader];
    
    CGFloat imageWidth = 80.0;
    _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth - imageWidth) / 2, 30, imageWidth, imageWidth)];
    [_avatarView setImageWithURL:[NSURL URLWithString:self.user.profile] placeholderImage:nil];
    [_contentScrollView addSubview:_avatarView];
    
    _avatarView.clipsToBounds = YES;
    _avatarView.layer.cornerRadius = imageWidth / 2;
    
    _avatarView.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToUploadImage)];
    _avatarView.image = [UIImage imageNamed:@"user_placeHolder_nor"];
    [_avatarView addGestureRecognizer:imageTap];
    
    CGFloat tipHeight = 45.0;
    UIView *topTipView = [[UIView alloc] initWithFrame:CGRectMake(0, headerHeight - tipHeight, self.contentView.frameWidth, tipHeight)];
    topTipView.backgroundColor = [kGreenColor colorWithAlphaComponent:0.5];
    [_contentScrollView addSubview:topTipView];
    
    CGFloat tipPadding = 15.0;
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(tipPadding, 5, topTipView.frameWidth - tipPadding * 2, topTipView.frameHeight - 10)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.numberOfLines = 2;
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.text = @"为xx先生添加新成员，新成员可以使用xx先生的账户进行预约、就诊，成员病例在xx账户统一管理。";
    [topTipView addSubview:tipLabel];
    
    _nameField = [[UITextField alloc] init];
    _relationField = [[UITextField alloc] init];
    _phoneField = [[UITextField alloc] init];
    _genderField = [[UITextField alloc] init];
    _ageField = [[UITextField alloc] init];
    
    NSArray *titleArray = @[@"姓名",@"性别",@"年龄",@"电话",@"与注册人关系"];
    NSArray *viewArray = @[_nameField,_genderField,_ageField,_phoneField,_relationField];
    
    originY = 220.0;
    CGFloat padding = 20.0;
    CGFloat titleWidth = 56.0;
    CGFloat cellHeight = 34.0;
    for (int i = 0; i < titleArray.count; i ++) {
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(padding, originY, viewWidth - padding * 2, cellHeight)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.clipsToBounds = YES;
        [_contentScrollView addSubview:bgView];
        
        bgView.layer.cornerRadius = 3;
        bgView.layer.borderColor = kLightLineColor.CGColor;
        bgView.layer.borderWidth = kDefaultLineHeight;
        
        CGRect labelRect = CGRectMake(padding, originY, titleWidth, cellHeight);
        
        if (i == titleArray.count - 1) {
            labelRect.size.width += 46;
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
        label.text = [titleArray objectAtIndex:i];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = kTextTitleColor;
        label.font = kTextFont;
        label.textAlignment = NSTextAlignmentCenter;
        [_contentScrollView addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 0, kDefaultLineHeight, 14)];
        lineView.centerY = label.centerY;
        lineView.backgroundColor = kTextTitleColor;
        [_contentScrollView addSubview:lineView];
        
        CGFloat fieldOriginX = 100.0;
        if (i == titleArray.count - 1) {
            fieldOriginX += 46;
        }
        
        UITextField *textField = [viewArray objectAtIndex:i];
        textField.frame = CGRectMake(fieldOriginX, originY, viewWidth - 100 - padding, cellHeight);
        textField.borderStyle = UITextBorderStyleNone;
        textField.textColor = kTextColor;
        textField.font = kTextFont;
        textField.delegate = self;
        textField.tag = i + 100;
        textField.returnKeyType = UIReturnKeyDone;
        textField.userInteractionEnabled = [self isTextfieldEditable];
        [_contentScrollView addSubview:textField];
        
        if (i == 2 || i == 3) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        [textField addTarget:self action:@selector(textFieldEndEdit) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        originY += (cellHeight + padding);
    }
    
    _contentScrollView.contentSize = CGSizeMake(CGRectGetWidth(_contentScrollView.bounds), originY + 216);
    
    /*
    float whiteOriginY = kHeadHeight;
    CGRect whiteRect = CGRectMake(0, whiteOriginY, viewWidth, originY - whiteOriginY);
    _whiteView = [[UIView alloc] initWithFrame:whiteRect];
    _whiteView.backgroundColor = [UIColor whiteColor];
    [_contentScrollView insertSubview:_whiteView atIndex:0];*/
}

- (void)initNavigationBar
{
    
}

- (void)initFooterView
{
    float viewWidth = CGRectGetWidth(self.view.bounds);
    CGFloat footerHeight = (self.editType == FamilyMemberEditTypeNone) ? 0 : kFooterHeight;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frameHeight - footerHeight, viewWidth, footerHeight)];
    footer.backgroundColor = self.contentView.backgroundColor;
    footer.clipsToBounds = YES;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, kDefaultLineHeight)];
    lineView.backgroundColor = kDarkLineColor;
    [footer addSubview:lineView];
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.frame = CGRectMake(20, 10, viewWidth - 20 * 2, 44);
    [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_confirmButton setBackgroundImage:[[UIImage imageNamed:kButtonGreenNor] stretchableImageByCenter] forState:UIControlStateNormal];
//    [_confirmButton setBackgroundImage:[[UIImage imageNamed:kButtonGreenSel] stretchableImageByCenter] forState:UIControlStateHighlighted];
    [_confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:_confirmButton];
    
    [self.contentView addSubview:footer];
    
    _confirmButton.backgroundColor = kGreenColor;
    _confirmButton.layer.cornerRadius = 3;
    _confirmButton.clipsToBounds = YES;
}

- (void)showTopTipIfNeed
{
    NSString *addMemberTipHasShown = @"addMemberTipHasShown";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:addMemberTipHasShown]) {
        return;
    }
    
    UIView *topTipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frameWidth, 45)];
    topTipView.backgroundColor = kDarkGrayColor;
    [self.contentView addSubview:topTipView];
    
    CGFloat padding = 15.0;
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 5, topTipView.frameWidth - padding * 2, topTipView.frameHeight - 10)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.numberOfLines = 2;
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.text = @"为xx先生添加新成员，新成员可以使用xx先生的账户进行预约、就诊，成员病例在xx账户统一管理。";
    [topTipView addSubview:tipLabel];
    
    CGFloat btnWidth = 60.0;
    CGFloat btnHeight = 24.0;
    UIButton *tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tipButton.frame = CGRectMake(topTipView.frameWidth - padding - btnWidth, topTipView.frameHeight - btnHeight, btnWidth, btnHeight);
    tipButton.titleLabel.font = [UIFont systemFontOfSize:12];
    tipButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [tipButton setTitleColor:kBlueColor forState:UIControlStateNormal];
    [tipButton setTitle:@"不再提示" forState:UIControlStateNormal];
    [tipButton addTarget:self action:@selector(tipButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [topTipView addSubview:tipButton];
}

- (void)tipButtonPress:(UIButton *)btn
{
    [btn.superview removeFromSuperview];
    
    NSString *addMemberTipHasShown = @"addMemberTipHasShown";
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:addMemberTipHasShown];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)initTempMember
{
    self.tempMember = [[CUUser alloc] init];
    
    self.tempMember.name = self.user.name;
    self.tempMember.nickname = self.user.nickname;
    self.tempMember.profile = self.user.profile;
    self.tempMember.cellPhone = self.user.cellPhone;
    self.tempMember.gender = self.user.gender;
}

- (void)fillData
{
    if (!self.user) {
        self.user = [[CUUser alloc] init];
    }
    
    _nameField.text = self.user.name;
    //_nameField.placeholder = @"收货人姓名";
    
    
    //_nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入姓名" attributes:@{NSForegroundColorAttributeName: kTextGrayColor}];
    
    _phoneField.text = self.user.cellPhone;
    //_phoneField.placeholder = @"请输入您的手机号码";
    //_phoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName: kTextGrayColor}];
    
    if (self.user.age) {
        _ageField.text = [NSString stringWithFormat:@"%@", @(self.user.age)];
    }
    //_ageField.placeholder = @"请输入邮政编码";
    //_ageField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入邮政编码" attributes:@{NSForegroundColorAttributeName: kTextGrayColor}];
    
    _genderField.text = self.user.genderDesc;
}

- (BOOL)isInputValide
{
    BOOL isValide = YES;
    NSString *msg = nil;
    
    NSString *name = [_nameField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *phone = [_phoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSInteger nameLen = [name lengthOfBytesUsingEncoding:enc];
    
    if (name.length == 0) {
        isValide = NO;
        msg = @"请输入姓名";
    }
    else if (nameLen > kNameMaxLength) {
        isValide = NO;
        msg = [NSString stringWithFormat:@"输入姓名的长度不能大于%d位",kNameMaxLength / 2];
    }
    else if (phone.length == 0) {
        isValide = NO;
        msg = @"请输入手机号码";
    }
    
    if (!isValide) {
        //[[[iToast makeText:msg] setGravity:iToastGravityCenter] show];
    }
    
    return isValide;
}

- (BOOL)isTextfieldEditable
{
    if (self.editType == FamilyMemberEditTypeNone) {
        return NO;
    }
    
    return YES;
}

#pragma mark - textFiled/textvView delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //[self beginEdit];
    [self animateByView:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (void)textFieldEndEdit
{
    //[_phoneField becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = nil;
    if (range.length == 0) {
        newString = [textField.text stringByAppendingString:string];
    } else {
        NSString *headPart = [textField.text substringToIndex:range.location];
        NSString *tailPart = [textField.text substringFromIndex:range.location+range.length];
        newString = [NSString stringWithFormat:@"%@%@",headPart,tailPart];
        if (string.length) {
            newString = [newString stringByAppendingString:string];
        }
    }
    
    BOOL canInput = YES;
    
    if (textField == _nameField) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSInteger len = [newString lengthOfBytesUsingEncoding:enc];
        if (len >= kNameMaxLength) {
            canInput = NO;
            
            // 能删
            if (newString.length < _nameField.text.length) {
                canInput = YES;
            }
        }
    }
    else {
        int maxLength = INT_MAX;
        
        if (textField == _phoneField) {
            maxLength = kPhoneMaxLength;
        }
        
        if (newString.length <= maxLength) {
            canInput = canInput && YES;
        }else {
            if (string.length) {
                canInput = canInput && NO;
            }else {
                canInput = canInput && YES;
            }
        }
    }
    
    [self textField:textField didChange:newString];
    
    return canInput;
}

- (void)textField:(UITextField *)textField didChange:(NSString *)newString
{
    if (textField == _nameField) {
        self.tempMember.name = newString;
    }
    else if (textField == _phoneField) {
        self.tempMember.cellPhone = newString;
    }
    else if (textField == _ageField) {
        self.tempMember.age = [newString integerValue];
    }
    else if (textField == _genderField) {
        if ([newString isEqualToString:@"男"]) {
            self.tempMember.gender = CUUserGenderMale;
        }
        else if ([newString isEqualToString:@"女"]) {
            self.tempMember.gender = CUUserGenderFemale;
        }
    }
    [self changeSaveButtonState];
}

#pragma mark - save button state

- (BOOL)saveButtonEnable
{
    BOOL enable = NO;
    
    if (self.tempMember.name.length > 0
        || self.tempMember.cellPhone.length > 0) {
        
        if (self.editType == FamilyMemberEditTypeAdd) {
            enable = YES;
        }
        else {
            if (![self.tempMember.name isEqualToString:self.user.name]) {
                enable = YES;
            }
            
            if (![self.tempMember.cellPhone isEqualToString:self.user.cellPhone]) {
                enable = YES;
            }
        }
    }
    
    return enable;
}

- (void)changeSaveButtonState
{
    BOOL enable = [self saveButtonEnable];
    
}

#pragma mark - animate edit view

- (void)animateByView:(UIView *)view
{
    CGRect visibleRect = CGRectMake(0, self.navigationBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(_contentScrollView.frame) - 216 - self.navigationBarHeight);
    CGRect viewFrameInSelf = [view.superview convertRect:view.frame toView:self.view];
    
    float delY = CGRectGetMidY(viewFrameInSelf) - CGRectGetMidY(visibleRect);
    if (delY > 0) {
        NSLog(@"移动 %f",delY);
        CGPoint point = _contentScrollView.contentOffset;
        point.y += delY;
        
        CGFloat maxY = _contentScrollView.contentSize.height - _contentScrollView.frameHeight;
        if (point.y > maxY) {
            point.y = maxY;
        }
        [_contentScrollView setContentOffset:point animated:YES];
    }
}

- (void)beginEdit
{
    
}

- (void)endEdit
{
    [self.view endEditing:YES];
}

#pragma mark - action

- (void)pressToDeleteMember
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"确认删除该家庭成员？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = kAlertViewDelete;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertViewDelete) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            return;
        }
        
        [self deleteMember];
    }
    
    if (alertView.tag == kAlertViewSave) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            //[self backAction];
        }
        else {
            [self confirmAction];
        }
    }
}

- (void)confirmAction
{
    [self endEdit];
    
    if (![self isInputValide]) {
        return;
    }
     
    self.tempMember.name = _nameField.text;
    self.tempMember.cellPhone = _phoneField.text;
    
    self.tempMember.age = [_ageField.text integerValue];
    
    if ([_genderField.text isEqualToString:@"男"]) {
        self.tempMember.gender = CUUserGenderMale;
    }
    else if ([_genderField.text isEqualToString:@"女"]) {
        self.tempMember.gender = CUUserGenderFemale;
    }
    
    if (self.editType == FamilyMemberEditTypeModify) {
        [self editMemberWithData:self.tempMember];
    }
    else if (self.editType == FamilyMemberEditTypeAdd) {
        [self addMemberWithData:self.tempMember];
    }
}

- (void)editMemberWithData:(CUUser *)data
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[CUUserManager sharedInstance] editMember:data resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData * result) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (!result.hasError) {
            self.user = data;
            
            if (self.editBlock) {
                self.editBlock(self.user);
            }
            
            [TipHandler showHUDText:@"修改成功" state:TipStateSuccess inView:self.view];
            
            [self performSelector:@selector(backAction) withObject:nil afterDelay:0.5];
        }
        else {
            [TipHandler showHUDText:@"修改失败" state:TipStateFail inView:self.view];
        }
    } pageName:@"EditMember"];
}

- (void)addMemberWithData:(CUUser *)data
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[CUUserManager sharedInstance] addMember:data resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData * result) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (!result.hasError) {
            self.user = data;
            
            if (self.addBlock) {
                self.addBlock(self.user);
            }
            
            [TipHandler showHUDText:@"添加成功" state:TipStateSuccess inView:self.view];
            
            [self performSelector:@selector(backAction) withObject:nil afterDelay:0.5];
        }
        else {
            [TipHandler showHUDText:@"添加失败" state:TipStateFail inView:self.view];
        }
    } pageName:@"AddMember"];
}

- (void)deleteMember
{
    [self endEdit];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     
    [[CUUserManager sharedInstance] deleteMember:self.user resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData * result) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (!result.hasError) {
            if (self.deleteBlock) {
                self.deleteBlock(self.user);
            }
            
            [TipHandler showHUDText:@"删除成功" state:TipStateSuccess inView:self.view];
            
            [self performSelector:@selector(backAction) withObject:nil afterDelay:0.5];
        }
        else {
            [TipHandler showHUDText:@"删除失败" state:TipStateFail inView:self.view];
        }
    } pageName:@"DeleteMember"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UploadImage

- (void)clickToUploadImage
{
    [self showUploadActionSheet];
}

@end
