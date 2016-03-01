//
//  FamilyMemberDetailController+UploadAvartar.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/9.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "FamilyMemberDetailController.h"

@interface FamilyMemberDetailController (UploadAvartar) <UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>

- (void)showUploadActionSheet;

@end
