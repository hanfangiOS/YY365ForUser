//
//  MyInfoAvatarCell.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickMyInfoAvatarCellBlock)(void);

@interface MyInfoAvatarCell : UITableViewCell

@property (strong,nonatomic)UIView      * containerView;
@property (strong,nonatomic)UILabel     * label;
@property (strong,nonatomic)UIImageView * avatar;
@property (strong,nonatomic)UIImageView * arrow;

@property (copy,nonatomic)ClickMyInfoAvatarCellBlock clickMyInfoAvatarCellBlock;
+ (float)cellDefaultHeight;
@end
