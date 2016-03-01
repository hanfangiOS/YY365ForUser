//
//  QuestionCell.h
//  FindDoctor
//
//  Created by chai on 15/9/15.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionCell : UITableViewCell

+ (float)contentHeight:(NSString *)questionText;

- (void)setQuestion:(NSString *)questionText;

@end
