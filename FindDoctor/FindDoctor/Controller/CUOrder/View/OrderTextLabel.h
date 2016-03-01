//
//  OrderTextLabel.h
//  EShiJia
//
//  Created by zhouzhenhua on 15-4-19.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface OrderTextLabel : UILabel

@property (nonatomic) VerticalAlignment verticalAlignment;

@end
