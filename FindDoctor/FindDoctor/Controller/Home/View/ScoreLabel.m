//
//  ScoreView.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/6.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "ScoreLabel.h"

#define ViewDefaultWidth 55
#define ViewDefaultHeight 15

@implementation ScoreLabel{
    UILabel * score;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.contents = [UIImage imageNamed:@""];
        score = [[UILabel alloc] init];
        score.textAlignment = NSTextAlignmentLeft;
        score.textColor = [UIColor whiteColor];
        return self;
    }
    return nil;
}

+ (float)defaultWidth{
    return ViewDefaultWidth;
}

+ (float)defaultHeight{
    return ViewDefaultHeight;
}

- (void)setText:(NSString *)text{
    score.text = text;
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = [self sizeForString:score.text font:score.font limitSize:CGSizeMake(0, self.frameHeight)];
    score.frame = CGRectMake(18, 0, size.width, size.height);
}

- (CGSize)sizeForString:(NSString *)string font:(UIFont *)font limitSize:(CGSize)limitSize{
    
    CGFloat width = limitSize.width;
    CGFloat height = limitSize.height;
    if (!width) {
        width = CGFLOAT_MAX;
    }
    if (!height) {
        height = CGFLOAT_MAX;
    }
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, height)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    
    return rect.size;
}

@end
