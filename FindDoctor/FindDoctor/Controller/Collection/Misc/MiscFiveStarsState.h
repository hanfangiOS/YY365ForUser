//
//  MiscFiveStarsState.h
//  FindDoctor
//
//  Created by Tom Zhang on 15/8/11.
//  Copyright (c) 2015年 li na. All rights reserved.
//
#import <UIKit/UIKit.h>

/*!
 *   @brief The MiscFiveStarsState class initializes and returns a newly allocated view object with 5 stars and a label indicating the evaluation state.
 */
@interface MiscFiveStarsState : UIView

//@property (nonatomic, assign) float score;

//frame.size.width == 7*frame.size.height
- (instancetype)initWithFrame:(CGRect)frame;

//frame.size.width == 7*frame.size.height
// 0 <= score <= 5.0
- (instancetype)initWithFrame:(CGRect)frame Score:(float)score;

// 0 <= score <= 5.0
- (void)setScore:(float)score;

@end
