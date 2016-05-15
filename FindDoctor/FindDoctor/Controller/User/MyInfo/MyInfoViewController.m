//
//  MyInfoViewController.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyInfoAvatarCell.h"
#import "MyInfoCell.h"
#import "CUUserManager.h"
#import "CUUser.h"
#import "TipHandler+HUD.h"
#import "UIImageView+WebCache.h"
#import "CUPickerView.h"
#import "MyInfoPickerCell.h"
#import "PersonalAvatarVC.h"


@interface MyInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate,CUPickerViewDelegate>
@property (strong,nonatomic)UITableView     * tableView;

@property (assign,nonatomic)BOOL              isEditing;

@property (strong,nonatomic)CUUser          * tempData;//不能直接传user 要传属性

@property (strong,nonatomic)UIButton        * editBtn;

@property (strong,nonatomic)CUPickerView    * pickerView;
@property (strong,nonatomic)NSArray         * sexArray;
@property (assign,nonatomic)NSInteger         selectedIndex;


@property (strong,nonatomic)MyInfoAvatarCell* myInfoAvatarCell;
@property (strong,nonatomic)UIImageView     * myAvatar;

@end

@implementation MyInfoViewController

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
    
    self.editBtn = [self addRightButtonItemWithTitle:@"编辑" action:@selector(editAndSaveAction)];
}

- (void)viewDidLoad {
    [self initData];
    
    [super viewDidLoad];
    
    self.title = @"我的信息";
    
    [self initSubViews];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)initData{
    
    self.sexArray = @[@"女",@"男"];
    self.selectedIndex = 0;
    
    self.isEditing = NO;
    
   self.tempData = [[CUUser alloc] init];
   self.tempData = [self copyForUser];
    
    self.myAvatar = [[UIImageView alloc] init];
    [self.myAvatar setImageWithURL:[NSURL URLWithString:[CUUserManager sharedInstance].user.icon] placeholderImage:[UIImage imageNamed:@"temp_icon_doctor.jpg"]];
}

- (CUUser *)copyForUser{
    CUUser * user = [[CUUser alloc] init];
    
    user.userId = [CUUserManager sharedInstance].user.userId;
    user.nickname = [CUUserManager sharedInstance].user.nickname.copy;
    user.name = [CUUserManager sharedInstance].user.name.copy;
    user.gender = [CUUserManager sharedInstance].user.gender;
    user.age = [CUUserManager sharedInstance].user.age;
    user.cellPhone = [CUUserManager sharedInstance].user.cellPhone.copy;
    
    return user;
}

- (void)initSubViews{
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [self.contentView addGestureRecognizer:tap];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = kblueLineColor;
    self.tableView.backgroundColor = kCommonBackgroundColor;
    [self.contentView addSubview:self.tableView];
}

- (void)endEdit{
    [self.view endEditing:YES];
}

#pragma mark - tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 1:
        {
            return 2;
        }
            break;
        case 2:
        {
            return 4;
        }
            break;
            
        default:{
            return 1;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [MyInfoAvatarCell cellDefaultHeight];
    }else{
        return [MyInfoCell cellDefaultHeight];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        self.myInfoAvatarCell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"MyInfoAvatarCell%ld%ld",(long)indexPath.section,(long)indexPath.row]];
        if (!self.myInfoAvatarCell) {
            self.myInfoAvatarCell = [[MyInfoAvatarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"MyInfoAvatarCell%ld%ld",(long)indexPath.section,(long)indexPath.row]];
        }
        self.myInfoAvatarCell.label.text = @"头像";
        
        __weak __block typeof(self)weakSelf = self;
        self.myInfoAvatarCell.clickMyInfoAvatarCellBlock = ^{
            
            PersonalAvatarVC * vc = [[PersonalAvatarVC alloc] initWithPageName:@"PersonalAvatarVC"];
            __strong typeof(weakSelf)strongSelf = weakSelf;
            __weak __block typeof(strongSelf)subWeakSelf = strongSelf;
            vc.uploadAvatarSuccessBlock = ^(UIImage * image){
                subWeakSelf.myAvatar.image = image;
                [subWeakSelf.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:0] withRowAnimation:NO];
            };
            [subWeakSelf.slideNavigationController pushViewController:vc animated:YES];
        };
        self.myInfoAvatarCell.avatar.image = self.myAvatar.image;
        
        self.myInfoAvatarCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return self.myInfoAvatarCell;
    }else if (indexPath.section == 2 && indexPath.row == 1){
        MyInfoPickerCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"MyInfoPickerCell%ld%ld",(long)indexPath.section,(long)indexPath.row]];
        if (!cell) {
            cell = [[MyInfoPickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"MyInfoPickerCell%ld%ld",(long)indexPath.section,(long)indexPath.row]];
        }
        cell.label.text = @"性别";
        
        [cell.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.btn addTarget:self action:@selector(chooseSexAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn setTitle:[self.sexArray objectAtIndexSafely:self.selectedIndex] forState:UIControlStateNormal];
        cell.btn.contentHorizontalAlignment = NSTextAlignmentRight;
        
        if (self.isEditing == YES) {
            [cell.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cell.btn.userInteractionEnabled = YES;
        }else{
            [cell.btn setTitleColor:kGrayTextColor forState:UIControlStateNormal];
            cell.btn.userInteractionEnabled = NO;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        MyInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"MyInfoCell%ld%ld",(long)indexPath.section,(long)indexPath.row]];
        if (!cell) {
            cell = [[MyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"MyInfoCell%ld%ld",(long)indexPath.section,(long)indexPath.row]];
        }
        //10010 10011
        //10020 10022 10023
        cell.textField.tag = [[NSString stringWithFormat:@"100%ld%ld",(long)indexPath.section,(long)indexPath.row] integerValue];
        cell.textField.delegate = self;
        if (self.isEditing == YES) {
            cell.textField.textColor = [UIColor blackColor];
            cell.textField.userInteractionEnabled = YES;
        }else{
            cell.textField.textColor = kGrayTextColor;
            cell.textField.userInteractionEnabled = NO;
        }
        
        switch (cell.textField.tag) {
            case 10010:
            {
                cell.label.text = @"优医ID";
                cell.textField.text = [NSString stringWithFormat:@"%ld",(long)self.tempData.userId];
                cell.textField.textColor = kGrayTextColor;
                cell.textField.tintColor = [UIColor clearColor];
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uyiIDAction)];
                [cell.textField addGestureRecognizer:tap];
            }
                break;
            case 10011:
            {
                cell.label.text = @"昵称";
                cell.textField.text = [NSString stringWithFormat:@"%@",self.tempData.nickname];
            }
                break;
            case 10020:
            {
                cell.label.text = @"姓名";
                cell.textField.text = [NSString stringWithFormat:@"%@",self.tempData.name];
            }
                break;
            case 10022:
            {
                cell.label.text = @"年龄";
                cell.textField.text = [NSString stringWithFormat:@"%ld",(long)self.tempData.age];
            }
                break;
            case 10023:
            {
                cell.label.text = @"电话";
                cell.textField.text = [NSString stringWithFormat:@"%@",self.tempData.cellPhone];
            }
                break;
            default:
                break;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        if (indexPath.section == 0) {
            PersonalAvatarVC * vc = [[PersonalAvatarVC alloc] initWithPageName:@"PersonalAvatarVC"];
            __weak __block typeof(self)weakSelf = self;
            vc.uploadAvatarSuccessBlock = ^(UIImage * image){
                weakSelf.myAvatar.image = image;
                [weakSelf.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:0] withRowAnimation:NO];
            };
            [self.slideNavigationController pushViewController:vc animated:YES];
        }
    
}

#pragma mark textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //优医ID
    if (textField.tag == 10010) {
        return NO;
    }
    return YES;


}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self textFieldChange:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self textFieldChange:textField];
    return YES;
}
//10010 10011
//10020 10021 10022 10023
- (void)textFieldChange:(UITextField *)textField{
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    switch (textField.tag) {
        //昵称
        case 10011:
        {
            self.tempData.nickname = textField.text;
        }
            break;
        //姓名
        case 10020:
        {
            self.tempData.name = textField.text;
        }
            break;
        //性别
        case 10021:
        {
            self.tempData.gender = [textField.text integerValue];
        }
            break;
        //年龄
        case 10022:
        {
            self.tempData.age = [textField.text integerValue];
        }
            break;
        //电话
        case 10023:
        {
            self.tempData.cellPhone = textField.text;
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //电话
    if (textField.tag == 10023) {
        if ([textField.text length] > 10) {
            return NO;
        }
    }else if (textField.tag == 10010){
        return NO;
    }
    return YES;
}

#pragma mark - postRequest

//14100 修改个人资料
- (void)postRequestUpdateyUserInfo{
    [self showProgressView];
    __weak __block typeof(self)weakSelf = self;
    [[CUUserManager sharedInstance] updateUserInfo:self.tempData resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        [weakSelf hideProgressView];
        if (!result.hasError) {
            NSNumber * errorCode = (NSNumber *)[result.responseObject objectForKeySafely:@"errorCode"];
            
            if (![errorCode integerValue]) {
                [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
                self.isEditing = !self.isEditing;
                [self.tableView reloadData];
                [TipHandler showTipOnlyTextWithNsstring:@"修改成功"];
            }else{
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject stringForKeySafely:@"message"]];
            }
        }else{
            [TipHandler showTipOnlyTextWithNsstring:@"网络连接错误"];
        }
    } pageName:@"MyInfoViewController"];
}

#pragma mark - Picker

- (void)showPickerIfNeed
{
    [self.contentView endEditing:YES];
    if (self.sexArray.count == 0) {
        return;
    }
    
    if (self.pickerView == nil) {
        self.pickerView = [[CUPickerView alloc] initWithFrame:self.view.bounds];
        self.pickerView.delegate = (id)self;
    }
    
    self.pickerView.selectedIndex = self.selectedIndex;
    [self.view addSubview:self.pickerView];
    
    __weak typeof(self) weakSelf = self;
    self.pickerView.confirmBlock = ^(NSInteger index) {
        weakSelf.selectedIndex = index;
        
        if (weakSelf.selectedIndex == CUUserGenderFemale) {
            weakSelf.tempData.gender = CUUserGenderFemale;
        }else{
            weakSelf.tempData.gender = CUUserGenderMale;
        }
        
        [weakSelf.tableView reloadData];
    };
    
    [self.pickerView update];
    [self.pickerView display];
}

- (NSInteger)numberOfRows
{
    return self.sexArray.count;
}

- (NSString *)titleForRowAtIndex:(NSInteger)index
{
    NSString * sex = [self.sexArray objectAtIndexSafely:index];
    return sex;
}


#pragma mark - Action

- (void)chooseSexAction{
    [self showPickerIfNeed];
}

- (void)editAndSaveAction{
    
    if (self.isEditing == YES) {

        [self postRequestUpdateyUserInfo];
        
    }else{
        [self.editBtn setTitle:@"保存" forState:UIControlStateNormal];
        self.isEditing = !self.isEditing;
        [self.tableView reloadData];
    }

}

- (void)uyiIDAction{
    [TipHandler showTipOnlyTextWithNsstring:@"优医ID是系统给您自动分配的ID号，无法更改"];
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
