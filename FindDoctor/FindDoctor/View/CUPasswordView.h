//
//  CUPasswordView.h
//  FindDoctor
//
//  Created by Tom Zhang on 15/11/21.
//  Copyright © 2015年 li na. All rights reserved.
//

@protocol CUPasswordViewDelegate;

@interface CUPasswordView : UIView<UITextFieldDelegate>

@property (nonatomic,readonly) UITextField *oldPassField;
@property (nonatomic,readonly) UITextField *newPassField;
@property (nonatomic,readonly) UITextField *codeField;
@property (nonatomic,strong) UIButton *codeButton;
@property (nonatomic,weak) UIView *attachedView;
@property (nonatomic,weak) id<CUPasswordViewDelegate> delegate;
@property (nonatomic,assign) BOOL hasVerify;
@property (nonatomic,assign) BOOL hasOldPassword;


- (float)fHeight;

- (instancetype)initWithFrame:(CGRect)frame hasOldPassword:(BOOL)hasOldPassword hasVerify:(BOOL)hasVerify attachedView:(UIView *)attachedView;
- (instancetype)initWithFrame:(CGRect)frame hasOldPassword:(BOOL)hasOldPassword attachedView:(UIView *)attachedView;
- (instancetype)initWithFrame:(CGRect)frame hasVerify:(BOOL)hasVerify attachedView:(UIView *)attachedView;

- (NSString *)oldPassword;
- (NSString *)newPassword;
- (NSString *)codeStr;
- (NSInteger)code;

- (void)textFieldResignFirstResponder;

@end

@protocol CUPasswordViewDelegate <NSObject>

// didBegin or didEnd
- (void)passwordView:(CUPasswordView *)passwordView editingStateDidChanged:(BOOL)isEditing;

// did change text
- (void)passwordView:(CUPasswordView *)passwordView editingChanged:(BOOL)isChanged;

@end