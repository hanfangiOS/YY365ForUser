//
//  AMBlurView.h
//  blur
//
//  Created by Cesar Pinto Castillo on 7/1/13.
//  Copyright (c) 2013 Arctic Minds Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AMBlurViewStyle) {
    AMBlurViewStyleDefault          = 0,
    AMBlurViewStyleBlack            = 1
};

@interface AMBlurView : UIView

// Use the following property to set the tintColor. Set it to nil to reset.
@property (nonatomic, retain) UIColor *blurTintColor;

@property (nonatomic) AMBlurViewStyle type;

@end
