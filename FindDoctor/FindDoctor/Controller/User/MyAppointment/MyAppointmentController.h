//
//  MyAppointmentController.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/18.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "CUListViewController.h"
#import "MyAppointmentListModel.h"

@interface MyAppointmentController : CUListViewController

- (id)initWithPageName:(NSString *)pageName listModel:(MyAppointmentListModel *)listModel;

@end
