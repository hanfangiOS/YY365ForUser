//
//  PersonalAvatarVC.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/5/5.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "CUViewController.h"

typedef void(^UploadAvatarSuccessBlock)(UIImage * image);

@interface PersonalAvatarVC : CUViewController

@property (copy,nonatomic)UploadAvatarSuccessBlock uploadAvatarSuccessBlock;

@end
