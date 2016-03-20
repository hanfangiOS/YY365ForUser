//
//  DoctorFameListController.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/3/15.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "CUListViewController.h"
#import "Doctor.h"
#import "DoctorFameListModel.h"

@interface DoctorFameListController : CUListViewController

- (id)initWithPageName:(NSString *)pageName listModel:(DoctorFameListModel *)listModel;

@end
