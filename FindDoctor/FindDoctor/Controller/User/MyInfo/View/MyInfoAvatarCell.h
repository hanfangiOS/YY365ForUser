//
//  MyInfoAvatarCell.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInfoAvatarCell : UITableViewCell

@property (strong,nonatomic)UILabel     * label;
@property (strong,nonatomic)UIImageView * avatar;
@property (strong,nonatomic)UIImageView * arrow;

+ (float)cellDefaultHeight;
@end
