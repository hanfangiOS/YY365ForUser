//
//  UserDetailController+UploadAvartar.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/19.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "UserDetailController+UploadAvartar.h"
#import "AVCaptureDevice+Permission.h"
#import "AvatarHelper.h"
#import "TipHandler+HUD.h"
#import "CUUserManager.h"
#import "SDImageCache.h"

@implementation UserDetailController (UploadAvartar)

- (void)recoveryStatusBar
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)showUploadActionSheet
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [self showUploadActionSheetForIOS8];
    }
    else {
        [self showUploadActionSheetBeforeIOS8];
    }
}

- (void)showUploadActionSheetBeforeIOS8
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: @"拍照" , @"从相册选择" ,nil];
    
    [actionSheet showFromRect:self.view.bounds inView:self.slideNavigationController.view animated:YES];
}

- (void)showUploadActionSheetForIOS8
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                [self showImagePickerWithButtonIndex:0];
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                [self showImagePickerWithButtonIndex:1];
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    [self showImagePickerWithButtonIndex:buttonIndex];
}

- (void)showImagePickerWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 未设置过
        if (![AVCaptureDevice isCameraAuthorizationDetermined]) {
            [AVCaptureDevice requestCameraAuthorization:^(BOOL isAuthorized) {
                if (isAuthorized) {
                    [self showImagePickerWithButtonIndex:0];
                }
            }];
            
            return;
        }
        else {
            // 已设置，不允许访问
            if (![AVCaptureDevice isCameraAuthorized]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"请在设备的“设置-隐私-相机”中允许访问相机。"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
                
                return;
            }
        }
    }
    else {
        // 未设置过
        if (![AVCaptureDevice isAlbumAuthorizationDetermined]) {
            [AVCaptureDevice requestAlbumAuthorization:^(BOOL isAuthorized) {
                if (isAuthorized) {
                    [self showImagePickerWithButtonIndex:1];
                }
            }];
            
            return;
        }
        else {
            // 已设置，不允许访问
            if (![AVCaptureDevice isAlbumAuthorized]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"请在设备的“设置-隐私-相片”中允许访问相册。"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
                
                return;
            }
        }
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    
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
        
        // 上传头像
        [self uploadAvartarImage:editedImage];
        
        [self recoveryStatusBar];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        [self recoveryStatusBar];
    }];
}

#pragma mark - Request Method

- (void)uploadAvartarImage:(UIImage*)image
{
    self.isUploadingArvartar = YES;
    
//    [[CUUserManager sharedInstance] uploadAvatar:image resultBlock:^(SNHTTPRequestOperation * request,SNServerAPIResultData * result) {
//        if (!result.hasError) {
//            NSString *imageURL = result.parsedModelObject;
//            if (imageURL.length) {
//                [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL];
//            }
//            
//            //self.tempMember.profile = imageURL;
//            
//            [self uploadAccountImageSuccess:image];
//        }
//        else {
//            [self uploadAccountImageFailed];
//        }
//    } pageName:@"UploadAvatar"];
}

#pragma mark - Notification Handle

- (void)uploadAccountImageSuccess:(UIImage *)image
{
    self.header.image = image;
    
    //[TipHandler showHUDText:@"修改成功" state:TipStateSuccess inView:self.view];
    
    self.isUploadingArvartar = NO;
}

- (void)uploadAccountImageFailed
{
    //[TipHandler showHUDText:@"修改失败" state:TipStateSuccess inView:self.view];
    
    self.isUploadingArvartar = NO;
}

@end

