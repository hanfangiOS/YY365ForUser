//
//  MyTreatmentController.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/19.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "CUListViewController.h"
#import "MyTreatmentListModel.h"

@interface MyTreatmentController : CUListViewController

- (id)initWithPageName:(NSString *)pageName listModel:(MyTreatmentListModel *)listModel;

@end
