//
//  SNTabBar.m
//  tabbar
//
//  Created by nova on 12-12-25.
//  Copyright (c) 2012年 SINA. All rights reserved.
//

#import "SNTopTabBar.h"
#import "UIImage+Stretch.h"

#define kTabBarItemYOffset 0

@interface SNTopTabBar ()
{
    UIImageView           *_backgroundView;
    UIImageView           *_shadowView;
    UIImageView           *_selectionIndicatorView;
    
    NSMutableArray        *_buttonItems;
    UIView                *_bottemLine;
}

@property (nonatomic, retain) NSMutableArray *buttonItems;

- (void)initTabBarItems;
- (void)didClickTabBarItem:(SNTopTabBarItem *)item;
- (void)setSelectedItem:(SNTopTabBarItem *)selectedItem animated:(BOOL)animated;

@end

@implementation SNTopTabBar

#pragma mark life cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _buttonItems = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

- (void)dealloc
{
    
}

#pragma mark Synthesize
- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    
    if (backgroundImage) {
        if (!_backgroundView) {
            _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
            [self insertSubview:_backgroundView atIndex:0];
        }
        
        _backgroundView.image = [backgroundImage stretchableImageByCenter];
    }
    else {
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
    }
}

- (void)setShadowImage:(UIImage *)shadowImage
{
    _shadowImage = shadowImage;
    
    if (shadowImage) {
        if (!_shadowView) {
            _shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - shadowImage.size.height, CGRectGetWidth(self.bounds), shadowImage.size.height)];
            [self addSubview:_shadowView];
        }
        
        _shadowView.image = [shadowImage stretchableImageByWidthCenter];
    }
    else {
        [_shadowView removeFromSuperview];
        _shadowView = nil;
    }
}

- (void)setSelectionIndicatorImage:(UIImage *)selectionIndicatorImage
{
    _selectionIndicatorImage = selectionIndicatorImage;
    
    if (selectionIndicatorImage) {
        if (!_selectionIndicatorView) {
            CGRect frame = CGRectZero;
            if (self.selectedItem) {
                frame = self.selectedItem.frame;
            }
            _selectionIndicatorView = [[UIImageView alloc] initWithFrame:frame];
            if (_backgroundView) {
                [self insertSubview:_selectionIndicatorView aboveSubview:_backgroundView];
            }
            else {
                [self insertSubview:_selectionIndicatorView atIndex:0];
            }
        }
        
        _selectionIndicatorView.image = [selectionIndicatorImage stretchableImageByCenter];
    }
    else {
        [_selectionIndicatorView removeFromSuperview];
        _selectionIndicatorView = nil;
    }
}

- (NSUInteger)selectedIndex
{
    return [self.items indexOfObject:self.selectedItem];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (selectedIndex < self.items.count && self.selectedIndex != selectedIndex) {
        [self setSelectedItem:[self.items objectAtIndex:selectedIndex] animated:NO];
    }
}

- (void)setItems:(NSArray *)items animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.items = items;
        } completion:^(BOOL finished) {
            
        }];
    }
    else {
        self.items = items;
    }
}

- (void)setItems:(NSArray *)items
{
    if (![_items isEqualToArray:items]) {
        _items = items;
        
        [self initTabBarItems];
    }
}

- (void)setSelectedItem:(SNTopTabBarItem *)selectedItem animated:(BOOL)animated
{
    if ([self.selectedItem isEqual:selectedItem]) {
        [self.selectedItem setSelected:YES];
    }
    else {
        [self.selectedItem setSelected:NO];
        [selectedItem setSelected:YES];
        
        self.selectedItem = selectedItem;
    }
    
    [self moveBottomLineWithItem:self.selectedItem animated:animated];
}

- (void)initTabBarItems
{
    [self setSelectedItem:nil animated:NO];
    [self.buttonItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttonItems removeAllObjects];
    [_bottemLine removeFromSuperview];
    
    NSUInteger count = [self.items count];
    
    CGFloat itemWidht = self.bounds.size.width/count;
    CGFloat itemHeight = self.bounds.size.height - kTabBarItemYOffset;
    for (int i = 0; i < self.items.count; i++)
    {
        SNTopTabBarItem *item = [self.items objectAtIndex:i];
        item.frame = CGRectMake(itemWidht*i, kTabBarItemYOffset, itemWidht, itemHeight);
        [item addTarget:self action:@selector(didClickTabBarItem:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:item];
        [self.buttonItems addObject:item];
        
        if (i == 0) {
            [self setSelectedItem:item animated:NO];
        }
    }
    
    if (_shadowView) {
        [self bringSubviewToFront:_shadowView];
    }
    
    if (self.showBottomLine) {
        _bottemLine = [[UIView alloc] init];
        _bottemLine.hidden = YES;
        _bottemLine.userInteractionEnabled = NO;
        [self addSubview:_bottemLine];
        
        if (self.items.count) {
            SNTopTabBarItem *item = [self.items objectAtIndex:0];
            
            _bottemLine.backgroundColor = item.selectedTitleColor ? item.selectedTitleColor : item.titleColor;
            [self moveBottomLineWithItem:item animated:NO];
        }
    }
}

- (void)moveBottomLineWithItem:(SNTopTabBarItem *)item animated:(BOOL)animated
{
    if (!self.showBottomLine) {
        _bottemLine.hidden = YES;
        return;
    }
    
    _bottemLine.hidden = NO;
    
    CGFloat lineOriginX = 16.0;
    if (self.bottomLineWidth > 0) {
        lineOriginX = (CGRectGetWidth(item.bounds) - self.bottomLineWidth) / 2;
    }
    CGRect frame = CGRectMake(item.frameX + lineOriginX, CGRectGetHeight(item.bounds) - 3, CGRectGetWidth(item.bounds) - lineOriginX * 2, 3);
    
    if (animated) {
        [UIView animateWithDuration:.3 animations:^{
            _bottemLine.frame = frame;
        }];
    }
    else {
        _bottemLine.frame = frame;
    }
}

- (void)didClickTabBarItem:(SNTopTabBarItem *)item
{
    [self setSelectedItem:item animated:YES];
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectItemAtIndex:tabBarItem:)]) {
        [self.delegate tabBar:self didSelectItemAtIndex:[self.items indexOfObject:item] tabBarItem:item];
    }
}

@end
