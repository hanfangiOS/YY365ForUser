//
//  OrderTextLabel.m
//  EShiJia
//
//  Created by zhouzhenhua on 15-4-19.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "OrderTextLabel.h"

@implementation OrderTextLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.verticalAlignment = VerticalAlignmentMiddle;
    }
    
    return self;
}

- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment
{
    _verticalAlignment = verticalAlignment;
    
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
        case VerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case VerticalAlignmentMiddle:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    
    switch (self.textAlignment) {
        case NSTextAlignmentLeft:
            
            break;
        case NSTextAlignmentRight:
            textRect.origin.x = bounds.size.width - textRect.size.width;
            break;
        case NSTextAlignmentCenter:
            textRect.origin.x = (bounds.size.width - textRect.size.width) / 2.0;
            break;
            
        default:
            break;
    }
    
    return textRect;
}

- (void)drawTextInRect:(CGRect)requestedRect
{
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

@end
