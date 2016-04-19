//
//  MyMemberViewController.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "CUListViewController.h"
#import "MyMemberListModel.h"

@interface MyMemberViewController : CUListViewController

- (id)initWithPageName:(NSString *)pageName listModel:(MyMemberListModel *)listModel;

@end
