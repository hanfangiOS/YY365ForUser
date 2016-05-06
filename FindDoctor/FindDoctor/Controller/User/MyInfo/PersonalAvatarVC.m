//
//  PersonalAvatarVC.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/5/5.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "PersonalAvatarVC.h"
#import "UIImageView+WebCache.h"
#import "CUUserManager.h"
#import "TipHandler+HUD.h"

@interface PersonalAvatarVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong,nonatomic)UIActionSheet   * myActionSheet;
@property (strong,nonatomic)UIImageView     * avatar;

@end

@implementation PersonalAvatarVC

- (instancetype)initWithPageName:(NSString *)pageName{
    self = [super initWithPageName:pageName];
    if (self) {
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人头像";
    self.contentView.backgroundColor = [UIColor blackColor];
    [self initSubviews];
}

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
    [self addRightButtonItemWithImage:[UIImage imageNamed:@""] action:@selector(openMenuAction)];
}

- (void)initSubviews{
    self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.contentView.frameHeight - self.contentView.frameWidth)/3, kScreenWidth, kScreenWidth)];
    self.avatar.clipsToBounds = YES;
    self.avatar.contentMode = 1;
    self.avatar.backgroundColor = [UIColor whiteColor];
    [self.avatar setImageWithURL:[NSURL URLWithString:[CUUserManager sharedInstance].user.icon]];
    [self.contentView addSubview:self.avatar];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == self.myActionSheet.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    
    switch (buttonIndex)
    {
            //打开照相机拍照
        case 0:  {
            [self takePhoto:actionSheet];
        }
            break;
            //打开本地相册
        case 1:{
            [self LocalPhoto:actionSheet];
        }
            break;
    }
}

//开始拍照
-(void)takePhoto:(UIActionSheet *)sender
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: sourceType])
    {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
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
    NSString * type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSData * data;
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
        
        UIImage * compressedImage = [UIImage imageWithData:data];
        [self postRequestUploadAvatarWithImage:compressedImage];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Action

- (void)openMenuAction{
    //在这里呼出下方菜单按钮项
    //    NSLog(@"sender.tag = %d",sender.tag);
    self.myActionSheet = [[UIActionSheet alloc]
                          initWithTitle:nil
                          delegate:self
                          cancelButtonTitle:@"取消"
                          destructiveButtonTitle:nil
                          otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    //    myActionSheet.tag = sender.tag;
    
    [self.myActionSheet showInView:self.view];
}

#pragma mark - postRequest

//上传图片
- (void)postRequestUploadAvatarWithImage:(UIImage *)image{
    [self showProgressView];
    __weak __block PersonalAvatarVC *blockSelf = self;
    [[CUUserManager sharedInstance]uploadAvatar:image resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        [blockSelf hideProgressView];
        if (!result.hasError) {
            NSString *ftpPath;
            NSArray * data = [result.responseObject objectForKeySafely:@"data"];
            if (data) {
                NSDictionary *dic = [data objectAtIndexSafely:0];
                if (dic) {
                    ftpPath = [dic objectForKey:@"ftppath"];
                }
            }
            if (ftpPath) {
                [blockSelf requestCommitImageURL:ftpPath];
            }
        }else{
            [TipHandler showTipOnlyTextWithNsstring:@"网络连接错误"];
        }

    } pageName:self.pageName progressBlock:^(float progress) {
        
    }];
}

- (void)requestCommitImageURL:(NSString *)ftppath{
    __weak __block PersonalAvatarVC *blockSelf = self;
    [[CUUserManager sharedInstance] ModifyAvatorWithPath:ftppath resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError) {
           [blockSelf.avatar setImageWithURL:[NSURL URLWithString:[CUUserManager sharedInstance].user.icon]];
        }
    } pageName:self.pageName];
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
