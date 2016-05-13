//
//  HomeSubViewMainBannerCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/6.
//  Copyright © 2016年 li na. All rights reserved.
//

#define cellHeight

#import "HomeSubViewMainBannerCell.h"

@implementation HomeSubViewMainBannerCell

- (void)setData:(Banner *)data{
    _data = data;
    self.URL = _data.imagePath;
//    self.URL = @"https://o1wjx1evz.qnssl.com/app/qrcode/AVQK";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
