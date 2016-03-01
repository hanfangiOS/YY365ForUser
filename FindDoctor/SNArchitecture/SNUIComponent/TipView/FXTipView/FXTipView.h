//
//  FXTipView.h
//  Fetion
//
//  Created by 邹天矢 on 11-4-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FXTipView : UIView {
    UIActivityIndicatorView * _activityIndicator;
    UIImageView * _imageView;
    UILabel * _textLabel;
    UIView*   _coverView;
    
    UIWindow  *_overlayWindow;
}

@property(nonatomic, retain) UIActivityIndicatorView * activityIndicator;
@property(nonatomic, retain) UIImageView * imageView;
@property(nonatomic, retain) UILabel * textLabel;
@property(nonatomic, retain) UIView*   coverView;
@property(nonatomic, assign) UIWindow  *overlayWindow;

- (void) hide;

//+ (void) showTipViewWithText:(NSString *)text andImage:(UIImage *)image atCenter:(BOOL)atCenter;
//+ (void) showTipViewWithText:(NSString *)text;
//+ (void) showTipViewWithText:(NSString *)text andRect:(CGRect )rect;
//+ (FXTipView *) showWaitTipWithTextAndIndicator:(NSString *)text;
//+ (FXTipView *) showWaitTipWithText:(NSString *)text;
//+ (FXTipView *) showWaitTipWithTextAndIndicatorNoRespondToTouch:(NSString *)text;
//+ (void) showTipViewWithLongText:(NSString *)text;
//+ (void) showTipViewWithTextForCloud:(NSString *)text;

- (void) removeTipView;


/*
 * 对FXTipView进行了扩展
 * 添加了部分方法
 *
 */
- (id) initTipView;
+ (void) showSmallTipViewWithText:(NSString*) string;
+ (void) showTipViewWithTextByTipView:(NSString*) string;
+ (void) showTipViewWithTextByTipView:(NSString*) string andShowTime:(CGFloat)  time;
+ (void) showTipViewWithTextByTipView:(NSString *)string andImage:(UIImage *)image; 
+ (FXTipView *) showWaitTipWithTextAndIndicatorNoRespondToTouchByTipView:(NSString *)string;
+ (FXTipView *) showWaitTipWithTextAndIndicatorByTipView:(NSString *)string;
@end
