//
//  HFBannerViewCell.m
//  HFBanner
//
//  Created by 晓炜 郭 on 16/3/31.
//  Copyright © 2016年 晓炜 郭. All rights reserved.
//

#import "HFBannerViewCell.h"

@implementation HFBannerViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubView];
    }
    return self;
}

- (void)initSubView{

}

- (void)setURL:(NSString *)URL{
    _URL = URL;
    [self setImageWithURL:[NSURL URLWithString:_URL]];
}

@end
