//
//  ABELTableViewIndex.m
//  ABELTableViewDemo
//
//  Created by abel on 14-4-28.
//  Copyright (c) 2014年 abel. All rights reserved.
//

#import "BATableViewIndex.h"

#if !__has_feature(objc_arc)
#error AIMTableViewIndexBar must be built with ARC.
// You can turn on ARC for only AIMTableViewIndexBar files by adding -fobjc-arc to the build phase for each of its files.
#endif

#define RGBColor(r,g,b)    [UIColor colorWithRed:(double)r/255.0f green:(double)g/255.0f blue:(double)b/255.0f alpha:1]

#define RGBAColor(r,g,b,a)  [UIColor colorWithRed:(double)r/255.0f green:(double)g/255.0f blue:(double)b/255.0f alpha:a]

#define Is_IPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ([[UIScreen mainScreen] currentMode].size.height > 960) : NO)

#define kBA_BgWidth        20.0

#define kBA_TopPadding     (Is_IPhone5 ? 4.0 : 3.0)
#define kBA_letterHeight   (Is_IPhone5 ? 12.0 : 11.0)
#define kBA_letterSpace    (Is_IPhone5 ? 4.0 : 3.0)

#define kBA_letterFontSize (Is_IPhone5 ? 12.0 : 11.0)

@interface BATableViewIndex ()

@property (nonatomic, strong) NSArray *letters;

@end


@implementation BATableViewIndex
{
    BOOL isLayedOut;
    CAShapeLayer *shapeLayer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.letterColor = [UIColor blackColor];
        self.shapeColor = [UIColor clearColor];
        self.shapeFrame = self.bounds;
        self.shapeCornerRadius = 0;
        
        self.topPadding = kBA_TopPadding;
        self.letterHeight = kBA_letterHeight;
        self.letterSpace = kBA_letterSpace;
        self.letterFontSize = kBA_letterFontSize;
    }
    
    return self;
}

- (void)setup {
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 1.0f;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineJoin = kCALineCapSquare;
    shapeLayer.strokeColor = [[UIColor clearColor] CGColor];
    shapeLayer.strokeEnd = 1.0f;
    self.layer.masksToBounds = NO;
}

- (void)reloadData
{
    if (self.tableViewIndexDelegate == nil) {
        return;
    }
    
    self.letters = [self.tableViewIndexDelegate tableViewIndexTitle:self];
    isLayedOut = NO;
    [self layoutSubviews];
}

- (void)resetFrame
{
    // 自适应高度
    CGRect rect = self.frame;
    rect.size.height = self.letters.count * self.letterHeight + (self.letters.count - 1) * self.letterSpace + 2 * self.topPadding;
    self.frame = rect;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self resetFrame];
    [self setup];
    
    if (!isLayedOut){
        
        [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        
        shapeLayer.frame = self.shapeFrame;;
        shapeLayer.backgroundColor = self.shapeColor.CGColor;
        shapeLayer.cornerRadius = self.shapeCornerRadius;
        shapeLayer.masksToBounds = YES;
        [self.layer addSublayer:shapeLayer];
        
        for (NSInteger i = 0; i < self.letters.count; i ++) {
            CGRect textRect = CGRectMake(0, self.topPadding + i * (self.letterHeight + self.letterSpace), CGRectGetWidth(self.bounds), self.letterHeight);
            
            CATextLayer *ctl = [self textLayerWithSize:self.letterFontSize
                                                string:self.letters[i]
                                              andFrame:textRect];
            [self.layer addSublayer:ctl];
        }
        
        isLayedOut = YES;
    }
}

- (CATextLayer *)textLayerWithSize:(CGFloat)size string:(NSString*)string andFrame:(CGRect)frame{
    CATextLayer *tl = [CATextLayer layer];
    [tl setFont:@"ArialMT"];
    [tl setFontSize:size];
    [tl setFrame:frame];
    [tl setAlignmentMode:kCAAlignmentCenter];
    [tl setContentsScale:[[UIScreen mainScreen] scale]];
    [tl setForegroundColor:self.letterColor.CGColor];
    [tl setString:string];
    return tl;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self sendEventToDelegate:event];
    [self.tableViewIndexDelegate tableViewIndexTouchesBegan:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    [self sendEventToDelegate:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.tableViewIndexDelegate tableViewIndexTouchesEnd:self];
}

- (void)sendEventToDelegate:(UIEvent*)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self];
    
    NSInteger indx = ((NSInteger)point.y / (self.letterHeight + self.letterSpace));
    
    if (indx< 0 || indx > self.letters.count - 1) {
        return;
    }
    
    [self.tableViewIndexDelegate tableViewIndex:self didSelectSectionAtIndex:indx withTitle:self.letters[indx]];
}

@end
