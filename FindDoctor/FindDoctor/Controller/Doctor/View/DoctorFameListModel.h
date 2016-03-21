//
//  DoctorFameListModel.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/3/15.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "SNBaseListModel.h"
#import "CUCommentManager.h"
#import "Comment.h"

@interface DoctorFameListModel : SNBaseListModel

@property (nonatomic, strong) CommentFilter          * filter;

@property (nonatomic, strong) Doctor                 * doctor;

@end
