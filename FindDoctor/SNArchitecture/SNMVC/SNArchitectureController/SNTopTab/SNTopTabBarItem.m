//
//  SNTabBarItem.m
//  tabbar
//
//  Created by nova on 12-12-25.
//  Copyright (c) 2012年 SINA. All rights reserved.
//

#import "SNTopTabBarItem.h"
//#import "SNBadgeView.h"

#define kSNBadgeButtonImageTopMargin     0
#define kSNBadgeButtonImageRightMargin   25

@implementation SNTopTabBarItem

#pragma mark life cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _showTitle = YES;
        self.adjustsImageWhenHighlighted = NO;
        
        self.titleLabel.font = [UIFont systemFontOfSize:kSNTabBarItemTitleFontSize];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return self;
}

- (void)dealloc
{
    
}

#pragma mark Override from Super Class
//- (void)setSelected:(BOOL)selected
//{
//    [super setSelected:selected];
//    if (selected) {
//        [self setImage:self.selectedImage forState:UIControlStateNormal];
//        [self setImage:self.selectedImage forState:UIControlStateHighlighted];
//        [self setImage:self.selectedImage forState:UIControlStateSelected];
//        [self setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];
//    }
//    else {
//        [self setImage:self.image forState:UIControlStateNormal];
//        [self setImage:self.image forState:UIControlStateHighlighted];
//        [self setImage:self.image forState:UIControlStateSelected];
//        [self setTitleColor:self.titleColor forState:UIControlStateNormal];
//    }
//}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (_badgeView) {
        [self layoutBadgeView];
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect imageRect = contentRect;

    imageRect.origin.x = (imageRect.size.width - self.image.size.width) * 0.5;
    imageRect.origin.y = 3;
    imageRect.size = self.image.size;
    
    return imageRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect titleRect = contentRect;
	if (!self.showTitle)
	{
		titleRect = CGRectZero;
	}
	else if (self.image)
	{
        CGSize size = [self.title sizeWithFont:[UIFont systemFontOfSize:kSNTabBarItemTitleFontSize]];
        titleRect = CGRectMake(0, CGRectGetHeight(titleRect) - size.height - 1, CGRectGetWidth(titleRect), size.height);
	}
	
	return CGRectIntegral(titleRect);
}

#pragma mark - Synthesize

- (void)setShowTitle:(BOOL)showTitle
{
    if (_showTitle != showTitle) {
        _showTitle = showTitle;
        
        [self setNeedsLayout];
    }
}


- (void)setImage:(UIImage *)image
{
    _image = image;
    
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setHighlightedImage:(UIImage *)highlightedImage
{
    _highlightedImage = highlightedImage;
    
    [self setImage:highlightedImage forState:UIControlStateHighlighted];
}

- (void)setSelectedImage:(UIImage *)selectedImage
{
    _selectedImage = selectedImage;
    
    [self setImage:selectedImage forState:UIControlStateSelected];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setHighlightedTitleColor:(UIColor *)highlightedTitleColor
{
    _highlightedTitleColor = highlightedTitleColor;
    
    [self setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    _selectedTitleColor = selectedTitleColor;
    
    [self setTitleColor:selectedTitleColor forState:UIControlStateSelected];
}

#pragma mark Badge

- (void)showBadge
{
    [self setBadgeImage:[UIImage imageNamed:@"slidetab_badge.png"]];
}

- (void)hideBadge
{
    [self setBadgeImage:nil];
}


- (void)setBadgeImage:(UIImage *)badgeImage
{
    if (_badgeImage != badgeImage)
    {
        _badgeImage = badgeImage;
        
        [self changeBadgeImage:badgeImage];
        
        [self setNeedsLayout];
    }
}

- (void)changeBadgeImage:(UIImage *)badgeImage
{
    if (badgeImage)
    {
        if (!_badgeView)
        {
//            _badgeView = [[SNBadgeView alloc] initWithImage:badgeImage badgeType:SNBadgeViewIcon autoStrech:NO];
//            [self addSubview:_badgeView];
        }
        
        _badgeView.image = badgeImage;
        
        [self layoutBadgeView];
    }
    else
    {
        if (_badgeView)
        {
            [_badgeView removeFromSuperview];
            [self setNeedsLayout];
        }
    }
}

- (void)layoutBadgeView
{
    CGSize imageSize = _badgeView.image.size;
    
    CGRect badgeFrame = self.bounds;
    badgeFrame.origin.y += kSNBadgeButtonImageTopMargin;
    badgeFrame.origin.x = MAX(0,badgeFrame.size.width - kSNBadgeButtonImageRightMargin);
    badgeFrame.size = imageSize;
    
    _badgeView.frame = badgeFrame;
}
@end
