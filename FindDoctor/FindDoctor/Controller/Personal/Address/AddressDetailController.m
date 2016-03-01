//
//  AddressDetailController.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/15.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "AddressDetailController.h"
#import "TipHandler+HUD.h"
#import "CUUserManager+Address.h"
#import "UIImageView+WebCache.h"

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

@interface AddressDetailController () <UITextFieldDelegate, UITextViewDelegate>

@end

@implementation AddressDetailController
{
    UIScrollView      *_contentScrollView;
    
    UITextField       *_nameField;
    UITextField       *_phoneField;
    UITextField       *_proviceField;
    UITextField       *_cityField;
    UITextField       *_areaField;
    UITextField       *_addressField;
    
    UIView            *_whiteView;
    
    float              _contentMaxY;
    
    UIButton          *_setDefaultButton;
    UIButton          *_confirmButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(243, 244, 245);
    self.title = @"快递地址";
    if (self.editType == AddressEditTypeAdd) {
        self.title = @"添加快递地址";
    }
    
    [self initTempAddress];
    [self initSubviews];
    [self fillData];
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
    float originY = 30.0;
    float viewWidth = self.contentView.frameWidth;
    CGFloat viewHeight = self.contentView.frameHeight;
    CGFloat footerHeight = (self.editType == AddressEditTypeNone) ? 0 : kFooterHeight;
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight - footerHeight)];
    _contentScrollView.backgroundColor = self.view.backgroundColor;
    [self.contentView addSubview:_contentScrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [_contentScrollView addGestureRecognizer:tap];
    
    _nameField = [[UITextField alloc] init];
    _phoneField = [[UITextField alloc] init];
    _proviceField = [[UITextField alloc] init];
    _cityField = [[UITextField alloc] init];
    _areaField = [[UITextField alloc] init];
    _addressField = [[UITextField alloc] init];

    NSArray *titleArray = @[@"姓名",@"手机号",@"省份",@"城市",@"区(县)", @"详细地址"];
    NSArray *viewArray = @[_nameField,_phoneField,_proviceField,_cityField,_areaField,_addressField];
    
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
            labelRect.size.width += 20;
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
            fieldOriginX += 20;
        }
        UITextField *textField = [viewArray objectAtIndex:i];
        textField.frame = CGRectMake(fieldOriginX, originY, viewWidth - fieldOriginX - padding, cellHeight);
        textField.borderStyle = UITextBorderStyleNone;
        textField.textColor = kTextColor;
        textField.font = kTextFont;
        textField.delegate = self;
        textField.tag = i + 100;
        textField.returnKeyType = UIReturnKeyDone;
        textField.userInteractionEnabled = [self isTextfieldEditable];
        [_contentScrollView addSubview:textField];
        
        if (i > 2) {
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
    CGFloat footerHeight = (self.editType == AddressEditTypeNone) ? 0 : kFooterHeight;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frameHeight - footerHeight, viewWidth, footerHeight)];
    footer.backgroundColor = self.contentView.backgroundColor;
    footer.clipsToBounds = YES;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, kDefaultLineHeight)];
    lineView.backgroundColor = kDarkLineColor;
    [footer addSubview:lineView];
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.frame = CGRectMake(20, 10, viewWidth - 20 * 2, 44);
    [_confirmButton setTitle:@"保存" forState:UIControlStateNormal];
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

- (void)initTempAddress
{
    self.tempAddress = [[Address alloc] init];
    
    self.tempAddress.userName = self.address.userName;
    self.tempAddress.cellPhone = self.address.cellPhone;
    self.tempAddress.province = self.address.province;
    self.tempAddress.city = self.address.city;
    self.tempAddress.area = self.address.area;
    self.tempAddress.address = self.address.address;
}

- (void)fillData
{
    if (!self.address) {
        self.address = [[Address alloc] init];
    }
    
    _nameField.text = self.address.userName;
    //_nameField.placeholder = @"收货人姓名";
    
    _phoneField.text = self.address.cellPhone;
    
    //_nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入姓名" attributes:@{NSForegroundColorAttributeName: kTextGrayColor}];
    
    _proviceField.text = self.address.province;
    //_phoneField.placeholder = @"请输入您的手机号码";
    //_phoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName: kTextGrayColor}];
    
    _cityField.text = self.address.city;
    //_ageField.placeholder = @"请输入邮政编码";
    //_ageField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入邮政编码" attributes:@{NSForegroundColorAttributeName: kTextGrayColor}];
    
    _areaField.text = self.address.area;
    _addressField.text = self.address.address;
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
    if (self.editType == AddressEditTypeNone) {
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
        self.tempAddress.userName = newString;
    }
    else if (textField == _phoneField) {
        self.tempAddress.cellPhone = newString;
    }
    else if (textField == _proviceField) {
        self.tempAddress.province = newString;
    }
    else if (textField == _cityField) {
        self.tempAddress.city = newString;
    }
    else if (textField == _areaField) {
        self.tempAddress.area = newString;
    }
    else if (textField == _addressField) {
        self.tempAddress.address = newString;
    }
    
    [self changeSaveButtonState];
}

#pragma mark - save button state

- (BOOL)saveButtonEnable
{
    BOOL enable = NO;
    
    if (self.tempAddress.userName.length > 0
        || self.tempAddress.cellPhone.length > 0) {
        
        if (self.editType == AddressEditTypeAdd) {
            enable = YES;
        }
        else {
            if (![self.tempAddress.userName isEqualToString:self.address.userName]) {
                enable = YES;
            }
            
            if (![self.tempAddress.cellPhone isEqualToString:self.address.cellPhone]) {
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

- (void)pressToDeleteAddress
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
        
        [self deleteAddress];
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
    
    self.tempAddress.userName = _nameField.text;
    self.tempAddress.cellPhone = _phoneField.text;
    self.tempAddress.province = _proviceField.text;
    self.tempAddress.city = _cityField.text;
    self.tempAddress.area = _areaField.text;
    self.tempAddress.address = _addressField.text;
    
    if (self.editType == AddressEditTypeModify) {
        [self editAddressWithData:self.tempAddress];
    }
    else if (self.editType == AddressEditTypeAdd) {
        [self addAddressWithData:self.tempAddress];
    }
}

- (void)editAddressWithData:(Address *)data
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[CUUserManager sharedInstance] editAddress:data resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData * result) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (!result.hasError) {
            self.address = data;
            
            if (self.editBlock) {
                self.editBlock(self.address);
            }
            
            [TipHandler showHUDText:@"修改成功" state:TipStateSuccess inView:self.view];
            
            [self performSelector:@selector(backAction) withObject:nil afterDelay:0.5];
        }
        else {
            [TipHandler showHUDText:@"修改失败" state:TipStateFail inView:self.view];
        }
    } pageName:@"EditAddress"];
}

- (void)addAddressWithData:(Address *)data
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[CUUserManager sharedInstance] addAddress:data resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData * result) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (!result.hasError) {
            self.address = data;
            
            if (self.addBlock) {
                self.addBlock(self.address);
            }
            
            [TipHandler showHUDText:@"添加成功" state:TipStateSuccess inView:self.view];
            
            [self performSelector:@selector(backAction) withObject:nil afterDelay:0.5];
        }
        else {
            [TipHandler showHUDText:@"添加失败" state:TipStateFail inView:self.view];
        }
    } pageName:@"AddAddress"];
}

- (void)deleteAddress
{
    [self endEdit];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[CUUserManager sharedInstance] deleteAddress:self.address resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData * result) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (!result.hasError) {
            if (self.deleteBlock) {
                self.deleteBlock(self.address);
            }
            
            [TipHandler showHUDText:@"删除成功" state:TipStateSuccess inView:self.view];
            
            [self performSelector:@selector(backAction) withObject:nil afterDelay:0.5];
        }
        else {
            [TipHandler showHUDText:@"删除失败" state:TipStateFail inView:self.view];
        }
    } pageName:@"DeleteAddress"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

