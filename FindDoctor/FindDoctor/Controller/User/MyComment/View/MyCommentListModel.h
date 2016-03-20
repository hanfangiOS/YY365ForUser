//
//  MyCommentListModel.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/3/14.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "SNBaseListModel.h"
#import "Comment.h"

@interface MyCommentListModel : SNBaseListModel

@property (nonatomic, strong) CommentFilter * filter;

@end
