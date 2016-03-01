//
//  OrderDetailView.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/29.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "OrderDetailView.h"

@implementation OrderDetailView

- (NSArray *)titleArray
{
    NSMutableArray *titleArray = [NSMutableArray arrayWithObjects:@"预约单号:", @"预  约 人:", @"下单时间:", @"预约医生:", @"预约科目:", @"预  诊 费:", @"预  约 号:", @"约诊时间:", @"约诊地点:", @"病症描述:", @"病症图片:", nil];
    
    if (![self.order hasDiseaseImage]) {
        [titleArray removeLastObject];
    }
    
    return [titleArray copy];
}

- (NSArray *)descKeyArray
{
    return @[@"orderId", @"userDesc", @"createTime", @"doctorDesc", @"service.doctor.subject", @"dealPriceDesc", @"queueNumberDesc", @"service.serviceTime", @"service.doctor.address", @"service.disease.desc", @""];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat textOriginX = 35.0;
    CGFloat textOriginY = 24.0 - 1.5;
    CGFloat textRPadding = 20.0;
    CGFloat textSpace = 16.0 - 1.5 * 2;
    CGFloat textWidth = kScreenWidth - textOriginX - textRPadding;
    
    CGFloat titleWidth = 66.0;
    CGFloat descWidth = textWidth - titleWidth;
    
    CGFloat textHeight = 17.0;
    UIFont *textFont = [UIFont systemFontOfSize:14];
    
    CGFloat imageCenterX = 16.0;
    CGFloat imageWidth = 4.0;
    UIImage *pointImage = [UIImage imageNamed:@"pay_detail_point"];
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, kDarkLineColor.CGColor);
//    
//    CGRect lineRect = CGRectMake(imageCenterX - kDefaultLineHeight, 0, kDefaultLineHeight * 2, textOriginY);
//    CGContextFillRect(context, lineRect);
    
    NSArray *titleArray = [self titleArray];
    NSArray *descKeyArray = [self descKeyArray];
    
    for (NSInteger i = 0; i < titleArray.count; i ++) {
        CGRect titleRect = CGRectMake(textOriginX, textOriginY, titleWidth, textHeight);
        
        [kDarkGrayColor set];
        
        [titleArray[i] drawInRect:titleRect withFont:textFont];
        
        CGRect descRect = CGRectMake(CGRectGetMaxX(titleRect), textOriginY, descWidth, textHeight);
        
        NSString *desc = nil;
        if (((NSString *)descKeyArray[i]).length) {
            desc = [self.order valueForKeyPathSafely:descKeyArray[i]];
        }
        
        CGSize descSize = [desc sizeWithFont:textFont constrainedToSize:CGSizeMake(descWidth, HUGE_VALF)];
        if (descSize.height) {
            descRect.size.height = ceilf(descSize.height);
        }
        
        [kBlackColor set];
        
        [desc drawInRect:descRect withFont:textFont];
        
//        CGRect lineRect = CGRectMake(imageCenterX - kDefaultLineHeight, textOriginY, kDefaultLineHeight * 2, descRect.size.height + textSpace);
//        CGContextSetFillColorWithColor(context, kDarkLineColor.CGColor);
//        CGContextFillRect(context, lineRect);
        
        CGRect imageRect = CGRectMake(imageCenterX - imageWidth / 2, CGRectGetMidY(titleRect) - imageWidth / 2, imageWidth, imageWidth);
        [pointImage drawInRect:imageRect];
        
        textOriginY += (descRect.size.height + textSpace);
    }
}

- (CGFloat)calculateViewHeight
{
    CGFloat textOriginX = 35.0;
    CGFloat textOriginY = 24.0 - 1.5;
    CGFloat textRPadding = 20.0;
    CGFloat textSpace = 16.0 - 1.5 * 2;
    CGFloat textWidth = kScreenWidth - textOriginX - textRPadding;
    
    CGFloat titleWidth = 66.0;
    CGFloat descWidth = textWidth - titleWidth;
    
    CGFloat textHeight = 17.0;
    UIFont *textFont = [UIFont systemFontOfSize:14];
    
    NSArray *titleArray = [self titleArray];
    NSArray *descKeyArray = [self descKeyArray];
    
    for (NSInteger i = 0; i < titleArray.count; i ++) {
        CGRect descRect = CGRectMake(textOriginX + titleWidth, textOriginY, descWidth, textHeight);
        
        NSString *desc = nil;
        if (((NSString *)descKeyArray[i]).length) {
            desc = [self.order valueForKeyPathSafely:descKeyArray[i]];
        }
        
        CGSize descSize = [desc sizeWithFont:textFont constrainedToSize:CGSizeMake(descWidth, HUGE_VALF)];
        if (descSize.height) {
            descRect.size.height = ceilf(descSize.height);
        }
        
        textOriginY += (descRect.size.height + textSpace);
    }
    
    return textOriginY;
}

@end
