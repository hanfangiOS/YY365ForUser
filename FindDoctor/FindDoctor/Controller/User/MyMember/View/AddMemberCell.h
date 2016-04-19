//
//  AddMemberCell.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMemberCell : UITableViewCell

@property (strong,nonatomic)UIImageView     * icon;
@property (strong,nonatomic)UILabel         * Label;
@property (strong,nonatomic)UITextField     * textField;
@property (strong,nonatomic)UIView          * bottomLine;

+ (float)defaultCellHeight;

@end
