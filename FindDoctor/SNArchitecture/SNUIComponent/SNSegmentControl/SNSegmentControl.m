//
//  SNSegmentControl.m
//  CoreDemo
//
//  Created by xiaofang wu on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SNSegmentControl.h"

@interface SNSegmentControl()
@property (nonatomic,assign) NSInteger      preSegmentIndex;
@property (nonatomic,strong) NSMutableArray *segmentArray;
- (void) segmentButtonPress:(UIButton*) button;

- (void) layoutSegments;
@end


@implementation SNSegmentControl

@synthesize segmentControlDelegate = _segmentControlDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.segmentArray = [NSMutableArray arrayWithCapacity:0];
        self.preSegmentIndex = -1;
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
- (void) dealloc
{
    _segmentControlDelegate = nil;
}

- (void) insertSegmentWithButton:(UIButton*) button  andIndex:(NSInteger)  index
{
    if(button)
    {
        [_segmentArray insertObject:button atIndex:index];
        [button addTarget:self action:@selector(segmentButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self layoutSegments];
    }
}

-(void)setSegmentButtonTitle:(NSString *)title withIndex:(NSInteger)index
{
    [ (UIButton*)[_segmentArray objectAtIndex:index] setTitle:title forState:UIControlStateNormal];
}

- (void) removeSegmentWithIndex:(NSInteger) index
{
    if(index < [_segmentArray count])
    {
        [_segmentArray removeObjectAtIndex:index];
        [self layoutSegments];
    }
}

- (void)setSegmentControlStateNormal
{
    for (UIButton *button in _segmentArray) {
        [button setSelected:NO];
    }
    self.preSegmentIndex = -1;
}

- (void)setSegmentControlShouldSelect
{
    self.preSegmentIndex = -1;
}

- (void) segmentButtonPress:(UIButton*) button
{
    if(_preSegmentIndex != button.tag)
    {
        if(_preSegmentIndex >=0 && _preSegmentIndex < [_segmentArray count])
        {
           [ (UIButton*)[_segmentArray objectAtIndex:_preSegmentIndex] setSelected:NO];
        }
        [button setSelected:YES];
        _preSegmentIndex = button.tag;
        if(_segmentControlDelegate && [_segmentControlDelegate respondsToSelector:@selector(segmentSelectWithIndex:)])
        {
            [_segmentControlDelegate segmentSelectWithIndex:button.tag];
        }
    }
}

- (void)layoutSegments
{
    CGFloat  segmentCount = [_segmentArray count];
    CGFloat    width = segmentCount == 0?0:self.bounds.size.width /segmentCount;
    [_segmentArray enumerateObjectsUsingBlock:^(UIButton* obj, NSUInteger idx, BOOL *stop) {
        CGRect    frame = CGRectMake(idx * width, 0, width, self.bounds.size.height);
        obj.frame = frame;
        obj.tag = idx;
    }];
}

- (void) selectSegmentWithIndex:(NSInteger) index
{
    if(index < [_segmentArray count])
    {
        [self segmentButtonPress:[_segmentArray objectAtIndex:index]];
    }
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self layoutSegments];
}
@end
