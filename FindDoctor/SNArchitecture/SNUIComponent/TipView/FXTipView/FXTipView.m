//
//  FXTipView.m
//  Fetion
//
//  Created by 邹天矢 on 11-4-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "FXTipView.h"
#import <QuartzCore/QuartzCore.h>

#define kTextTipWidth      200
#define kTextTipHeigth     95

#define kImageWidth        64
#define kImageHeigth       64

#define kActivityWidth     80
#define kActivityHeigth     80

@implementation FXTipView

@synthesize activityIndicator = _activityIndicator;
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;
@synthesize coverView = _coverView;
@synthesize overlayWindow = _overlayWindow;

- (id)init {
	
	CGRect tipFrame = CGRectMake(0, 0, 200, 95);
    self = [super initWithFrame:tipFrame];
	if (self == nil)
		return nil;
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.layer.cornerRadius = 4.0;
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = NO;
        self.exclusiveTouch = YES;
        CGRect rc = CGRectMake(60, 0, 200, 95);
        rc.origin.y = [UIApplication sharedApplication].keyWindow.center.y - 120.0;
        self.frame = rc;
    }
    return self;
}

- (id) initTipView
{
    self = [super initWithFrame:CGRectMake(0, 0, kTextTipWidth, kTextTipHeigth)];
    if(self)
    {
        _activityIndicator = [[UIActivityIndicatorView alloc] init];
        _imageView = [[UIImageView alloc] init];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor whiteColor];
        [self addSubview:_activityIndicator];
        [self addSubview:_imageView];
        [self addSubview:_textLabel];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    if (_overlayWindow) {
        [_overlayWindow release], _overlayWindow = nil;
    }
    
    [_activityIndicator release];_activityIndicator = nil;
    [_imageView release]; _imageView = nil;
    [_textLabel release]; _textLabel = nil;
    [_coverView release];
    _coverView = nil;
    [super dealloc];

}

- (void)hide{
    [UIView beginAnimations:@"hide" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    self.alpha = 0.0;
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"hide"]) {
        [self removeTipView];
    }
}

- (void)removeTipView{
    [self removeFromSuperview];
    [_coverView removeFromSuperview];
    [_coverView release];
    _coverView = nil;
    
    if (self.overlayWindow) {
        self.overlayWindow.hidden = YES;
        [_overlayWindow release], _overlayWindow = nil;
    }
    
    if ([self retainCount] > 0) {
        [self release];self = nil;
    }
}

//+ (void) showTipViewWithText:(NSString *)text andImage:(UIImage *)image atCenter:(BOOL)atCenter {
//    FXTipView * tipView = [[[[NSBundle mainBundle] loadNibNamed:@"TipView" owner:nil options:nil] lastObject] retain];
//    tipView.textLabel.text = text;
//    tipView.imageView.image = image;
//    tipView.activityIndicator.hidden = YES;
//    tipView.alpha = 0.0;
//    
//    tipView.layer.cornerRadius = 0.0;
//    tipView.layer.masksToBounds = YES;
//    tipView.userInteractionEnabled = NO;
//    tipView.exclusiveTouch = YES;
//    CGRect rc = CGRectMake(60, 0, 200, 95);
//    if (atCenter) {
//        rc.origin.y = [UIApplication sharedApplication].keyWindow.center.y - 95/2;
//    }
//    else {
//        rc.origin.y = [UIApplication sharedApplication].keyWindow.center.y - 95/2;
//    }
//    tipView.frame = rc;
//    
//    [[UIApplication sharedApplication].keyWindow addSubview:tipView];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//    [UIView setAnimationDuration:0.2];
//    tipView.alpha = 0.8;
//    [UIView commitAnimations];
//    [tipView performSelector:@selector(hide) withObject:tipView afterDelay:1];
//}
//
//+ (void) showTipViewWithText:(NSString *)text {
//    FXTipView * tipView = [[[[NSBundle mainBundle] loadNibNamed:@"TextTipView" owner:nil options:nil] lastObject] retain];
//    tipView.textLabel.text = text;
//    tipView.alpha = 0.0;
//    
//    tipView.layer.cornerRadius = 0.0;
//    tipView.layer.masksToBounds = YES;
//    tipView.userInteractionEnabled = NO;
//    tipView.exclusiveTouch = YES;
//    CGRect rc = CGRectMake(10, 0, 300, 40);
//    rc.origin.y = [UIApplication sharedApplication].keyWindow.center.y - 20-40;
//    tipView.frame = rc;
//    
//    [[UIApplication sharedApplication].keyWindow addSubview:tipView];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//    [UIView setAnimationDuration:0.2];
//    tipView.alpha = 0.8;
//    [UIView commitAnimations];
//    [tipView performSelector:@selector(hide) withObject:tipView afterDelay:1];
//}
//
//+ (void) showTipViewWithText:(NSString *)text andRect:(CGRect )rect
//{
//    FXTipView * tipView = [[[[NSBundle mainBundle] loadNibNamed:@"TextTipView" owner:nil options:nil] lastObject] retain];
//    tipView.textLabel.text = text;
//    tipView.alpha = 0.0;
//    
//    tipView.layer.cornerRadius = 0.0;
//    tipView.layer.masksToBounds = YES;
//    tipView.userInteractionEnabled = NO;
//    tipView.exclusiveTouch = YES;
//    CGRect rc = rect;
//    //rc.origin.y = [UIApplication sharedApplication].keyWindow.center.y - 20-40;
//    tipView.frame = rc;
//    
//    [[UIApplication sharedApplication].keyWindow addSubview:tipView];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//    [UIView setAnimationDuration:0.2];
//    tipView.alpha = 0.8;
//    [UIView commitAnimations];
//    [tipView performSelector:@selector(hide) withObject:tipView afterDelay:1];
//    
//}
//
//
//
//+ (void) showTipViewWithTextForCloud:(NSString *)text {
//    FXTipView * tipView = [[[[NSBundle mainBundle] loadNibNamed:@"TextTipView" owner:nil options:nil] lastObject] retain];
//    tipView.textLabel.text = text;
//    tipView.textLabel.numberOfLines=0;
//    tipView.textLabel.textAlignment=UITextAlignmentLeft;
//    tipView.alpha = 0.0;
//    CGRect rect=tipView.textLabel.frame;
//    rect.origin.y=0;
//    rect.size.height=100;
//    rect.origin.x=10;
//    tipView.textLabel.frame=rect;
//    
//    tipView.layer.cornerRadius = 0.0;
//    tipView.layer.masksToBounds = YES;
//    tipView.userInteractionEnabled = NO;
//    tipView.exclusiveTouch = YES;
//    CGRect rc = CGRectMake(10, 0, 300, 100);
//    rc.origin.y = [UIApplication sharedApplication].keyWindow.center.y - 50.0;
//    tipView.frame = rc;
//    
//    [[UIApplication sharedApplication].keyWindow addSubview:tipView];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//    [UIView setAnimationDuration:0.2];
//    tipView.alpha = 0.8;
//    [UIView commitAnimations];
//    [tipView performSelector:@selector(hide) withObject:tipView afterDelay:1];
//}
//
//
//+ (FXTipView *) showWaitTipWithTextAndIndicatorNoRespondToTouch:(NSString *)text {
//    FXTipView * tipView = [[[[NSBundle mainBundle] loadNibNamed:@"TipView" owner:nil options:nil] lastObject] retain];
//    tipView.textLabel.text = text;
//    tipView.alpha = 0.0;
//    tipView.userInteractionEnabled = YES;
//    tipView.exclusiveTouch = NO;
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(60, 170, 200, 95)];
//    view.layer.cornerRadius = 0.0;
//    view.layer.masksToBounds = YES;
//    view.alpha = 1.0;
//    [view setBackgroundColor:[UIColor clearColor]];
//    [tipView addSubview:view];
//    [view release];
//    tipView.activityIndicator.frame = CGRectMake(140, 180, 37, 37);
//    tipView.imageView.frame = CGRectMake(60, 200, 200, 95);
//    tipView.textLabel.frame = CGRectMake(60, 200, 200, 95);;
//    CGRect rc = CGRectMake(0, 0, 320, 480);
//    //rc.origin.y = [UIApplication sharedApplication].keyWindow.center.y - 80.0;
//    tipView.frame = rc;
//    [[UIApplication sharedApplication].keyWindow addSubview:tipView];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//    [UIView setAnimationDuration:0.2];
//    tipView.alpha = 0.6;
//    [UIView commitAnimations];
//    return tipView;
//}

//+ (FXTipView *) showWaitTipWithTextAndIndicator:(NSString *)text {
//    
//    FXTipView *tipView = (FXTipView *)[[UIApplication sharedApplication].keyWindow viewWithTag:10000];
//    if (tipView)
//    {
//        [tipView removeFromSuperview];
//    }
//    
//    tipView = [[[[NSBundle mainBundle] loadNibNamed:@"TipView" owner:nil options:nil] lastObject] retain];
//    tipView.textLabel.text = text;
//    tipView.alpha = 0.0;
//    tipView.tag = 10000;
//    tipView.layer.cornerRadius = 0.0;
//    tipView.layer.masksToBounds = YES;
//    tipView.userInteractionEnabled = NO;
//    tipView.exclusiveTouch = YES;
//    CGRect rc = CGRectMake(60, 0, 200, 95);
//    rc.origin.y = [UIApplication sharedApplication].keyWindow.center.y - 95.0/2;
//    tipView.frame = rc;
//    
//    [[UIApplication sharedApplication].keyWindow addSubview:tipView];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//    [UIView setAnimationDuration:0.2];
//    tipView.alpha = 0.8;
//    [UIView commitAnimations];
//
//    return tipView;
//}
//
//+ (FXTipView *) showWaitTipWithText:(NSString *)text{
//    
//    FXTipView *tipView = (FXTipView *)[[UIApplication sharedApplication].keyWindow viewWithTag:10001];
//    if (tipView)
//    {
//        [tipView removeFromSuperview];
//    }
//    
//    tipView = [[[[NSBundle mainBundle] loadNibNamed:@"TextTipView" owner:nil options:nil] lastObject] retain];
//    tipView.textLabel.text = text;
//    tipView.alpha = 0.0;
//    tipView.tag   = 10001;
//    tipView.layer.cornerRadius = 0.0;
//    tipView.layer.masksToBounds = YES;
//    tipView.userInteractionEnabled = NO;
//    tipView.exclusiveTouch = YES;
//    CGRect rc = CGRectMake(10, 0, 300, 40);
//    rc.origin.y = [UIApplication sharedApplication].keyWindow.center.y - 20.0;
//    tipView.frame = rc;
//    
//    [[UIApplication sharedApplication].keyWindow addSubview:tipView];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//    [UIView setAnimationDuration:0.2];
//    tipView.alpha = 0.8;
//    [UIView commitAnimations];
//    return tipView;
//}
//+ (void) showTipViewWithLongText:(NSString *)text {
//    
//    FXTipView * tipView = [[[[NSBundle mainBundle] loadNibNamed:@"LongTextTipView" owner:nil options:nil] lastObject] retain];
//    tipView.textLabel.text = text;
//    tipView.alpha = 0.0;
//    
//    tipView.layer.cornerRadius = 0.0;
//    tipView.layer.masksToBounds = YES;
//    tipView.userInteractionEnabled = NO;
//    tipView.exclusiveTouch = YES;
//    CGRect rc = CGRectMake(60, 0, 200, 95);
//    rc.origin.y = ([UIApplication sharedApplication].keyWindow.center.y - 95.0/2);
//    tipView.frame = rc;
//    
//    [[UIApplication sharedApplication].keyWindow addSubview:tipView];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//    [UIView setAnimationDuration:0.2];
//    tipView.alpha = 0.8;
//    [UIView commitAnimations];
//    [tipView performSelector:@selector(hide) withObject:tipView afterDelay:1];
//}



#pragma 
#pragma mark ===================== 扩展  ===================
+ (void) showSmallTipViewWithText:(NSString*) string
{
    FXTipView * tipView = [[FXTipView alloc] initTipView];
    tipView.frame = CGRectMake(0, 0, 100, 80);
    tipView.textLabel.frame = CGRectInset(tipView.bounds, 10, 10);
    tipView.textLabel.text = string;
    tipView.alpha = 0.0;
    tipView.layer.cornerRadius = 4.0;
    tipView.layer.masksToBounds = YES;
    tipView.userInteractionEnabled = NO;
    tipView.exclusiveTouch = YES;
    tipView.center = [UIApplication sharedApplication].keyWindow.center;
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:tipView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.2];
    tipView.alpha = 0.8;
    [UIView commitAnimations];
    [tipView performSelector:@selector(hide) withObject:tipView afterDelay:1];
    
}

+ (void) showTipViewWithTextByTipView:(NSString*) string
{
    FXTipView * tipView = [[FXTipView alloc] initTipView];
    tipView.textLabel.frame = CGRectInset(tipView.bounds, 10, 10);
    tipView.textLabel.text = string;
    tipView.alpha = 0.0;
    tipView.layer.cornerRadius = 4.0;
    tipView.layer.masksToBounds = YES;
    tipView.userInteractionEnabled = NO;
    tipView.exclusiveTouch = YES;
    tipView.center = [UIApplication sharedApplication].keyWindow.center;
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:tipView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.2];
    tipView.alpha = 0.8;
    [UIView commitAnimations];
    [tipView performSelector:@selector(hide) withObject:tipView afterDelay:1];
    
}


+ (void) showTipViewWithTextByTipView:(NSString*) string andShowTime:(CGFloat)  time
{
    FXTipView * tipView = [[FXTipView alloc] initTipView];
    tipView.textLabel.frame = CGRectInset(tipView.bounds, 10, 10);
    tipView.textLabel.text = string;
    tipView.alpha = 0.0;
    tipView.layer.cornerRadius = 4.0;
    tipView.layer.masksToBounds = YES;
    tipView.userInteractionEnabled = NO;
    tipView.exclusiveTouch = YES;
    tipView.center = [UIApplication sharedApplication].keyWindow.center;
    
    UIWindow *overlayWindow = [[UIWindow alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    overlayWindow.windowLevel = UIWindowLevelAlert+1.0;
    overlayWindow.userInteractionEnabled = NO;
    overlayWindow.hidden = NO;
    [overlayWindow addSubview:tipView];
    tipView.overlayWindow = overlayWindow;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.2];
    tipView.alpha = 0.8;
    [UIView commitAnimations];
    [tipView performSelector:@selector(hide) withObject:tipView afterDelay:time];
    
}

+ (void) showTipViewWithTextByTipView:(NSString *)string andImage:(UIImage *)image 
{
    FXTipView * tipView = [[FXTipView alloc] initTipView];
    
    tipView.imageView.frame = CGRectMake((tipView.bounds.size.width - kImageWidth)/2, 0, kImageWidth, kImageHeigth);
    tipView.imageView.image = image;
    
    tipView.textLabel.frame = CGRectMake(10, kImageHeigth, tipView.bounds.size.width - 20, tipView.bounds.size.height - kImageHeigth);
    tipView.textLabel.text = string;
    
    tipView.alpha = 0.0;
    tipView.layer.cornerRadius = 4.0;
    tipView.layer.masksToBounds = YES;
    tipView.userInteractionEnabled = NO;
    tipView.exclusiveTouch = YES;
    tipView.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow addSubview:tipView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.2];
    tipView.alpha = 0.8;
    [UIView commitAnimations];
    [tipView performSelector:@selector(hide) withObject:tipView afterDelay:1];

}

+ (void) showTipViewWithTextByTipView:(NSString *)string andImage:(UIImage *)image andShowTime:(CGFloat)  time
{
    FXTipView * tipView = [[FXTipView alloc] initTipView];
    
    tipView.imageView.frame = CGRectMake((tipView.bounds.size.width - kImageWidth)/2, 0, kImageWidth, kImageHeigth);
    tipView.imageView.image = image;
    
    tipView.textLabel.frame = CGRectMake(10, kImageHeigth, tipView.bounds.size.width - 20, tipView.bounds.size.height - kImageHeigth);
    tipView.textLabel.text = string;
    
    tipView.alpha = 0.0;
    tipView.layer.cornerRadius = 4.0;
    tipView.layer.masksToBounds = YES;
    tipView.userInteractionEnabled = NO;
    tipView.exclusiveTouch = YES;
    tipView.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow addSubview:tipView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.2];
    tipView.alpha = 0.8;
    [UIView commitAnimations];
    [tipView performSelector:@selector(hide) withObject:tipView afterDelay:time];
    
}

+ (FXTipView *) showWaitTipWithTextAndIndicatorNoRespondToTouchByTipView:(NSString *)string
{
    FXTipView * tipView = [[FXTipView alloc] initTipView];
    if(string.length > 0)
    {
        tipView.activityIndicator.frame = CGRectMake((tipView.bounds.size.width - kActivityWidth)/2, 0, kActivityWidth, kActivityHeigth);
        tipView.textLabel.frame = CGRectMake(10, kActivityHeigth - 10, tipView.bounds.size.width - 20, tipView.bounds.size.height - kActivityHeigth);
        tipView.textLabel.text = string;
    }
    else
    {
        tipView.activityIndicator.frame = CGRectMake((tipView.bounds.size.width - kActivityWidth)/2, (tipView.bounds.size.height - kActivityHeigth)/2, kActivityWidth, kActivityHeigth);
    }
    
    tipView.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    CGPoint center = tipView.activityIndicator.center;
    CGRect frame = tipView.activityIndicator.frame;
    frame.size.width = 32;
    frame.size.height = 32;
    tipView.activityIndicator.frame = frame;
    tipView.activityIndicator.center = center;
    [tipView.activityIndicator  startAnimating];
    tipView.alpha = 0.0;
    tipView.layer.cornerRadius = 4.0;
    tipView.layer.masksToBounds = YES;
    tipView.userInteractionEnabled = NO;
    tipView.exclusiveTouch = YES;
    tipView.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow addSubview:tipView];
    
    tipView.coverView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    tipView.coverView.backgroundColor = [UIColor clearColor];
    tipView.coverView.userInteractionEnabled = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:tipView.coverView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.2];
    tipView.alpha = 0.8;
    [UIView commitAnimations];

    return tipView;
}


+ (FXTipView *) showWaitTipWithTextAndIndicatorByTipView:(NSString *)string
{
    FXTipView * tipView = [[FXTipView alloc] initTipView];
    if(string.length > 0)
    {
        tipView.activityIndicator.frame = CGRectMake((tipView.bounds.size.width - kActivityWidth)/2, 0, kActivityWidth, kActivityHeigth);
        tipView.textLabel.frame = CGRectMake(10, kActivityHeigth - 10, tipView.bounds.size.width - 20, tipView.bounds.size.height - kActivityHeigth);
        tipView.textLabel.text = string;
    }
    else
    {
        tipView.activityIndicator.frame = CGRectMake((tipView.bounds.size.width - kActivityWidth)/2, (tipView.bounds.size.height - kActivityHeigth)/2, kActivityWidth, kActivityHeigth);
    }
    tipView.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [tipView.activityIndicator  startAnimating];
    tipView.alpha = 0.0;
    tipView.layer.cornerRadius = 4.0;
    tipView.layer.masksToBounds = YES;
    tipView.userInteractionEnabled = NO;
    tipView.exclusiveTouch = YES;
    tipView.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow addSubview:tipView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.2];
    tipView.alpha = 0.8;
    [UIView commitAnimations];
    
    return tipView;
}
@end
