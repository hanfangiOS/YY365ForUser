//
//  MyTreatmentCell.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/19.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUOrder.h"

typedef void(^ClickCommentBtn)(void);

@interface MyTreatmentCell : UITableViewCell

@property (strong,nonatomic)CUOrder       * data;

@property (copy,nonatomic)ClickCommentBtn    clickCommentBtn;

+ (CGFloat)defaultHeight;

@end
