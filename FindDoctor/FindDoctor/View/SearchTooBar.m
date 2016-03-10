//
//  SearchTooBar.m
//  HuiYangChe
//
//  Created by yutao on 14-9-22.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import "SearchTooBar.h"
#import "CUUIContant.h"
#import "TipHandler+HUD.h"
#import "UIImage+Color.h"

@interface SearchTooBar()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *textField;
@end

@implementation SearchTooBar
{
    UIButton *leftButton;
    UIButton *rightButton;
    UIImageView *textFieldBack;
}

- (void)dealloc
{
    [[UITextField appearance] setTintColor:UIColorFromRGB(20,111,225)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *backgroundImage = [UIImage createImageWithColor:UIColorFromHex(Color_Hex_NavBackground)];//[UIImage imageNamed:@"navbar_background"];
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:frame];
        [backImageView setImage:[backgroundImage stretchableImageByWidthCenter]];
        [self addSubview:backImageView];
        
        CGFloat leftButtonWidth = 40.0;
        CGFloat leftButtonHeight = 45.0;
        leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.backgroundColor = [UIColor clearColor];
        leftButton.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - leftButtonHeight, leftButtonWidth, leftButtonHeight);
        [leftButton setImage:[UIImage imageNamed:@"navbar_close_button"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftButton];
        
        float textFieldBgOriginX = 40.0;
        float textFieldBgHeight = 30.0;
        float textFieldBgOriginY = CGRectGetHeight(self.bounds) - textFieldBgHeight - 7;
        float textFieldBgWidth = kScreenWidth - textFieldBgOriginX - 10;
        
        textFieldBack = [[UIImageView alloc] initWithFrame:CGRectMake(textFieldBgOriginX, textFieldBgOriginY, textFieldBgWidth, textFieldBgHeight)];
        textFieldBack.image = [[UIImage imageNamed:@"comlaintip_background"] stretchableImageByCenter];
        textFieldBack.backgroundColor = [UIColor whiteColor];//UIColorFromRGB(90, 125, 220);
        textFieldBack.userInteractionEnabled = YES;
        [self addSubview:textFieldBack];
        
        CGFloat textFiledHeight = textFieldBgHeight;
        CGFloat textFiledOriginX = 35.0;
        CGFloat textFiledWidth = textFieldBack.frameWidth - textFiledOriginX - 10;
        CGFloat textFiledOriginY = (textFieldBgHeight - textFiledHeight) / 2;
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(textFiledOriginX, textFiledOriginY, textFiledWidth, textFiledHeight)];
        _textField.frameY = _textField.frameY + 2;
//        textField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigationbar_search_icon_search@2x"]];
//        textField.leftViewMode = UITextFieldViewModeAlways;
        [[UITextField appearance] setTintColor:UIColorFromHex(0x84d2fa)];
//        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.returnKeyType = UIReturnKeySearch;
//        _textField.textColor = [UIColor whiteColor];
        [_textField addTarget:self action:@selector(searchFieldEditChange:) forControlEvents:UIControlEventEditingChanged];
        _textField.delegate = self;
        [textFieldBack addSubview:_textField];
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textFiledHeight, textFiledHeight)];
        _textField.rightView = rightView;
        _textField.rightViewMode = UITextFieldViewModeAlways;
        
        _textField.rightView.hidden = YES;
        
        CGFloat cancelButtonSize = textFiledHeight;
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, -2, cancelButtonSize, cancelButtonSize);
        [cancelButton setImage:[UIImage imageNamed:@"search_bar_cancel"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(clearText) forControlEvents:UIControlEventTouchUpInside];
        [rightView addSubview:cancelButton];
        
        CGFloat leftImageSize = 15.0;
        UIImageView *leftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigationbar_search_icon_search"]];
        leftImage.frame = CGRectMake(10, (textFieldBgHeight - leftImageSize) / 2, leftImageSize, leftImageSize);
        [textFieldBack addSubview:leftImage];
        
        CGFloat rightButtonWidth = 40.0;
        CGFloat rightButtonHeight = 45.0;
        rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.backgroundColor = [UIColor clearColor];
        rightButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - rightButtonWidth, CGRectGetHeight(self.bounds) - leftButtonHeight, rightButtonWidth, rightButtonHeight);
        rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [rightButton setTitle:@"取消" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightButton];
        rightButton.hidden = YES;
    }
    return self;
}

- (void)setShowCancelButton:(BOOL)showCancelButton
{
    if (showCancelButton) {
        leftButton.hidden = YES;
        rightButton.hidden = NO;
        
        textFieldBack.frameX = 10;
    }
    else {
        leftButton.hidden = NO;
        rightButton.hidden = YES;
        
        textFieldBack.frameX = leftButton.frameWidth;
    }
}

- (void)backAction
{
    [self cancelAction];
}

- (void)cancelAction
{
    [_textField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(cancelClick)]) {
        [self.delegate cancelClick];
    }
}

- (void)searchFieldEditChange:(UITextField *)textField
{
    if (textField.text.length == 0) {
        _textField.rightView.hidden = YES;
    }
    else {
        _textField.rightView.hidden = NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(searchStringDidChange:)]) {
        [self.delegate searchStringDidChange:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0) {
        [TipHandler showSmallStringTipWithText:@"请输入搜索内容"];
        return NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(searchClickWithString:)]) {
        [self.delegate searchClickWithString:textField.text];
    }
    [_textField resignFirstResponder];
    return YES;
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _textField.placeholder = placeHolder;

    if (placeHolder.length) {
//        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    }
}

- (void)becomeFirstResponder
{
    [_textField becomeFirstResponder];
}

- (void)resignFirstResponder
{
    [_textField resignFirstResponder];
}

- (void)clearText
{
    _textField.text = nil;
    [self searchFieldEditChange:_textField];
}

@end
