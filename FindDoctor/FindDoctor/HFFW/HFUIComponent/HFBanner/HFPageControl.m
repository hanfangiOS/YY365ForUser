//
//  CUPageControl.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/21.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "HFPageControl.h"

@implementation HFPageControl

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    _activeImage = [UIImage imageNamed:ActiveImageName];
    _inactiveImage = [UIImage imageNamed:InactiveImageName];
    return self;
}

- (void)updateDots{
    for (int i=0; i<[self.subviews count]; i++) {
        UIView *dot = [self.subviews objectAtIndex:i];
        if (i==self.currentPage)dot.layer.contents = (id)_activeImage.CGImage;
        else dot.layer.contents = (id)_inactiveImage.CGImage;
    }
}

- (void)setCurrentPage:(NSInteger)page{
    [super setCurrentPage:page];
    [self updateDots];
}
@end
