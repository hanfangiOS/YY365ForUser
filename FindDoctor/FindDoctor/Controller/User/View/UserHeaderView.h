//
//  UserHeaderView.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/21.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BigButtonsInUser;

@interface UserHeaderView : UIView

@property (strong,nonatomic)UIView                  * userInfoBackgroundView;
@property (strong,nonatomic)UIImageView             * icon;
@property (strong,nonatomic)UILabel                 * name;
@property (strong,nonatomic)UILabel                 * userID;
@property (strong,nonatomic)UIImageView             * arrow;

@property (strong,nonatomic)UIImageView             * btnBackgroundView;
@property (strong,nonatomic)BigButtonsInUser        * myDoctorBtn;
@property (strong,nonatomic)BigButtonsInUser        * myClinicBtn;
@property (strong,nonatomic)BigButtonsInUser        * myCommentBtn;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)resetUserInfo;


@end
