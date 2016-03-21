//
//  FlagViewInCommentList.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/3/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "Doctor.h"

@interface FlagView : UIControl

@property (strong, nonatomic) Doctor *data;

@property (nonatomic) BOOL editable;

@property (nonatomic, strong) FlagListInfo *selectedFlag;
- (void)setMark;

@end
