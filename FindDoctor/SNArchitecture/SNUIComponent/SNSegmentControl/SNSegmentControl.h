//
//  SNSegmentControl.h
//  CoreDemo
//
//  Created by xiaofang wu on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SNSegmentControlDelegate <NSObject>

- (void) segmentSelectWithIndex:(NSInteger) index;

@end


@interface SNSegmentControl : UIView

@property (nonatomic,weak) id<SNSegmentControlDelegate>        segmentControlDelegate;


- (void) insertSegmentWithButton:(UIButton*) button  andIndex:(NSInteger)  index;
- (void) removeSegmentWithIndex:(NSInteger) index;
- (void) setSegmentButtonTitle:(NSString *)title withIndex:(NSInteger) index;
- (void) selectSegmentWithIndex:(NSInteger) index;
- (void) setSegmentControlStateNormal;
- (void) setSegmentControlShouldSelect;
@end
