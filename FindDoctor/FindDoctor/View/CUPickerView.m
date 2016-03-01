//
//  CUPickerView.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/23.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CUPickerView.h"
#import "TipHandler+HUD.h"

@interface CUPickerView ()

@property (nonatomic, strong) UIButton *backView;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation CUPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initView];
    }
    
    return self;
}

- (void)initView
{
    self.backgroundColor = [UIColor clearColor];
    
    self.backView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backView.frame = self.bounds;
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.0f;
    [self addSubview:self.backView];
    
    self.alertView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.alertView];
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.delegate = (id)self;
    self.pickerView.dataSource = (id)self;
    [self.alertView addSubview:self.pickerView];
    
    CGFloat toolBarHeight = 44.0;
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), toolBarHeight)];
    UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickCancel)];
    cancelButton.tintColor = kDarkGrayColor;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickDone)];
    doneButton.tintColor = kDarkBlueColor;
    NSArray *array = [[NSArray alloc] initWithObjects:cancelButton, fixedButton, doneButton, nil];
    [toolBar setItems:array];
    [self.alertView addSubview:toolBar];
    
    self.alertView.frame = CGRectMake(0, CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), CGRectGetMaxY(self.pickerView.frame));
    
    self.pickerView.frame = CGRectMake(0, toolBarHeight, CGRectGetWidth(self.frame), CGRectGetHeight(self.pickerView.frame));
}

- (void)update
{
    [self.pickerView reloadAllComponents];
    
    if (self.selectedIndex) {
        [self.pickerView selectRow:self.selectedIndex inComponent:0 animated:NO];
    }
}

#pragma mark - picker datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([self.delegate respondsToSelector:@selector(numberOfRows)]) {
        return [self.delegate numberOfRows];
    }
    
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth / 2, 40)];
        view.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:view.bounds];
        titleLabel.tag = 11;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:titleLabel];
    }
    
    UILabel *titleLabel = (UILabel *)[view viewWithTag:11];
    
    if ([self.delegate respondsToSelector:@selector(titleForRowAtIndex:)]) {
        titleLabel.text = [self.delegate titleForRowAtIndex:row];
    }
    
    return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedIndex = row;
}

#pragma mark - action
- (void)clickCancel
{
    [self dismiss];
}

- (void)clickDone
{
    if (self.confirmBlock) {
        self.confirmBlock(self.selectedIndex);
    }
    
    [self dismiss];
}

#pragma mark - func
- (void)display
{
    self.alertView.frame = CGRectMake(0, CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), CGRectGetMaxY(self.pickerView.frame));
    
    [UIView animateWithDuration:0.3 animations:^(void){
        self.alertView.frame = CGRectMake(0, CGRectGetMaxY(self.frame) - CGRectGetMaxY(self.pickerView.frame), CGRectGetWidth(self.frame), CGRectGetMaxY(self.pickerView.frame));
        self.backView.alpha = 0.4f;
    }completion:^(BOOL finished){
        
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^(void){
        self.alertView.frame = CGRectMake(0, CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), CGRectGetMaxY(self.pickerView.frame));
        self.backView.alpha = 0.0f;
    }completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

@end

