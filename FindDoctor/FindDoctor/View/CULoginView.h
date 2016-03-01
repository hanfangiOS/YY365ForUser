//
//  CULoginView.h
//  CollegeUnion
//
//  Created by li na on 15/3/13.
//  Copyright (c) 2015年 li na. All rights reserved.
//

@protocol CULoginViewDelegate;

@interface CULoginView : UIView<UITextFieldDelegate>

@property (nonatomic,readonly) UITextField *userField;
@property (nonatomic,readonly) UITextField *codeField;
@property (nonatomic,readonly) UITextField *passField;
@property (nonatomic,strong) UIButton *codeButton;
@property (nonatomic,weak) UIView *attachedView;
@property (nonatomic,weak) id<CULoginViewDelegate> delegate;
@property (nonatomic,assign) BOOL hasVerify;
@property (nonatomic,assign) BOOL hasPassword;

@property (nonatomic,strong) UIImage *userImage;
@property (nonatomic,strong) UIImage *codeImage;
@property (nonatomic,strong) UIImage *passImage;

- (float)fHeight;

- (instancetype)initWithFrame:(CGRect)frame hasVerify:(BOOL)hasVerify attachedView:(UIView *)attachedView;

- (instancetype)initWithFrame:(CGRect)frame hasVerify:(BOOL)hasVerify hasPassword:(BOOL)hasPassword attachedView:(UIView *)attachedView;

- (NSString *)userName;
- (NSString *)password;
- (NSString *)code;
- (NSString *)codetoken;
- (NSString *)codeStr;

- (void)textFieldResignFirstResponder;

@end

@protocol CULoginViewDelegate <NSObject>

// didBegin or didEnd
- (void)loginView:(CULoginView *)loginView editingStateDidChanged:(BOOL)isEditing;

// did change text
- (void)loginView:(CULoginView *)loginView editingChanged:(BOOL)isChanged;

@end
