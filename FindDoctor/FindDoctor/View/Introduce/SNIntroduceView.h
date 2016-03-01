//
//  SNIntroduceView.h
//  SinaNews
//
//  Created by Nova on 13-4-21.
//  Modified by zhenhua on 13-12-16.
//  Copyright (c) 2013年 sina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SNIntroduceView;
typedef void(^SNIntroduceViewWillHidden)(SNIntroduceView *introduceView);

@interface SNIntroduceView : UIView <UIScrollViewDelegate>
{
    UIScrollView    *_introduceMainScrollView;
    
    UIPageControl   *_introducePageControl;
}

@property (nonatomic, copy) SNIntroduceViewWillHidden complete;

+ (void)showWithComplete:(void(^)(SNIntroduceView *introduceView))complete;
+ (void)showWithCompleteInMoreTab:(void(^)(SNIntroduceView *introduceView))complete;

@end

