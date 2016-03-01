//
//  ReplyCell.h
//  FindDoctor
//
//  Created by chai on 15/9/10.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsultationReply.h"

@interface ReplyCellFrame : NSObject

@property (nonatomic, assign) CGRect contentFrame;
@property (nonatomic, assign) CGRect nameFrame;

@property (nonatomic, assign) CGRect dateFrame;

@property (nonatomic, assign) float cellHeight;

@property (nonatomic, assign) BOOL isSelf;

@property (nonatomic, strong) ConsultationReply *replyEntity;

@end

@interface ReplyCell : UITableViewCell

@property (nonatomic, weak) ReplyCellFrame *cellFrame;

@end
