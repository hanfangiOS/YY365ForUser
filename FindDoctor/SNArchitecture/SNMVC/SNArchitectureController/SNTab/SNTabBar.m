//
//  SNTabBar.m
//  tabbar
//
//  Created by nova on 12-12-25.
//  Copyright (c) 2012年 SINA. All rights reserved.
//

#import "SNTabBar.h"
#import "UIImage+Stretch.h"

#define kTabBarItemYOffset 0

@interface SNTabBar ()
{
    UIImageView           *_backgroundView;
    UIImageView           *_shadowView;
    UIImageView           *_selectionIndicatorView;
    
    NSMutableArray        *_buttonItems;
    
}

@property (nonatomic, retain) NSMutableArray *buttonItems;

- (void)initTabBarItems;
- (void)didClickTabBarItem:(SNTabBarItem *)item;
- (void)setSelectedItem:(SNTabBarItem *)selectedItem animated:(BOOL)animated;

@end

@implementation SNTabBar

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
            _shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -shadowImage.size.height, CGRectGetWidth(self.bounds), shadowImage.size.height)];
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

- (void)setSelectedItem:(SNTabBarItem *)selectedItem animated:(BOOL)animated
{
    if ([self.selectedItem isEqual:selectedItem]) {
        [self.selectedItem setSelected:YES];
    }
    else {
        [self.selectedItem setSelected:NO];
        [selectedItem setSelected:YES];
        
        self.selectedItem = selectedItem;
    }
}

- (void)initTabBarItems
{
    [self setSelectedItem:nil animated:NO];
    [self.buttonItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttonItems removeAllObjects];
    
    NSUInteger count = [self.items count];
	
	CGFloat itemWidht = self.bounds.size.width/count;
	CGFloat itemHeight = self.bounds.size.height - kTabBarItemYOffset;
    for (int i = 0; i < self.items.count; i++)
    {
        SNTabBarItem *item = [self.items objectAtIndex:i];
        item.frame = CGRectMake(itemWidht*i, kTabBarItemYOffset, itemWidht, itemHeight);
        [item addTarget:self action:@selector(didClickTabBarItem:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:item];
        [self.buttonItems addObject:item];
        
        if (i == 0) {
            [self setSelectedItem:item animated:NO];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)didClickTabBarItem:(SNTabBarItem *)item
{
    [self setSelectedItem:item animated:YES];
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectItemAtIndex:tabBarItem:)]) {
        [self.delegate tabBar:self didSelectItemAtIndex:[self.items indexOfObject:item] tabBarItem:item];
    }
}

@end
