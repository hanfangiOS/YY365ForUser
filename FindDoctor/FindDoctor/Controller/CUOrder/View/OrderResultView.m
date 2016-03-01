//
//  OrderResultView.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "OrderResultView.h"
#import "UILabel+Rect.h"

#define kOrderInfoViewHeight  105.0

@implementation OrderResultView

- (void)update
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat textOriginY = 10.0;
    CGFloat textSpace = 10.0;
    CGFloat textHeight = 14.0;
    
    CGFloat textFontSize = textHeight;
    UIFont *textFont = [UIFont systemFontOfSize:textHeight];
    
    UIImage *checkImage = [UIImage imageNamed:@"pay_icon_point"];
    CGFloat imageWidth = textHeight;
    
    CGRect imageRect = CGRectMake(15, 0, imageWidth, imageWidth);
    
    CGFloat textOriginX = CGRectGetMaxX(imageRect) + 10;
    CGFloat textWidth = self.frameWidth - textOriginX * 2;
    
    [kBlackColor set];
    
    NSString *orderString = [NSString stringWithFormat:@"约诊单号：%@", self.order.orderId];
    
    CGRect orderRect = CGRectMake(textOriginX, textOriginY, textWidth, textHeight);
    [orderString drawInRect:[UILabel textRectWithRect:orderRect withFontSize:textFontSize] withFont:textFont];
    
    imageRect.origin.y = orderRect.origin.y;
    [checkImage drawInRect:imageRect];
    
    NSString *numberString = [NSString stringWithFormat:@"预约号：%@", self.order.orderNumber];
    
    CGRect numberRect = CGRectMake(textOriginX, CGRectGetMaxY(orderRect) + textSpace, textWidth, textHeight);
    [numberString drawInRect:[UILabel textRectWithRect:numberRect withFontSize:textFontSize] withFont:textFont];
    
    imageRect.origin.y = numberRect.origin.y;
    [checkImage drawInRect:imageRect];

    NSString *timeString = [NSString stringWithFormat:@"就诊时间：%@", self.order.service.doctor.availableTime];
    
    CGRect timeRect = CGRectMake(textOriginX, CGRectGetMaxY(numberRect) + textSpace, textWidth, textHeight);
    [timeString drawInRect:[UILabel textRectWithRect:timeRect withFontSize:textFontSize] withFont:textFont];
    
    imageRect.origin.y = timeRect.origin.y;
    [checkImage drawInRect:imageRect];
    
    NSString *addressString = [NSString stringWithFormat:@"地点：%@", self.order.service.doctor.address];
    
    CGRect addressRect = CGRectMake(textOriginX, CGRectGetMaxY(timeRect) + textSpace, textWidth, textHeight);
    [addressString drawInRect:[UILabel textRectWithRect:addressRect withFontSize:textFontSize] withFont:textFont];
    
    imageRect.origin.y = addressRect.origin.y;
    [checkImage drawInRect:imageRect];
}

@end
