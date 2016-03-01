//
//  UserDetailController.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/19.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "UserDetailController.h"
#import "FamilyMemberListView.h"
#import "FamilyMemberDetailController.h"
#import "AddressListView.h"
#import "AddressDetailController.h"
#import "CUUserManager+FamilyMember.h"
#import "CUUserManager+Address.h"
#import "TipHandler+HUD.h"
#import "UserDetailController.h"
#import "UIBarButtonItem+CommenButton.h"
#import "UserDetailController+UploadAvartar.h"
#import "PasswordModifyController.h"

#define kDeleteMemeberAlertTag  100
#define kDeleteAddressAlertTag  101
#define kLogoutAlertTag         102

#define kFooterHeight     64.0

@interface UserDetailController ()

@property (nonatomic, strong) NSMutableArray *memberArray;
@property (nonatomic, strong) NSMutableArray *addressArray;

@property NSInteger selectedMemberIndex;
@property NSInteger selectedAddressIndex;

@property (nonatomic, strong) FamilyMemberListView *memberListView;
@property (nonatomic, strong) AddressListView *addressListView;

@end

@implementation UserDetailController
{
    UIScrollView *contentScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人设置";
    
    [self initData];
    [self initSubviews];
}

- (void)initData
{
    self.tempUser = [[CUUser alloc] init];
}

- (void)initSubviews
{
    contentScrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    contentScrollView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:contentScrollView];
    
    [self initHeader];
    [self initAddressListView];
    [self initMemberListView];
    
    CGFloat maxY = CGRectGetMaxY(self.memberListView.frame);
    if (maxY > contentScrollView.contentSize.height) {
        contentScrollView.contentSize = CGSizeMake(contentScrollView.contentSize.width, maxY);
    }
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem rightItemWithTitle:@"保存" target:self action:@selector(saveUser)];
}

- (void)initHeader
{
    self.header = [[UserDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frameWidth, [UserDetailHeaderView defaultHeight])];
    self.header.user = self.user;
    [contentScrollView addSubview:self.header];
    
    __weak typeof(self) wealSelf = self;
    self.header.clickAvatarBlock = ^{
        [wealSelf showUploadActionSheet];
    };
    
    self.header.clickPasswordBlock = ^{
        [wealSelf modifyPassword];
    };
}

- (void)initMemberListView
{
    self.memberArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 1; i ++) {
        CUUser *user = [[CUUser alloc] init];
        user.name = [NSString stringWithFormat:@"华佗 %lu", i];
        user.profile = @"http://www.91danji.com/attachments/201406/25/13/28lp1eh2g.jpg";
        [self.memberArray addObjectSafely:user];
    }
    
    self.memberListView = [[FamilyMemberListView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.addressListView.frame), self.contentView.frameWidth, [FamilyMemberListView defaultHeight])];
    [contentScrollView addSubview:self.memberListView];
    
    [self.memberListView reloadData:self.memberArray];
    
    __weak typeof(self) weakSelf = self;
    self.memberListView.deleteMemberBlock = ^(NSInteger index) {
        weakSelf.selectedMemberIndex = index;
        [weakSelf showDeleteMemeberAlert];
    };
    
    self.memberListView.addMemberBlock = ^{
        [weakSelf addMemberAction];
    };
}

- (void)initAddressListView
{
    self.addressArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 2; i ++) {
        Address *address = [[Address alloc] init];
        address.addressId = [NSString stringWithFormat:@"%@", @(i + 100)];
        address.address = @"四川省成都市一环路东一段电子科技大学沙河校区心愿5冻634";
        address.userName = @"郭晓伟";
        address.cellPhone = @"13588888888";
        [self.addressArray addObjectSafely:address];
    }
    
    self.addressListView = [[AddressListView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.header.frame), self.contentView.frameWidth, [AddressListView defaultHeight])];
    [contentScrollView addSubview:self.addressListView];
    
    [self.addressListView reloadData:self.addressArray];
    
    __weak typeof(self) weakSelf = self;
    self.addressListView.deleteBlock = ^(NSInteger index) {
        weakSelf.selectedAddressIndex = index;
        [weakSelf showDeleteAddressAlert];
    };
    
    self.addressListView.addBlock = ^{
        [weakSelf addAddressAction];
    };
}

- (void)initFooter
{
    float viewWidth = CGRectGetWidth(self.view.bounds);
    CGFloat footerHeight = kFooterHeight;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frameHeight - footerHeight, viewWidth, footerHeight)];
    footer.backgroundColor = self.contentView.backgroundColor;
    footer.clipsToBounds = YES;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, kDefaultLineHeight)];
    lineView.backgroundColor = kDarkLineColor;
    [footer addSubview:lineView];
    
    UIButton *_confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.frame = CGRectMake(20, 10, viewWidth - 20 * 2, 44);
    [_confirmButton setTitle:@"退出账号" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_confirmButton setBackgroundImage:[[UIImage imageNamed:kButtonGreenNor] stretchableImageByCenter] forState:UIControlStateNormal];
//    [_confirmButton setBackgroundImage:[[UIImage imageNamed:kButtonGreenSel] stretchableImageByCenter] forState:UIControlStateHighlighted];
    [_confirmButton addTarget:self action:@selector(showLogoutAlert) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:_confirmButton];
    
    [self.contentView addSubview:footer];
    
    _confirmButton.backgroundColor = kGreenColor;
    _confirmButton.layer.cornerRadius = 3;
    _confirmButton.clipsToBounds = YES;
}

#pragma mark - Private Action

- (void)showDeleteMemeberAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定要删除该家庭成员吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = kDeleteMemeberAlertTag;
    [alert show];
}

- (void)showDeleteAddressAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定要删除该快递地址？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = kDeleteAddressAlertTag;
    [alert show];
}

- (void)showLogoutAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定要退出当前账号？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = kLogoutAlertTag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        if (alertView.tag == kDeleteMemeberAlertTag) {
            [self deleteMemberAction];
        }
        else if (alertView.tag == kDeleteAddressAlertTag) {
            [self deleteAddressAction];
        }
        else if (alertView.tag == kLogoutAlertTag) {
            [self logoutAction];
        }
    }
}

- (void)addMemberAction
{
    FamilyMemberDetailController *memberVC = [[FamilyMemberDetailController alloc] init];
    memberVC.editType = FamilyMemberEditTypeAdd;
    [self.slideNavigationController pushViewController:memberVC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    memberVC.addBlock = ^(CUUser *user) {
        [weakSelf.memberArray addObjectSafely:user];
        
        [weakSelf.memberListView reloadData:self.memberArray];
    };
}

- (void)deleteMemberAction
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    CUUser *user = [self.memberArray objectAtIndex:self.selectedMemberIndex];
    [[CUUserManager sharedInstance] deleteMember:user resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData * result) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (!result.hasError) {
            [self.memberArray removeObjectAtIndex:self.selectedMemberIndex];
            self.selectedMemberIndex = 0;
            
            [self.memberListView reloadData:self.memberArray];
            
            [TipHandler showHUDText:@"删除成功" state:TipStateSuccess inView:self.view];
        }
        else {
            [TipHandler showHUDText:@"删除失败" state:TipStateFail inView:self.view];
        }
    } pageName:@"DeleteMember"];
}

- (void)addAddressAction
{
    AddressDetailController *addressVC = [[AddressDetailController alloc] init];
    addressVC.editType = AddressEditTypeAdd;
    [self.slideNavigationController pushViewController:addressVC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    addressVC.addBlock = ^(Address *address) {
        [weakSelf.addressArray addObjectSafely:address];
        
        [weakSelf.addressListView reloadData:self.addressArray];
    };
}

- (void)deleteAddressAction
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    Address *address = [self.addressArray objectAtIndex:self.selectedMemberIndex];
    [[CUUserManager sharedInstance] deleteAddress:address resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData * result) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (!result.hasError) {
            [self.addressArray removeObjectAtIndex:self.selectedAddressIndex];
            self.selectedAddressIndex = 0;
            
            [self.addressListView reloadData:self.addressArray];
            
            [TipHandler showHUDText:@"删除成功" state:TipStateSuccess inView:self.view];
        }
        else {
            [TipHandler showHUDText:@"删除失败" state:TipStateFail inView:self.view];
        }
    } pageName:@"DeleteAddress"];
}

- (void)saveUser
{
    
}

- (void)logoutAction
{
    
}

- (void)modifyPassword
{
    PasswordModifyController *passVC = [[PasswordModifyController alloc] init];
    [self.slideNavigationController pushViewController:passVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
