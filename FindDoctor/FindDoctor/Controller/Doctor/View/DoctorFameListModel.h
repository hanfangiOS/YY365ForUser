//
//  DoctorFameListModel.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/3/15.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "SNBaseListModel.h"
#import "CUCommentManager.h"

@interface DoctorFameListModel : SNBaseListModel

@property (nonatomic, strong) DoctorFameFilter          * fameFilter;
@property (nonatomic, strong) Comment                   * comment;

@property (nonatomic, strong) DoctorFameCommentFilter   * commentFilter;

@end
