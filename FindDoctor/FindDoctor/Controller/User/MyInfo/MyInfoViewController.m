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



@interface MyInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CUPickerViewDelegate>
{
    UIActionSheet *myActionSheet;
    MyInfoAvatarCell * myInfoAvatarCell;
}
@property (strong,nonatomic)UITableView     * tableView;

@property (assign,nonatomic)BOOL              isEditing;

@property (strong,nonatomic)CUUser          * tempData;//不能直接传user 要传属性

@property (strong,nonatomic)UIButton        * editBtn;

@property (strong,nonatomic)CUPickerView    * pickerView;
@property (strong,nonatomic)NSArray         * sexArray;
@property (assign,nonatomic)NSInteger         selectedIndex;

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

- (void)initData{
    
    self.sexArray = @[@"女",@"男"];
    self.selectedIndex = 0;
    
    self.isEditing = NO;
    
   self.tempData = [[CUUser alloc] init];
   self.tempData = [self copyForUser];
}

- (CUUser *)copyForUser{
    CUUser * user = [[CUUser alloc] init];
    
    user.userId = [CUUserManager sharedInstance].user.userId;
    user.nickName = [CUUserManager sharedInstance].user.nickName.copy;
    user.name = [CUUserManager sharedInstance].user.name.copy;
    user.gender = [CUUserManager sharedInstance].user.gender;
    user.age = [CUUserManager sharedInstance].user.age;
    user.cellPhone = [CUUserManager sharedInstance].user.token.copy;
    
    return user;
}

- (void)initSubViews{
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [self.contentView addGestureRecognizer:tap];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
        myInfoAvatarCell = [[MyInfoAvatarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyInfoAvatarCell"];
        myInfoAvatarCell.label.text = @"头像";
        [myInfoAvatarCell.avatar setImageWithURL:[NSURL URLWithString:[CUUserManager sharedInstance].user.icon]];
        
        return myInfoAvatarCell;
    }else if (indexPath.section == 2 && indexPath.row == 1){
        MyInfoPickerCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"MyInfoPickerCell%d%d",indexPath.section,indexPath.row]];
        if (!cell) {
            cell = [[MyInfoPickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"MyInfoPickerCell%d%d",indexPath.section,indexPath.row]];
        }
        cell.label.text = @"性别";
        
        [cell.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.btn addTarget:self action:@selector(chooseSexAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn setTitle:[self.sexArray objectAtIndexSafely:self.selectedIndex] forState:UIControlStateNormal];
        cell.btn.contentHorizontalAlignment = NSTextAlignmentRight;
        
        if (self.isEditing == YES) {
            cell.btn.backgroundColor = [UIColor redColor];
            cell.btn.userInteractionEnabled = YES;
        }else{
            cell.btn.backgroundColor = [UIColor clearColor];
            cell.btn.userInteractionEnabled = NO;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        MyInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"MyInfoAvatarCell%d%d",indexPath.section,indexPath.row]];
        if (!cell) {
            cell = [[MyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"MyInfoCell%d%d",indexPath.section,indexPath.row]];
        }
        //10010 10011
        //10020 10022 10023
        cell.textField.tag = [[NSString stringWithFormat:@"100%d%d",indexPath.section,indexPath.row] integerValue];
        cell.textField.delegate = self;
        if (self.isEditing == YES) {
            cell.textField.backgroundColor = [UIColor redColor];
            cell.textField.userInteractionEnabled = YES;
        }else{
            cell.textField.backgroundColor = [UIColor clearColor];
            cell.textField.userInteractionEnabled = NO;
        }
        
        switch (cell.textField.tag) {
            case 10010:
            {
                cell.label.text = @"优医ID";
                cell.textField.text = [NSString stringWithFormat:@"%d",self.tempData.userId];
            }
                break;
            case 10011:
            {
                cell.label.text = @"昵称";
                cell.textField.text = [NSString stringWithFormat:@"%@",self.tempData.nickName];
            }
                break;
            case 10020:
            {
                cell.label.text = @"姓名";
                cell.textField.text = [NSString stringWithFormat:@"%@",self.tempData.name];
            }
                break;
//            case 10021:
//            {
//                cell.label.text = @"性别";
//                if (self.tempData.gender == CUUserGenderMale) {
//                    cell.textField.text = @"男";
//                }else{
//                    cell.textField.text = @"女";
//                }
//            }
                break;
            case 10022:
            {
                cell.label.text = @"年龄";
                cell.textField.text = [NSString stringWithFormat:@"%d",self.tempData.age];
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
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isEditing) {
        if (indexPath.section == 0) {
            [self openMenu];
        }
    }
}

#pragma mark textFieldDelegate

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
        case 10010:
        {
            self.tempData.userId = [textField.text integerValue];
        }
            break;
        case 10011:
        {
            self.tempData.nickName = textField.text;
        }
            break;
        case 10020:
        {
            self.tempData.name = textField.text;
        }
            break;
        case 10021:
        {
            self.tempData.gender = [textField.text integerValue];
        }
            break;
        case 10022:
        {
            self.tempData.age = [textField.text integerValue];
        }
            break;
        case 10023:
        {
            self.tempData.cellPhone = textField.text;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark avatarEdit
-(void)openMenu
{
    //在这里呼出下方菜单按钮项
    //    NSLog(@"sender.tag = %d",sender.tag);
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    //    myActionSheet.tag = sender.tag;
    
    [myActionSheet showInView:self.view];
}




- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == myActionSheet.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self takePhoto:actionSheet];
            break;
            
        case 1:  //打开本地相册
            [self LocalPhoto:actionSheet];
            break;
    }
}


//开始拍照
-(void)takePhoto:(UIActionSheet *)sender
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        picker.view.tag = sender.tag;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto:(UIActionSheet *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //    NSLog(@"info:%@\ntag = %d",info,picker.view.tag);
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 0.3);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        [picker removeFromParentViewController];
        
        UIImage *compressedImage = [UIImage imageWithData:data];
        myInfoAvatarCell.avatar.image = compressedImage;
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - postRequest

//获取个人信息
- (void)postRequestGetUserInfo{
    __weak __block typeof(self)weakSelf = self;
    [[CUUserManager sharedInstance] getUserInfo:[CUUserManager sharedInstance].user.token resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        [weakSelf hideProgressView];
        if (!result.hasError) {
            NSInteger errorCode = (NSInteger)[result.responseObject objectForKeySafely:@"errorCode"];
            
            if (errorCode != -1) {
                self.tempData = [self copyForUser];
                [self.tableView reloadData];
            }else{
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject stringForKeySafely:@"message"]];
            }
        }else{
            [TipHandler showTipOnlyTextWithNsstring:@"网络连接错误"];
        }
    }];
}

//14100 修改个人资料
- (void)postRequestUpdateyUserInfo{
    [self showProgressView];
    __weak __block typeof(self)weakSelf = self;
    [[CUUserManager sharedInstance] updateUserInfo:self.tempData resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        
        if (!result.hasError) {
            NSNumber * errorCode = (NSNumber *)[result.responseObject objectForKeySafely:@"errorCode"];
            
            if ([errorCode integerValue] != -1) {
                [weakSelf postRequestGetUserInfo];
            }else{
                [weakSelf hideProgressView];
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
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self postRequestUpdateyUserInfo];
        
    }else{
        [self.editBtn setTitle:@"保存" forState:UIControlStateNormal];
        
    }
    self.isEditing = !self.isEditing;
    [self.tableView reloadData];
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
