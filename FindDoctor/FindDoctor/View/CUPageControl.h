//
//  CUPageControl.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/21.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CUPageControl : UIPageControl

@property (nonatomic, strong)    UIImage* activeImage;
    
@property (nonatomic, strong)    UIImage* inactiveImage;


-(instancetype) initWithFrame:(CGRect)frame;

@end
