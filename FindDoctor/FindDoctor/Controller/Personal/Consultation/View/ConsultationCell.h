//
//  ConsultationCell.h
//  FindDoctor
//
//  Created by chai on 15/9/8.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Consultation.h"

@interface ConsultationCellFrame: NSObject

@property (nonatomic, assign) CGRect headerViewFrame;
@property (nonatomic, assign) CGRect doctorNameFrame;
@property (nonatomic, assign) CGRect userInfoFrame;
@property (nonatomic, assign) CGRect contentLabelFrame;
@property (nonatomic, assign) CGRect pointLabelFrame;
@property (nonatomic, assign) CGRect dateLabelFrame;
@property (nonatomic, assign) CGRect rightSignFrame;
@property (nonatomic, assign) CGRect signTipFrame;

@property (nonatomic, assign) float cellHeight;

@property (nonatomic, strong) Consultation *consultationEntity;

@end

@interface ConsultationCell : UITableViewCell

@property (nonatomic, weak) ConsultationCellFrame *cellFrame;

@end
