//
//  OrderCreateController.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/24.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "OrderCreateController.h"
#import "OrderInfoView.h"

#import "Doctor.h"
#import "CreateOrderButtonView.h"
#import "TipHandler+HUD.h"
#import "CUOrderManager.h"
#import "OrderResultController.h"
#import "OrderConfirmController.h"
#import "UserDropdownMenuView.h"
#import "ImageUploadView.h"
#import "ImageBrowseController.h"
#import "CUUserManager.h"
#import "CULoginViewController.h"
#import "FamilyMemberDetailController.h"
#import "CUPickerView.h"

#import "AddFamilyMemberViewController.h"

#define kButtonViewHeight   ([CreateOrderButtonView defaultHeight])

@interface OrderCreateController () <UITextViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, ImageUploadViewDelegate>



@property (nonatomic, strong) NSMutableArray *imageArray;

@property NSInteger selectedMemberIndex;

@property (nonatomic, strong) CUPickerView *pickerView;
@property (nonatomic, strong) UserDropdownMenuView *menuView;

@end

@implementation OrderCreateController
{
    UIScrollView *_contentScrollView;
    UITextView   *_textView;
    
    ImageUploadView   *_uploadView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"约诊 %@医生", self.order.service.doctor.name];
    self.contentView.backgroundColor = kLightBlueColor;
    
//    self.order = [[CUOrder alloc] init];
//    self.order.service.doctor = self.doctor;
//    
//#warning 测试代码
//    self.memberArray = [NSMutableArray array];
//    for (NSInteger i = 0; i < 4; i ++) {
//        CUUser *user = [[CUUser alloc] init];
//        user.name = [NSString stringWithFormat:@"测试用户 %lu", i];
//        user.profile = @"http://www.91danji.com/attachments/201406/25/13/28lp1eh2g.jpg";
//        [self.memberArray addObjectSafely:user];
//    }
    
    [self initSubviews];
}

- (void)initSubviews
{
    CGFloat padding = 10.0;
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    _contentScrollView.frameHeight -= kButtonViewHeight;
    _contentScrollView.backgroundColor = self.contentView.backgroundColor;
    _contentScrollView.delegate = (id)self;
    [self.contentView addSubview:_contentScrollView];
    _contentScrollView.contentSize = CGSizeMake(_contentScrollView.frameWidth, _contentScrollView.frameHeight + 1);
    
    self.menuView = [[UserDropdownMenuView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [UserDropdownMenuView defaultHeight])];
    self.menuView.backgroundColor = self.contentView.backgroundColor;
    self.menuView.user = [self.memberArray objectAtIndexSafely:self.selectedMemberIndex];
    [_contentScrollView addSubview:self.menuView];
    
    [self.menuView update];
    
    __weak typeof(self) weakSelf = self;
    self.menuView.dropdownBlock = ^{
        [weakSelf showPickerIfNeed];
    };
    
    self.menuView.addBlock = ^{
        [weakSelf addMemberAction];
    };
    
    UIView *header = [self headerViewWithTitle:@"病情描述（可选）" originY:CGRectGetMaxY(self.menuView.frame) + padding];
    header.backgroundColor = _contentScrollView.backgroundColor;
    [_contentScrollView addSubview:header];
    
    UIImageView *textViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(header.frame), kScreenWidth - padding * 2, 126)];
    textViewBg.layer.borderColor = kDarkLineColor.CGColor;
    textViewBg.layer.borderWidth = kDefaultLineHeight;
    [_contentScrollView addSubview:textViewBg];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectInset(textViewBg.frame, 1, 1)];
    _textView.font = [UIFont systemFontOfSize:14];
    [_contentScrollView addSubview:_textView];
    
    header = [self headerViewWithTitle:@"病症照片（可选）" originY:CGRectGetMaxY(_textView.frame) + padding];
    header.backgroundColor = _contentScrollView.backgroundColor;
    [_contentScrollView addSubview:header];
    
    _uploadView = [[ImageUploadView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(header.frame), self.view.frameWidth, [ImageUploadView defaultHeight])];
    _uploadView.delegate = (id)self;
    _uploadView.backgroundColor = [UIColor clearColor];
    [_contentScrollView addSubview:_uploadView];
    
    [_uploadView reloadWithImages:self.imageArray];
    
    CGFloat maxY = CGRectGetMaxY([_contentScrollView.subviews.lastObject frame]) + 20;
    if (maxY > _contentScrollView.contentSize.height) {
        _contentScrollView.contentSize = CGSizeMake(_contentScrollView.frameWidth, maxY);
    }
    
    CreateOrderButtonView *_orderButtonView = [[CreateOrderButtonView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.contentView.bounds) - kButtonViewHeight, kScreenWidth, kButtonViewHeight)];
    _orderButtonView.showAmount = NO;
    _orderButtonView.amount = self.order.service.doctor.price;
    _orderButtonView.amountTitle = @"诊费";
    _orderButtonView.title = @"诊金支付";
    _orderButtonView.amountFont = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_orderButtonView];
    
    //__weak typeof(self) weakSelf = self;
    _orderButtonView.onClickAction = ^(void){
        self.order.service.disease = [[Disease alloc] init];
        
        if (self.imageArray.count) {
            [[CUUserManager sharedInstance] uploadImageArray:self.imageArray resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
                if (!result.hasError) {
                    if (![(NSNumber *)[result.responseObject valueForKey:@"err_code"] integerValue]) {
                        NSArray *dataList = [result.responseObject valueForKey:@"data"];
                        NSMutableArray *imageNumberArray = [[NSMutableArray alloc] init];
                        [dataList enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
                            NSString *string = [obj valueForKeyPath:@"ftppath"];
                            [imageNumberArray addObject:string];
                        }];
                        self.order.service.disease.imageURLArray = imageNumberArray;
                        self.order.service.disease.desc = _textView.text;
                        [weakSelf commitAction];
                    }
                    else
                    {
                        NSLog(@"====哦哟，出错了====");
                        [TipHandler showHUDText:@"图片上传失败，请重试" inView:self.contentView];
                    }
                }

                
            }pageName:@"OrderCreateController" progressBlock:nil];
        }
        else {
            self.order.service.disease.imageURLArray = [[NSMutableArray alloc] init];
            self.order.service.disease.desc = _textView.text;
            [weakSelf commitAction];
        }
    };
}

- (UIView *)headerViewWithTitle:(NSString *)title originY:(CGFloat)originY
{
    CGFloat headerHeight = 34.0;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, originY, kScreenWidth, headerHeight)];
    header.backgroundColor = _contentScrollView.backgroundColor;
    
    CGFloat linePadding = 0.0;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(linePadding, headerHeight / 2 - kDefaultLineHeight, header.frameWidth - linePadding * 2, kDefaultLineHeight)];
    lineView.backgroundColor = kLightLineColor;
    [header addSubview:lineView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = header.backgroundColor;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.textColor = UIColorFromHex(Color_Hex_NavBackground);
    [header addSubview:titleLabel];
    
    CGSize titleSize = [title sizeWithFont:titleLabel.font];
    titleLabel.frame = CGRectMake(0, 0, titleSize.width + 10, ceilf( titleSize.height));
    titleLabel.center = CGPointMake(header.frameWidth / 2, header.frameHeight / 2);
    
    return header;
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

- (void)backAction{
    __weak __block OrderCreateController *blockSelf = self;
    [[CUOrderManager sharedInstance] ReturnSelectOrderTimeWithDiagnosisID:blockSelf.order.diagnosisID resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        
    } pageName:@"OrderCreateController"];
    [super backAction];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - Private Action

- (void)loginAction
{
    CULoginViewController *loginVC = [[CULoginViewController alloc] init];
    [self.slideNavigationController pushViewController:loginVC animated:YES];
}

- (void)commitAction
{
    [self commitOrder];
}

- (void)commitOrder
{
#if LOCAL
#warning 测试代码
    srand((unsigned)time(NULL));
    self.order.orderId = [NSString stringWithFormat:@"%d", rand()];
    self.order.orderNumber = [NSString stringWithFormat:@"%d", rand()];
#else
    
#endif
//    if (self.order.diagnosisID != 0 && self.order.orderNumber) {
//        // 已创建订单，未支付
//        [self didCommitOrder];
//    }
//    else {
//        // 未创建订单
    
    self.order.service.patience = [self.memberArray objectAtIndex:self.selectedMemberIndex];
    Disease *disease = [[Disease alloc] init];
    disease.desc = _textView.text;
    
    self.order.orderStatus = ORDERSTATUS_UNPAID;
    
    [self showProgressView];
    __weak __block OrderCreateController *blockSelf = self;
    [[CUOrderManager sharedInstance] submitOrder:blockSelf.order user:nil resultBlock:^(SNHTTPRequestOperation * request,SNServerAPIResultData * result) {
        [self hideProgressView];
        if (!result.hasError && result.parsedModelObject) {
            OrderConfirmController *confirmVC = [[OrderConfirmController alloc] init];
            CUOrder *order = result.parsedModelObject;
            blockSelf.order.dealPrice = order.dealPrice;
            blockSelf.order.diagnosisTime = order.diagnosisTime;
            confirmVC.order = blockSelf.order;
            [blockSelf.slideNavigationController pushViewController:confirmVC animated:YES];
        }
        else {
            [TipHandler showSmallStringTipWithText:@"提交失败"];
        }
    } pageName:self.pageName];
//    }
}

- (void)createTempOrder
{
    CUUser *user = [[CUUser alloc] init];
    user.name = @"周振华";
    user.age = 26;
    user.cellPhone = @"13001963945";
    self.order.service.patience = user;
    //self.order.service.patience = self.menuView.user;
    
    Disease *disease = [[Disease alloc] init];
    disease.desc = @"头疼";
    self.order.service.disease = disease;
    
    self.order.service.dealPrice = 200;
}

- (void)didCommitOrder
{
//#warning 测试代码
//    [self createTempOrder];

    [self confirmOrder];
}

- (void)confirmOrder
{
    OrderConfirmController *confirmVC = [[OrderConfirmController alloc] init];
    confirmVC.order = self.order;
    [self.slideNavigationController pushViewController:confirmVC animated:YES];
}

- (void)enterResult:(OrderResult)orderResult
{
    SNSlideNavigationController *slide = self.slideNavigationController;
    UIViewController *vc = nil;
    for (UIViewController *controller in slide.viewControllers) {
        if ([controller isKindOfClass:NSClassFromString(@"SNTabViewController")]) {
            vc = controller;
            break;
        }
    }
    
    if (vc) {
        [slide popToViewController:vc animated:NO];
    }
    
    OrderResultController *resultVC = [[OrderResultController alloc] init];
    resultVC.orderResult = orderResult;
    resultVC.order = self.order;
    [slide pushViewController:resultVC animated:YES];
}

#pragma mark - UploadImageView Delegate

- (void)didClickToBrowseImageAtIndex:(int)index
{
    ImageBrowseController *browser = [[ImageBrowseController alloc] init];
    browser.imageArray = self.imageArray;
    browser.startIndex = index;
    browser.delegate = (id)self;
    [self.slideNavigationController pushViewController:browser animated:YES];
}

- (void)didClickToAddImage
{
    [self backTapAction];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@""
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: @"拍照" , @"从相册选择" ,nil];
    
    [actionSheet showFromRect:self.view.bounds inView:self.slideNavigationController.view animated:YES];
}

- (void)addMemberAction
{
    AddFamilyMemberViewController *memberVC = [[AddFamilyMemberViewController  alloc]init];
    memberVC.diagnosisID = self.order.diagnosisID;
    __weak __block OrderCreateController *blockSelf = self;
    memberVC.backBlock = ^(CUUser *user){
        [blockSelf.memberArray addObjectSafely:user];
        if (blockSelf.menuView.user == nil) {
            blockSelf.menuView.user = user;
            [blockSelf.menuView update];
        }
    };
    [self.slideNavigationController pushViewController:memberVC animated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if(buttonIndex == 0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *editedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        if (editedImage == nil) {
            editedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        }
        
        if (editedImage) {
            if (self.imageArray == nil) {
                self.imageArray = [NSMutableArray array];
            }
            
            [self.imageArray addObject:editedImage];
            [_uploadView reloadWithImages:self.imageArray];
        }
        
        [self recoveryStatusBar];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self recoveryStatusBar];
}

- (void)recoveryStatusBar
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)didClickToDeleteImageAtIndex:(int)index
{
    [_uploadView reloadWithImages:self.imageArray];
}

- (void)backTapAction
{
    [_textView resignFirstResponder];
}

#pragma mark - Picker

- (void)showPickerIfNeed
{
    if (self.memberArray.count == 0) {
        return;
    }
    
    if (self.pickerView == nil) {
        self.pickerView = [[CUPickerView alloc] initWithFrame:self.view.bounds];
        self.pickerView.delegate = (id)self;
    }
    
    self.pickerView.selectedIndex = self.selectedMemberIndex;
    [self.view addSubview:self.pickerView];
    
    __weak typeof(self) weakSelf = self;
    self.pickerView.confirmBlock = ^(NSInteger index) {
        weakSelf.selectedMemberIndex = index;
        weakSelf.menuView.user = [weakSelf.memberArray objectAtIndexSafely:index];
        [weakSelf.menuView update];
    };
    
    [self.pickerView update];
    [self.pickerView display];
}

- (NSInteger)numberOfRows
{
    return self.memberArray.count;
}

- (NSString *)titleForRowAtIndex:(NSInteger)index
{
    CUUser *user = [self.memberArray objectAtIndexSafely:index];
    return [user name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
