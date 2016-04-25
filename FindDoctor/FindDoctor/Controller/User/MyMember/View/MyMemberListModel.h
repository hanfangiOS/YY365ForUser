//
//  MyMemberListModel.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "SNBaseListModel.h"
#import "CUUser.h"

@interface MyMemberListModel : SNBaseListModel

@property (strong,nonatomic)UserFilter * filter;

@end
