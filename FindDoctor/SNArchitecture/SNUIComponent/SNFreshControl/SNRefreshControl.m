//
//  SNRefreshControl.m
//  refresh
//
//  Created by nova on 12-11-19.
//  Copyright (c) 2012年 SINA. All rights reserved.
//

#import "SNRefreshControl.h"
#import "UIColor+SNExtension.h"

#define kDarkGrayColor     UIColorFromHex(0x5d5d5d)
#define kScreentWidthScale       (([UIScreen mainScreen].bounds.size.width) / 320.0)

#pragma mark - SNRefreshControl

typedef enum {
    SNRefreshControlStatusNormal = 0,
    SNRefreshControlStatusRefreshing = 1,
    SNRefreshControlStatusPulling = 2,
} SNRefreshControlStatus;

typedef enum {
    SNRefreshControlPullingStatusNone = -1,
    SNRefreshControlPullingStatusDown = 0,
    SNRefreshControlPullingStatusRelease = 1,
} SNRefreshControlPullingStatus;

struct SNRefreshControlAttribute
{
    CGFloat refreshControlHeight;
    CGFloat refreshControlWidth;
    
    CGFloat topInterval;
    CGFloat middleInterval;
    CGFloat bottomInterval;
    
    CGFloat offsetThreshold;
    CGFloat contentInsetTop;
    CGFloat originalTopInset;
    CGFloat originalBottomInset;
    
    CGFloat triggerOffset;
    
    CGFloat titleFontSize;
    CGFloat timeFontSize;
};
typedef struct SNRefreshControlAttribute SNRefreshControlAttribute;

@interface SNRefreshControl ()
{
@protected
    CGFloat _lastOffset;
    
    SNRefreshControlStatus    _status;
    SNRefreshControlAttribute _attribute;
    
    SNRefreshControlPullingStatus   _pullingStatus;
}

- (id)initWithAttachedView:(UIScrollView *)scrollView style:(SNRefreshControlStyle)style;

- (void)initAttributes;
- (void)initViews;

- (void)setOffset:(CGFloat)offset isDragging:(BOOL)isDragging;

- (void)setStatus:(SNRefreshControlStatus)status withForce:(BOOL)force;

- (void)setNormalStatusWithForce:(BOOL)force;
- (void)setPullingStatusWithForce:(BOOL)force;
- (void)setRefreshingStatusWithForce:(BOOL)force;

- (void)pullWithOffset:(CGFloat)offset pullingStatus:(SNRefreshControlPullingStatus)pullingStatus;

- (void)setPullingDownStatusWithOffset:(CGFloat)offset;
- (void)setPullingReleaseStatusWithOffset:(CGFloat)offset;
- (void)setPullingNoneStatusWithOffset:(CGFloat)offset;

@end

#pragma mark - SNNormalRefreshControl

struct SNRefreshControlNormalAttribute
{
    // Attribute for SNRefreshControlStyleNormal
    CGFloat indicatorXCenterLeftPadding;
    CGFloat indicatorYCenterBottomPadding;
};
typedef struct SNRefreshControlNormalAttribute SNRefreshControlNormalAttribute;

@interface SNNormalRefreshControl : SNRefreshControl
{
    SNRefreshControlNormalAttribute _normalAttribute;
    
    UIActivityIndicatorView *_indicatorView;
}

@end

#pragma mark - SNRefreshControlArrowAttribute

struct SNRefreshControlArrowAttribute
{
    // Attribute for SNRefreshControlStyleArrow
    CGFloat indicatorXCenterLeftPadding;
    CGFloat indicatorYCenterBottomPadding;
};
typedef struct SNRefreshControlArrowAttribute SNRefreshControlArrowAttribute;

@interface SNArrowRefreshControl : SNRefreshControl
{
    SNRefreshControlArrowAttribute  _arrowAttribute;
    
    CALayer      *_indicatorLayer;
    UIActivityIndicatorView *_indicatorView;
}

@end

#pragma mark - SNRefreshControlCustomAttribute

struct SNRefreshControlCustomAttribute
{
    // Attribute for SNRefreshControlStyleArrow
    CGFloat indicatorXCenterLeftPadding;
    CGFloat indicatorYCenterBottomPadding;
};
typedef struct SNRefreshControlCustomAttribute SNRefreshControlCustomAttribute;

@interface SNCustomRefreshControl : SNRefreshControl
{
    SNRefreshControlArrowAttribute  _arrowAttribute;
    
    UIImageView                     *_indicatorView;
    BOOL                            *_isDoAnimatin;
    int                             _prevContentOffsetY;
    NSMutableArray                  *_drawingImgs;
    NSMutableArray                  *_loadingImgs;

    
}

@end

#pragma mark - SNRefreshControlDropAttribute

struct SNRefreshControlDropAttribute
{
    // Attribute for SNRefreshControlStyleDrop
    CGFloat radius;
    CGFloat radiusOneCoefficient;
    CGFloat radiusTwoCoefficient;
    CGFloat shapeLayerHeight;
    CGFloat shapeLayerWidth;
    CGFloat paddingToTitleLabel;
    CGFloat shapeLayerYCenterBottomPadding;
    CGFloat offsetAdjust;
    CGFloat addCurveThreshold;
};
typedef struct SNRefreshControlDropAttribute SNRefreshControlDropAttribute;

@interface SNDropRefreshContorl : SNRefreshControl
{
    CGPathRef defaultPath;
    SNRefreshControlDropAttribute   _dropAttribute;
    
    CALayer      *_indicatorLayer;
    CAShapeLayer *_shapeLayer;
}

- (CGPathRef)defaultPath;
- (CGPathRef)pathWithOffset:(CGFloat)offset;

- (void)addAnimationForBounce;
- (void)addAnimationForRotation;

@end


#pragma mark - Implementation

@implementation SNRefreshControl

@synthesize backgroundView = _backgroundView;
@synthesize bottomShadowView = _bottomShadowView;
@synthesize titleLabel = _titleLabel;
@synthesize timeLabel = _timeLabel;
@synthesize style = _style;
@synthesize lastFreshDate = _lastFreshDate;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver];
    
    [_titleLabel release];
    [_timeLabel release];
    [_backgroundView release];
    [_bottomShadowView release];
    [_lastFreshDate release];
    
    [super dealloc];
}

#pragma mark - Init

+ (id)refreshControlWithAttachedView:(UIScrollView *)scrollView style:(SNRefreshControlStyle)style
{
    Class class = Nil;
    switch (style) {
        case SNRefreshControlStyleDrop:
            class = [SNDropRefreshContorl class];
            break;
            
        case SNRefreshControlStyleArrow:
            class = [SNArrowRefreshControl class];
            break;
            
        case SNRefreshControlStyleNormal:
            class = [SNNormalRefreshControl class];
            break;
        case SNRefreshControlStyleCustom:
            class = [SNCustomRefreshControl class];
            break;
        case SNRefreshControlStyleBottomOffset:
            class = [SNArrowRefreshControl class];
            break;
        default:
            class = [SNNormalRefreshControl class];
            break;
    }
    
    SNRefreshControl *refreshControl = [[class alloc] initWithAttachedView:scrollView style:style];
    
    return [refreshControl autorelease];
}

- (void)removeObserver
{
    if (_scrollView) {
        [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
        [_scrollView release], _scrollView = nil;
    }
}

- (CGFloat)bottomOffset:(Style)style
{
    if(SNRefreshControlStyleBottomOffset == style)
    {
        return  40.0;
    }
    return 0.0;
}

- (id)initWithAttachedView:(UIScrollView *)scrollView style:(SNRefreshControlStyle)style
{
    self = [super init];
    if (self) {
        
        _style = style;
        
        _status = SNRefreshControlStatusNormal;
        _pullingStatus = SNRefreshControlPullingStatusNone;
        _lastOffset = 0.0f;
        _scrollView = [scrollView retain];
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
        
        [self initAttributes];
        [self initViews];
       
        _attribute.originalTopInset = _scrollView.contentInset.top + [self bottomOffset:_style];
        _attribute.originalBottomInset = _scrollView.contentInset.bottom ;
    }
    
    return self;
}

- (void)initAttributes
{
    _attribute.timeFontSize = 12.0;
    _attribute.titleFontSize = 13.0;
    
    NSString *ls = NSLocalizedStringFromTable(@"Pull down to refresh...", @"SNRefreshControl", nil);
    CGFloat h1 = [ls sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_attribute.timeFontSize]}].height;
    CGFloat h2 = [ls sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_attribute.titleFontSize]}].height;
    
    _attribute.refreshControlHeight = ([UIScreen mainScreen].bounds.size.height);
    _attribute.refreshControlWidth = ([UIScreen mainScreen].bounds.size.width);
    _attribute.topInterval = 15.0;
    _attribute.middleInterval = 5.0;
    _attribute.bottomInterval = 10.0;
    _attribute.offsetThreshold = 0.0;
    _attribute.contentInsetTop = _attribute.topInterval+h2+_attribute.middleInterval+h1+_attribute.bottomInterval;
    _attribute.triggerOffset = _attribute.contentInsetTop;
}

- (void)initViews
{
    NSString *ls = NSLocalizedStringFromTable(@"Pull down to refresh...", @"SNRefreshControl", nil);
    UIFont * timeFont = [UIFont systemFontOfSize:_attribute.timeFontSize];
    UIFont * titleFont = [UIFont systemFontOfSize:_attribute.titleFontSize];
    
    CGFloat h1 = [ls sizeWithAttributes:@{NSFontAttributeName:timeFont}].height;
    CGFloat h2 = [ls sizeWithAttributes:@{NSFontAttributeName:titleFont}].height;
    
    self.backgroundColor = kCommonBackgroundColor;
    
    self.frame = CGRectMake(0, -_attribute.refreshControlHeight, CGRectGetWidth(_scrollView.frame), _attribute.refreshControlHeight);
    [_scrollView addSubview:self];
    
    //    _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kBackgroungImageName]];
    //    _backgroundView.frame = self.bounds;
    //    [self addSubview:_backgroundView];
    
    //    _bottomShadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kBottomShadowImageName]];
    //    CGRect frame = _bottomShadowView.frame;
    //    frame.size.width = CGRectGetWidth(self.bounds);
    //    frame.origin.x = 0;
    //    frame.origin.y = CGRectGetHeight(self.bounds)-frame.size.height;
    //    _bottomShadowView.frame = frame;
    //    [self addSubview:_bottomShadowView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bounds)-h2-_attribute.middleInterval-h1-_attribute.bottomInterval, CGRectGetWidth(self.bounds), h2)];
    _titleLabel.font = [UIFont systemFontOfSize:_attribute.titleFontSize];
    _titleLabel.text = NSLocalizedStringFromTable(@"Pull down to refresh...", @"SNRefreshControl", nil);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    //    _titleLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    _titleLabel.shadowOffset = CGSizeMake(0.0f, 0.0f);
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_titleLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bounds)-h1-_attribute.bottomInterval, CGRectGetWidth(self.bounds), h1)];
    _timeLabel.font = [UIFont systemFontOfSize:_attribute.timeFontSize];
    _timeLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedStringFromTable(@"Last updated:", @"SNRefreshControl", nil), NSLocalizedStringFromTable(@"Unknow", @"SNRefreshControl", nil)];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    //    _timeLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    _timeLabel.shadowOffset = CGSizeMake(0.0f, 0.0f);
    _timeLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_timeLabel];
}

- (void)reloadUIElements
{
    _titleLabel.textColor = kDarkGrayColor;
    _timeLabel.textColor = kDarkGrayColor;
}

- (void)setBackgroundView:(UIView *)backgroundView
{
    [_backgroundView removeFromSuperview];
    [_backgroundView release];
    _backgroundView = [backgroundView retain];
    _backgroundView.frame = self.bounds;
    [self insertSubview:_backgroundView atIndex:0];
}

- (void)setBottomShadowView:(UIView *)bottomShadowView
{
    [_bottomShadowView removeFromSuperview];
    [_bottomShadowView release];
    _bottomShadowView = [bottomShadowView retain];
    CGRect frame = _bottomShadowView.frame;
    frame.size.width = CGRectGetWidth(self.bounds);
    frame.origin.x = 0;
    frame.origin.y = CGRectGetHeight(self.bounds)-frame.size.height;
    _bottomShadowView.frame = frame;
    if (_backgroundView) {
        [self insertSubview:_bottomShadowView aboveSubview:_backgroundView];
    }
    else {
        [self insertSubview:_bottomShadowView atIndex:0];
    }
}

/**
 * Only availiable for SNRefreshControlStyleArrow
 */
- (void)setArrowWithImageName:(NSString *)arrowImageName
{
    
}

/**
 * Only availiable for SNRefreshControlStyleDrop
 */
- (void)setBorderColor:(UIColor *)color
{
    
}

- (void)setBorderWidth:(CGFloat)width
{
    
}

- (void)setTintColor:(UIColor *)color
{
    
}

- (void)beginRefreshing
{
    if (_status == SNRefreshControlStatusRefreshing) {
        return;
    }
    [self setStatus:SNRefreshControlStatusRefreshing withForce:YES];
}

- (void)endRefreshing
{
    if (_status == SNRefreshControlStatusNormal) {
        return;
    }
    [self setStatus:SNRefreshControlStatusNormal withForce:YES];
}

- (void)refreshLastUpdatedTime:(NSDate *)date
{
    self.lastFreshDate = date;
    NSString *time = nil;
    
	if (date) {
        NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        NSDateComponents *nowComponents = [calendar components:unitFlags fromDate:[NSDate date]];
        NSDateComponents *createdAtComponents = [calendar components:unitFlags fromDate:date];
        if([nowComponents year] == [createdAtComponents year] &&
           [nowComponents month] == [createdAtComponents month] &&
           [nowComponents day] == [createdAtComponents day])
        {
            [dateFormatter setDateFormat:[NSString stringWithFormat:@"'%@ 'HH:mm", NSLocalizedStringFromTable(@"Today", @"SNRefreshControl", nil)]];
            time = [dateFormatter stringFromDate:date];
        }
        else if ([nowComponents year] == [createdAtComponents year]) {
            [dateFormatter setDateFormat:@"MM.dd' 'HH:mm"];
            time = [dateFormatter stringFromDate:date];
        } else {
            [dateFormatter setDateFormat:@"YYYY.MM.dd' 'HH:mm"];
            time = [dateFormatter stringFromDate:date];
        }
        [calendar release];
        [dateFormatter release];
    }
    else {
        time = NSLocalizedStringFromTable(@"Unknow", @"SNRefreshControl", nil);
    }
    
    time = [NSString stringWithFormat:@"%@%@", NSLocalizedStringFromTable(@"Last updated:", @"SNRefreshControl", nil), time];
    _timeLabel.text = time;
}

- (void)setStatus:(SNRefreshControlStatus)status withForce:(BOOL)force
{
    if ((_status == status || _status == SNRefreshControlStatusRefreshing) && !force) {
        return;
    }
    
    _status = status;
    switch (_status) {
        case SNRefreshControlStatusNormal:
        {
            _titleLabel.text = NSLocalizedStringFromTable(@"Pull down to refresh...", @"SNRefreshControl", nil);
            _pullingStatus = SNRefreshControlPullingStatusNone;
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
                UIEdgeInsets contentInset = _scrollView.contentInset;
                contentInset.top = _attribute.originalTopInset;
                _scrollView.contentInset = contentInset;
            } completion:^(BOOL finished) {
                
            }];
            
            [self setNormalStatusWithForce:force];
        }
            break;
            
        case SNRefreshControlStatusRefreshing:
        {
            _titleLabel.text = NSLocalizedStringFromTable(@"Loading...", @"SNRefreshControl", nil);
            _pullingStatus = SNRefreshControlPullingStatusNone;
            if (!force) {
                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
                    UIEdgeInsets contentInset = _scrollView.contentInset;
                    contentInset.top = _attribute.contentInsetTop + _attribute.originalTopInset;
                    _scrollView.contentInset = contentInset;
                } completion:^(BOOL finished) {
                    
                }];
            }
            else {
                UIEdgeInsets contentInset = _scrollView.contentInset;
                CGFloat originalTopInset = _attribute.contentInsetTop + _attribute.originalTopInset;
                contentInset.top = originalTopInset;
                _scrollView.contentInset = contentInset;
                if (_scrollView.contentOffset.y > -originalTopInset) {
                    _scrollView.contentOffset = CGPointMake(0, -originalTopInset);
                }
            }
            
            [self setRefreshingStatusWithForce:force];
            
            if (!force) {
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }
            break;
            
        case SNRefreshControlStatusPulling:
            
            break;
            
        default:
            break;
    }
}

- (void)setNormalStatusWithForce:(BOOL)force
{
    
}

- (void)setRefreshingStatusWithForce:(BOOL)force
{
    
}

- (void)setPullingStatusWithForce:(BOOL)force
{
    
}

- (void)pullWithOffset:(CGFloat)offset pullingStatus:(SNRefreshControlPullingStatus)pullingStatus
{
    if (_status != SNRefreshControlStatusPulling) {
        return;
    }
    
    if (_pullingStatus != pullingStatus || _style == SNRefreshControlStyleDrop || _style == SNRefreshControlStyleActivity || _style == SNRefreshControlStyleCustom) {
        switch (pullingStatus) {
            case SNRefreshControlPullingStatusDown:
                _titleLabel.text = NSLocalizedStringFromTable(@"Pull down to refresh...", @"SNRefreshControl", nil);
                [self setPullingDownStatusWithOffset:offset];
                break;
                
            case SNRefreshControlPullingStatusRelease:
                _titleLabel.text = NSLocalizedStringFromTable(@"Release to refresh...", @"SNRefreshControl", nil);
                [self setPullingReleaseStatusWithOffset:offset];
                break;
                
            case SNRefreshControlPullingStatusNone:
                _titleLabel.text = NSLocalizedStringFromTable(@"Pull down to refresh...", @"SNRefreshControl", nil);
                [self setPullingNoneStatusWithOffset:offset];
                break;
                
            default:
                break;
        }
        
        _pullingStatus = pullingStatus;
    }
}

- (void)setPullingDownStatusWithOffset:(CGFloat)offset
{
    
}

- (void)setPullingReleaseStatusWithOffset:(CGFloat)offset
{
    
}

- (void)setPullingNoneStatusWithOffset:(CGFloat)offset
{
    
}

- (void)setOffset:(CGFloat)offset isDragging:(BOOL)isDragging
{
    if (_status == SNRefreshControlStatusRefreshing) {
        UIEdgeInsets contentInset = _scrollView.contentInset;
        contentInset.top = MIN(MAX(-offset, 0), _attribute.contentInsetTop + _attribute.originalTopInset - [self bottomOffset:_style]);
        _scrollView.contentInset = contentInset;
        return;
    }
    else if (offset > -_attribute.originalTopInset) {
        return;
    }
    
    CGFloat adjustedOffset = offset+_attribute.offsetThreshold + _attribute.originalTopInset;
    if (adjustedOffset >= 0)
    {
        [self setStatus:SNRefreshControlStatusNormal withForce:NO];
        return;
    }
    adjustedOffset = (-adjustedOffset);
    if (isDragging)
    {
        _lastOffset = adjustedOffset;
        [self setStatus:SNRefreshControlStatusPulling withForce:NO];
        if (adjustedOffset + [self bottomOffset:_style] >= _attribute.triggerOffset) {
            [self pullWithOffset:adjustedOffset pullingStatus:SNRefreshControlPullingStatusRelease];
        }
        else
        {
            [self pullWithOffset:adjustedOffset pullingStatus:SNRefreshControlPullingStatusDown];
        }
    }
    else {
        if (adjustedOffset + [self bottomOffset:_style] >= _attribute.triggerOffset || _lastOffset+ [self bottomOffset:_style]>= _attribute.triggerOffset)
        {
            [self setStatus:SNRefreshControlStatusRefreshing withForce:NO];
        }
        else
        {
            [self setStatus:SNRefreshControlStatusNormal withForce:NO];
        }
        _lastOffset = 0.0f;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat newOffset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y;
        BOOL isDragging = [(UIScrollView *)object isDragging];
        [self setOffset:newOffset isDragging:isDragging];
    }
}

@end

#pragma mark - SNRefreshControlStyleNormal

@implementation SNNormalRefreshControl

- (void)dealloc
{
    [_indicatorView release];
    
    [super dealloc];
}

- (void)initAttributes
{
    [super initAttributes];
    
    _normalAttribute.indicatorXCenterLeftPadding = 60.0 * kScreentWidthScale;
    _normalAttribute.indicatorYCenterBottomPadding = _attribute.contentInsetTop/2;
}

- (void)initViews
{
    [super initViews];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.hidesWhenStopped = YES;
    [_indicatorView stopAnimating];
    _indicatorView.center = CGPointMake(_normalAttribute.indicatorXCenterLeftPadding, CGRectGetMaxY(self.bounds)-_normalAttribute.indicatorYCenterBottomPadding);
    [self addSubview:_indicatorView];
}

- (void)setNormalStatusWithForce:(BOOL)force
{
    [_indicatorView stopAnimating];
}

- (void)setRefreshingStatusWithForce:(BOOL)force
{
    [_indicatorView startAnimating];
}

@end

#pragma mark - SNRefreshControlStyleArrow
#define kLablesLeftMargin       21
@implementation SNArrowRefreshControl

- (void)dealloc
{
    [_indicatorView release];
    
    [super dealloc];
}

- (void)setArrowWithImageName:(NSString *)arrowImageName
{
    UIImage *image = [UIImage imageNamed:arrowImageName];
    CALayer *newLayer = [CALayer layer];
    newLayer.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    newLayer.position = CGPointMake(_arrowAttribute.indicatorXCenterLeftPadding, CGRectGetMaxY(self.bounds)-_arrowAttribute.indicatorYCenterBottomPadding);
    newLayer.contentsGravity = kCAGravityResizeAspect;
    newLayer.contents = (id)image.CGImage;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        newLayer.contentsScale = [[UIScreen mainScreen] scale];
    }
#endif
    [self.layer replaceSublayer:_indicatorLayer with:newLayer];
    _indicatorLayer = newLayer;
}

- (void)initAttributes
{
    [super initAttributes];
    
    _attribute.timeFontSize = 10.0;
    _attribute.titleFontSize = 13.0;
    UIFont * timeFont = [UIFont systemFontOfSize:_attribute.timeFontSize];
    UIFont * titleFont = [UIFont systemFontOfSize:_attribute.titleFontSize];
    
    NSString *ls = NSLocalizedStringFromTable(@"Pull down to refresh...", @"SNRefreshControl", nil);
    CGFloat h1 = [ls sizeWithAttributes:@{NSFontAttributeName:timeFont}].height;
    CGFloat h2 = [ls sizeWithAttributes:@{NSFontAttributeName:titleFont}].height;
    
    _attribute.refreshControlHeight = ([UIScreen mainScreen].bounds.size.height);
    _attribute.refreshControlWidth = ([UIScreen mainScreen].bounds.size.width);
    _attribute.topInterval = 15.0;
    _attribute.middleInterval = 2.0;
    
    _attribute.bottomInterval = 15.0 + [self bottomOffset:_style];
    _attribute.offsetThreshold = 0.0;
    _attribute.contentInsetTop = _attribute.topInterval+h2+_attribute.middleInterval+h1+_attribute.bottomInterval;
    _attribute.triggerOffset = _attribute.contentInsetTop;
    _arrowAttribute.indicatorXCenterLeftPadding = 105.0 * kScreentWidthScale;

    _arrowAttribute.indicatorYCenterBottomPadding = (_attribute.contentInsetTop/2) - _attribute.middleInterval + ceil([self bottomOffset:_style]/2.0);
}

- (void)initViews
{
    [super initViews];
    
    UIImage *image = [UIImage imageNamed:kArrowImageName];
    _indicatorLayer = [CALayer layer];
    _indicatorLayer.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    _indicatorLayer.position = CGPointMake(_arrowAttribute.indicatorXCenterLeftPadding, CGRectGetMaxY(self.bounds)-_arrowAttribute.indicatorYCenterBottomPadding- 3);
    _indicatorLayer.contentsGravity = kCAGravityResizeAspect;
    _indicatorLayer.contents = (id)image.CGImage;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        _indicatorLayer.contentsScale = [[UIScreen mainScreen] scale];
    }
#endif
    [self.layer addSublayer:_indicatorLayer];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.hidesWhenStopped = YES;
    [_indicatorView stopAnimating];
    _indicatorView.center = _indicatorLayer.position;
    [self addSubview:_indicatorView];
    
    
    //调整lable的frame
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    CGRect titleLableFrame =  _titleLabel.frame;
    titleLableFrame.origin.x = _arrowAttribute.indicatorXCenterLeftPadding + kLablesLeftMargin;
    titleLableFrame.size.width = CGRectGetWidth(self.bounds)- _arrowAttribute.indicatorXCenterLeftPadding;
    _titleLabel.frame = titleLableFrame;
    
    
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    CGRect timeLableFrame =     _timeLabel.frame;
    timeLableFrame.origin.x = _arrowAttribute.indicatorXCenterLeftPadding + kLablesLeftMargin;
    timeLableFrame.size.width = CGRectGetWidth(self.bounds)- _arrowAttribute.indicatorXCenterLeftPadding;
    _timeLabel.frame = timeLableFrame;
    
    [self reloadUIElements];
}

- (void)reloadUIElements
{
    [super reloadUIElements];
    _indicatorLayer.contents = (id)[UIImage imageNamed:kArrowImageName].CGImage;
}

- (void)setNormalStatusWithForce:(BOOL)force
{
    [CATransaction setDisableActions:YES];
    _indicatorLayer.transform = CATransform3DIdentity;
    _indicatorLayer.hidden = NO;
    [CATransaction setDisableActions:NO];
    
    [_indicatorView stopAnimating];
}

- (void)setRefreshingStatusWithForce:(BOOL)force
{
    [CATransaction setDisableActions:YES];
    _indicatorLayer.hidden = YES;
    _indicatorLayer.transform = CATransform3DIdentity;
    [CATransaction setDisableActions:NO];
    
    [_indicatorView startAnimating];
}

- (void)setPullingDownStatusWithOffset:(CGFloat)offset
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.15];
    _indicatorLayer.transform = CATransform3DIdentity;
    [CATransaction commit];
}

- (void)setPullingNoneStatusWithOffset:(CGFloat)offset
{
    [self setPullingDownStatusWithOffset:offset];
}

- (void)setPullingReleaseStatusWithOffset:(CGFloat)offset
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.15];
    _indicatorLayer.transform = CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f);
    [CATransaction commit];
}

@end

#pragma mark - SNRefreshControlStyleCustom
#define kDrawingImgStartNumber      60001
#define kDrawingImgEndNumber        60045
#define kLoadingImgStartNumber      60045
#define kLoadingImgEndNumber        60117
#define kFirstAnimationDuration     0.5
@implementation SNCustomRefreshControl


- (void)dealloc
{
    [_indicatorView release];       _indicatorView          = nil;
    [_drawingImgs release];         _drawingImgs            = nil;
    [_loadingImgs release];         _loadingImgs            = nil;
    [super dealloc];
}


- (void)initAttributes
{
    [super initAttributes];
    
    _isDoAnimatin = NO;
    _attribute.timeFontSize = 12.0;
    _attribute.titleFontSize = 13.0;
    UIFont * timeFont = [UIFont systemFontOfSize:_attribute.timeFontSize];
    UIFont * titleFont = [UIFont systemFontOfSize:_attribute.titleFontSize];
    
    NSString *ls = NSLocalizedStringFromTable(@"Pull down to refresh...", @"SNRefreshControl", nil);
//    CGFloat h1 = [ls sizeWithFont:[UIFont systemFontOfSize:_attribute.timeFontSize]].height;
//    CGFloat h2 = [ls sizeWithFont:[UIFont systemFontOfSize:_attribute.titleFontSize]].height;
    CGFloat h1 = [ls sizeWithAttributes:@{NSFontAttributeName:timeFont}].height;
    CGFloat h2 = [ls sizeWithAttributes:@{NSFontAttributeName:titleFont}].height;
    
    _attribute.refreshControlHeight = ([UIScreen mainScreen].bounds.size.height);
    _attribute.refreshControlWidth = ([UIScreen mainScreen].bounds.size.width);
    _attribute.topInterval = 15.0;
    _attribute.middleInterval = 5.0;
    _attribute.bottomInterval = 10.0;
    _attribute.offsetThreshold = 0.0;
    _attribute.contentInsetTop = _attribute.topInterval+h2+_attribute.middleInterval+h1+_attribute.bottomInterval;
    _attribute.triggerOffset = _attribute.contentInsetTop;
    
    _arrowAttribute.indicatorXCenterLeftPadding = 60.0 * kScreentWidthScale;
    _arrowAttribute.indicatorYCenterBottomPadding = _attribute.contentInsetTop/2;
}

- (void)initViews
{
    [super initViews];
//    _customRefreshView  = [[SNCustomRefreshView alloc] initWithFrame:CGRectMake(_arrowAttribute.indicatorXCenterLeftPadding + 8, CGRectGetMaxY(self.bounds)-_arrowAttribute.indicatorYCenterBottomPadding - 12.5, 30, 30)];
//    [self addSubview:_customRefreshView];
    
    
    _indicatorView = [[UIImageView alloc] initWithFrame:CGRectMake(_arrowAttribute.indicatorXCenterLeftPadding, CGRectGetMaxY(self.bounds)-_arrowAttribute.indicatorYCenterBottomPadding - 16 , 45, 45)];
    [_indicatorView setBackgroundColor:[UIColor clearColor]];
    
    
    _drawingImgs = [[NSMutableArray alloc] initWithCapacity:1];
    _loadingImgs = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (int i = kDrawingImgStartNumber; i <= kDrawingImgEndNumber; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]];
        if (image != nil) {
            [_drawingImgs addObject:image];
        }
    }
    
    for (int i = kLoadingImgStartNumber; i <= kLoadingImgEndNumber; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]];
        if (image != nil) {
            [_loadingImgs addObject:image];
        }
    }
    
    [self addSubview:_indicatorView];
    
    [self reloadUIElements];
}

- (void)reloadUIElements
{
    [super reloadUIElements];
}

- (void)setNormalStatusWithForce:(BOOL)force
{
//    _indicatorView.hidden = YES;
//    [_indicatorView stopAnimating];
//    _customRefreshView.offset = 0;
//    [_customRefreshView setNeedsDisplay];
    
}

- (void)setRefreshingStatusWithForce:(BOOL)force
{
    if (_isDoAnimatin) {
        _indicatorView.hidden = NO;
        [_indicatorView startAnimating];
    }
}

- (void)setPullingDownStatusWithOffset:(CGFloat)aOffset
{
//    _indicatorView.animationImages = loadingImgs;
//    _indicatorView.animationDuration = 2.3;
//    _indicatorView.animationRepeatCount = HUGE_VAL;
//    _indicatorView.hidden = YES;
    
//    CGFloat offset = -(self.scrollView.contentOffset.y + self.originalContentInsectY);
//    CGFloat offset = - aOffset;
//    CGFloat percent = 0;
//    if (offset < 0) {
//        offset = 0;
//    }
//    if (offset > 65) {
//        offset = 65;
//    }
//    
//    percent = offset / 65;
//    NSUInteger drawingIndex = percent * (_drawingImgs.count - 1);
//    
//    [_indicatorView stopAnimating];
//    _indicatorView.image = _drawingImgs[drawingIndex];
}

- (void)setPullingNoneStatusWithOffset:(CGFloat)offset
{
    [self setPullingDownStatusWithOffset:offset];
}

- (void)setPullingReleaseStatusWithOffset:(CGFloat)offset
{
    _isDoAnimatin = YES;
}

#pragma mark UIScrollViewDelegate
@end


#pragma mark - SNRefreshControlStyleDrop

@implementation SNDropRefreshContorl

- (void)dealloc
{
    CFRelease(defaultPath);
    
    [super dealloc];
}

- (void)setBorderColor:(UIColor *)color
{
    _shapeLayer.strokeColor = [color CGColor];
}

- (void)setBorderWidth:(CGFloat)width
{
    _shapeLayer.lineWidth = width;
}

- (void)setTintColor:(UIColor *)color
{
    _shapeLayer.fillColor = [color CGColor];
}

- (void)initAttributes
{
    [super initAttributes];
    
    _attribute.timeFontSize = 10.0;
    _attribute.titleFontSize = 11.0;
    UIFont * timeFont = [UIFont systemFontOfSize:_attribute.timeFontSize];
    UIFont * titleFont = [UIFont systemFontOfSize:_attribute.titleFontSize];
    
    NSString *ls = NSLocalizedStringFromTable(@"Pull down to refresh...", @"SNRefreshControl", nil);
//    CGFloat h1 = [ls sizeWithFont:[UIFont systemFontOfSize:_attribute.timeFontSize]].height;
//    CGFloat h2 = [ls sizeWithFont:[UIFont systemFontOfSize:_attribute.titleFontSize]].height;
    CGFloat h1 = [ls sizeWithAttributes:@{NSFontAttributeName:timeFont}].height;
    CGFloat h2 = [ls sizeWithAttributes:@{NSFontAttributeName:titleFont}].height;
    
    _dropAttribute.radius = 17.0;
    _dropAttribute.radiusOneCoefficient = 0.8;
    _dropAttribute.radiusTwoCoefficient = 0.1;
    _dropAttribute.shapeLayerHeight = _dropAttribute.radius*2;
    _dropAttribute.shapeLayerWidth = _dropAttribute.radius*2;
    _dropAttribute.offsetAdjust = 10.0;
    _dropAttribute.addCurveThreshold = 7.0;
    _dropAttribute.paddingToTitleLabel = 5.0;
    
    _attribute.topInterval = 7.0;
    _attribute.middleInterval = 0.0;
    _attribute.bottomInterval = 5.0;
    _attribute.contentInsetTop = _attribute.topInterval+_dropAttribute.shapeLayerHeight+_dropAttribute.paddingToTitleLabel+h2+_attribute.middleInterval+h1+_attribute.bottomInterval;
    _attribute.offsetThreshold = _attribute.contentInsetTop;
    _attribute.triggerOffset = 30.0;
    
    _dropAttribute.shapeLayerYCenterBottomPadding = _dropAttribute.radius+_dropAttribute.paddingToTitleLabel+h2+_attribute.middleInterval+h1+_attribute.bottomInterval;
}

- (void)initViews
{
    [super initViews];
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.fillColor = [UIColor lightGrayColor].CGColor;
    _shapeLayer.strokeColor = [UIColor grayColor].CGColor;
    _shapeLayer.lineWidth = 1.0f;
    _shapeLayer.bounds = CGRectMake(0, 0, _dropAttribute.shapeLayerWidth, _dropAttribute.shapeLayerHeight);
    _shapeLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds)-_dropAttribute.shapeLayerYCenterBottomPadding);
    _shapeLayer.path = [self defaultPath];
    [self.layer addSublayer:_shapeLayer];
    
    UIImage *image = [UIImage imageNamed:kRefreshImageName];
    _indicatorLayer = [CALayer layer];
    _indicatorLayer.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    _indicatorLayer.position = CGPointMake(CGRectGetMidX(_shapeLayer.bounds), CGRectGetMidY(_shapeLayer.bounds));
    _indicatorLayer.contents = (id)image.CGImage;
    [_shapeLayer addSublayer:_indicatorLayer];
}

- (void)setNormalStatusWithForce:(BOOL)force
{
    [_shapeLayer removeAllAnimations];
    [_indicatorLayer removeAllAnimations];
    _indicatorLayer.transform = CATransform3DIdentity;
    [CATransaction setDisableActions:YES];
    _shapeLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds)-_dropAttribute.shapeLayerYCenterBottomPadding);
    _shapeLayer.path = [self defaultPath];
    [CATransaction setDisableActions:NO];
}

- (void)setRefreshingStatusWithForce:(BOOL)force
{
    [_shapeLayer removeAllAnimations];
    [_indicatorLayer removeAllAnimations];
    _indicatorLayer.transform = CATransform3DIdentity;
    [CATransaction setDisableActions:YES];
    _shapeLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds)-_dropAttribute.shapeLayerYCenterBottomPadding);
    _shapeLayer.path = [self defaultPath];
    [CATransaction setDisableActions:NO];
    if (!force) {
        [self addAnimationForBounce];
        [self addAnimationForRotation];
    }
    else {
        [self addAnimationForRotation];
    }
}

- (void)setPullingDownStatusWithOffset:(CGFloat)offset
{
    [CATransaction setDisableActions:YES];
    _shapeLayer.path = [self pathWithOffset:offset];
    _shapeLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds)-_dropAttribute.shapeLayerYCenterBottomPadding-offset);
    [CATransaction setDisableActions:NO];
}

- (void)setPullingReleaseStatusWithOffset:(CGFloat)offset
{
    [self setPullingDownStatusWithOffset:offset];
}

- (void)setPullingNoneStatusWithOffset:(CGFloat)offset
{
    [self setPullingDownStatusWithOffset:offset];
}

#pragma mark - Animation

- (void)addAnimationForBounce
{
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.duration = 0.5;
    bounceAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.01], [NSNumber numberWithFloat:1.2], [NSNumber numberWithFloat:0.9], [NSNumber numberWithFloat:1.0], nil];
    bounceAnimation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.6], [NSNumber numberWithFloat:0.9], [NSNumber numberWithFloat:1.0], nil];
    [_shapeLayer addAnimation:bounceAnimation forKey:@"BounceAnimation"];
}

- (void)addAnimationForRotation
{
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.duration = 0.8;
    rotateAnimation.removedOnCompletion = NO;
    rotateAnimation.repeatCount = HUGE_VALF;
    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:M_PI*2], nil];
    [_indicatorLayer addAnimation:rotateAnimation forKey:@"RotateAnimation"];
}

#pragma mark - Path

- (CGPathRef)defaultPath
{
    if (defaultPath == NULL) {
        CGPoint center = CGPointMake(CGRectGetWidth(_shapeLayer.bounds)/2, _dropAttribute.radius);
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path addArcWithCenter:center
                        radius:_dropAttribute.radius
                    startAngle:0
                      endAngle:M_PI
                     clockwise:NO];
        
        [path addArcWithCenter:center
                        radius:_dropAttribute.radius
                    startAngle:M_PI
                      endAngle:0
                     clockwise:NO];
        
        [path closePath];
        
        defaultPath = CFRetain(path.CGPath);
    }
    
    return defaultPath;
}

- (CGPathRef)pathWithOffset:(CGFloat)offset
{
    CGFloat coefficient = offset/_attribute.triggerOffset;
    coefficient = MIN(coefficient, 1.0);
    
    CGFloat percent = 1-(1-_dropAttribute.radiusOneCoefficient)*coefficient;
    CGFloat newRadiusOne = _dropAttribute.radius*percent;
    
    _indicatorLayer.transform = CATransform3DMakeScale(percent, percent, 1.0);
    
    percent = 1-(1-_dropAttribute.radiusTwoCoefficient)*coefficient;
    CGFloat newRadiusTwo = _dropAttribute.radius*percent;
    
    CGFloat adjustedOffset = offset+coefficient*_dropAttribute.offsetAdjust;
    
    CGFloat radian = M_PI_2-acos((newRadiusOne-newRadiusTwo)/(adjustedOffset));
    
    BOOL addCurve = adjustedOffset > _dropAttribute.addCurveThreshold;
    
    CGFloat radianOne = (addCurve) ? MAX(radian, M_PI/6) : radian;
    CGFloat radianTwo = (addCurve) ? MIN(radian, M_PI/6) : radian;
    
    CGPoint centerOne = CGPointMake(CGRectGetWidth(_shapeLayer.bounds)/2, _dropAttribute.radius);
    CGPoint centerTwo = CGPointMake(CGRectGetWidth(_shapeLayer.bounds)/2, _dropAttribute.radius+adjustedOffset);
    
    CGPoint controlPointOne, controlPointTwo, controlPointThree, controlPointFour, pointThree, pointOne;
    if (addCurve) {
        CGFloat widthOne = newRadiusOne*cos(radianOne);
        CGFloat widthTwo = newRadiusTwo*cos(radianTwo);
        pointThree = CGPointMake(CGRectGetWidth(_shapeLayer.bounds)/2-widthTwo, centerTwo.y+newRadiusTwo*sin(radianTwo));
        pointOne = CGPointMake(CGRectGetWidth(_shapeLayer.bounds)/2+widthOne, centerOne.y+newRadiusOne*sin(radianOne));
        
        CGFloat dWidth = widthOne-widthTwo;
        CGFloat dWidthOne = dWidth*0.8;
        CGFloat dWidthTwo = dWidth*0.2;
        CGFloat dHeightOne = newRadiusOne*sin(acos((widthOne-dWidthOne)/newRadiusOne))+adjustedOffset*0.1;
        controlPointOne = CGPointMake(CGRectGetWidth(_shapeLayer.bounds)/2-widthOne+dWidthOne, centerOne.y+dHeightOne);
        controlPointTwo = CGPointMake(CGRectGetWidth(_shapeLayer.bounds)/2-widthTwo-dWidthTwo, centerTwo.y);
        controlPointThree = CGPointMake(CGRectGetWidth(_shapeLayer.bounds)/2+widthTwo+dWidthTwo, centerTwo.y);
        controlPointFour = CGPointMake(CGRectGetWidth(_shapeLayer.bounds)/2+widthOne-dWidthOne, centerOne.y+dHeightOne);
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path addArcWithCenter:centerOne
                    radius:newRadiusOne
                startAngle:radianOne
                  endAngle:M_PI-radianOne
                 clockwise:NO];
    
    if (addCurve) {
        [path addCurveToPoint:pointThree controlPoint1:controlPointOne controlPoint2:controlPointTwo];
    }
    
    [path addArcWithCenter:centerTwo
                    radius:newRadiusTwo
                startAngle:M_PI-radianTwo
                  endAngle:radianTwo
                 clockwise:NO];
    
    if (addCurve) {
        [path addCurveToPoint:pointOne controlPoint1:controlPointThree controlPoint2:controlPointFour];
    }
    
	[path closePath];
    
    return path.CGPath;
}

@end



