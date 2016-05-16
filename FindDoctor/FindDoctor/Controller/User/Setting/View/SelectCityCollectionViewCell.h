//
//  SelectCityCollectionViewCell.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/5/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCityCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSString *string;
@property (nonatomic)         BOOL     *isValue;
+ (CGFloat)defaultHeight;

@end
