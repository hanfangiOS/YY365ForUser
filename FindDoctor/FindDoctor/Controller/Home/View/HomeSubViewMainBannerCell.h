//
//  HomeSubViewMainBannerCell.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/6.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "HFBannerViewCell.h"
#import "Banner.h"

@interface HomeSubViewMainBannerCell : HFBannerViewCell

@property (nonatomic, strong) Banner * data;

+ (CGFloat)defaultHeight;

@end
