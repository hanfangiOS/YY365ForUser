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

@interface MyInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIActionSheet *myActionSheet;
    MyInfoAvatarCell * myInfoAvatarCell;
}
@property (strong,nonatomic)UITableView     * tableView;

@property (assign,nonatomic)BOOL              isEditing;
@property (assign,nonatomic)NSDictionary    * dataDict;

@end

@implementation MyInfoViewController

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
    [self addRightButtonItemWithImage:[UIImage imageNamed:@"myAccountBigButtonImage"] action:@selector(edit)];
}

- (void)edit{
    self.isEditing = !self.isEditing;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的信息";
    
    [self initData];
    
    [self initSubViews];

}

- (void)initData{
    self.dataDict = @{@"avatar":@"",
                      @"ID":@"",
                      @"nickName":@"",
                      @"name":@"",
                      @"sex":@"",
                      @"age":@"",
                      @"phone":@""};
}

- (void)initSubViews{
    self.tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.contentView addSubview:self.tableView];
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
        return myInfoAvatarCell;
    }else{
        MyInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"MyInfoAvatarCell%d%d",indexPath.section,indexPath.row]];
        if (!cell) {
            cell = [[MyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"MyInfoAvatarCell%d%d",indexPath.section,indexPath.row]];
        }
        //10010 10011
        //10020 10021 10022 10023
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
                cell.textField.text = [NSString stringWithFormat:@"%d",[CUUserManager sharedInstance].user.userId];
            }
                break;
            case 10011:
            {
                cell.label.text = @"昵称";
                cell.textField.text = [NSString stringWithFormat:@"%@",[CUUserManager sharedInstance].user.nickName];
            }
                break;
            case 10020:
            {
                cell.label.text = @"姓名";
                cell.textField.text = [NSString stringWithFormat:@"%@",[CUUserManager sharedInstance].user.name];
            }
                break;
            case 10021:
            {
                cell.label.text = @"性别";
                if ([CUUserManager sharedInstance].user.gender == CUUserGenderMale) {
                    cell.textField.text = @"男";
                }else{
                    cell.textField.text = @"女";
                }
            }
                break;
            case 10022:
            {
                cell.label.text = @"年龄";
                cell.textField.text = [NSString stringWithFormat:@"%d",[CUUserManager sharedInstance].user.age];
            }
                break;
            case 10023:
            {
                cell.label.text = @"电话";
                cell.textField.text = [NSString stringWithFormat:@"%@",[CUUserManager sharedInstance].user.cellPhone];
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

- (void)textFieldChange:(UITextField *)textField{
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
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
