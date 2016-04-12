//
//  LoadingView.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/3/9.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView{
    
    UIImageView * _LaunchImageView;
    NSTimer * _timer;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        _LaunchImageView = [[UIImageView alloc] initWithFrame:frame];
        NSString * imagePath = [[NSBundle mainBundle] pathForResource:@"Launch" ofType:@"jpg"];
        _LaunchImageView.image = [UIImage imageWithContentsOfFile:imagePath];
        [self addSubview:_LaunchImageView];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeControl) userInfo:nil repeats:NO];
        return self;
    }
    return nil;
    
}


- (void)timeControl{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LaunchFirstView" object:self userInfo:nil];
    
}

@end
