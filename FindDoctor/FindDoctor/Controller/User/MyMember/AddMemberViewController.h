//
//  AddMemberViewController.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "CUViewController.h"
#import "CUUser.h"

typedef void(^BackWithUserBlock)(CUUser * user);

@interface AddMemberViewController : CUViewController

@property (copy,nonatomic)BackWithUserBlock backWithUserBlock;

@end
