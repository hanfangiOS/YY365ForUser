//
//  DoctorTableViewCell.h
//  FindDoctor
//
//  Created by Tom Zhang on 15/8/13.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorTableViewCell : UITableViewCell

//@property (nonatomic, retain) UIImageView *portrait;

- (void)setEvaluationScore:(float)score;

- (void)setDoctorPortrait:(NSString*)imageName;

- (void)setDoctorName:(NSString*)name technicalTitle:(NSString*)technicalTitle teachingTitle:(NSString*)teachingTitle;

- (void)setDoctorProfile:(NSString*)profile;

@end
