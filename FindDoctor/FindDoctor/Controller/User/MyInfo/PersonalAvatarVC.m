//
//  PersonalAvatarVC.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/5/5.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "PersonalAvatarVC.h"

@interface PersonalAvatarVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong,nonatomic)UIActionSheet  * myActionSheet;



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
    
//    self.
    [self initSubviews];
}

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
    [self addRightButtonItemWithImage:[UIImage imageNamed:@""] action:@selector(openMenuAction)];
}

- (void)initSubviews{
    
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
