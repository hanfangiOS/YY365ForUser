//
//  HFTitleView.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/4.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "HFTitleView.h"
#import "UIConstants.h"

@implementation HFTitleView{
    NSString            * _titleText;
    HFTitleViewStyle    _style;
}

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame titleText:nil];
}

- (instancetype)initWithFrame:(CGRect)frame titleText:(NSString *)titleText{
    return [self initWithFrame:frame titleText:titleText Style:HFTitleViewStyleDefault];
}

- (instancetype)initWithFrame:(CGRect)frame titleText:(NSString *)titleText Style:(HFTitleViewStyle)style{
    self = [super initWithFrame:frame];
    if (self) {
        _titleText = titleText;
        _style = style;
        [self initSubViews];
        return self;
    }
    return nil;
}

- (void)initSubViews{
    self.title = [[UILabel alloc] init];
    self.title.text = _titleText;
    
    if (_style == HFTitleViewStyleDefault) {
        
    }
    if (_style == HFTitleViewStyleLoadMore) {
        self.pic = [[UIImageView alloc] init];
        self.loadMoreBtn = [[UIButton alloc] init];
        [self.loadMoreBtn addTarget:self action:@selector(loadMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_style == HFTitleViewStyleDefault) {
        
    }
    if (_style == HFTitleViewStyleLoadMore) {
        
    }
    if (_style == HFTitleViewStyleNone) {
//        self.title.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
    }
}

- (void)resetData{
    
}

- (void)redrawTitleView{
    
}

- (void)loadMoreClick:(id)sender{
    if (self.loadMoreAction) {
        self.loadMoreAction();
    }
}

- (CGFloat)widthForString:(NSString *)string font:(UIFont *)font{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    
    return rect.size.width;
}


@end
