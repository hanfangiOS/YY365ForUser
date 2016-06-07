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
    self.title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.title];
    
    if (_style == HFTitleViewStyleDefault) {
        self.leftLine = [[UIImageView alloc] init];
        self.leftLine.backgroundColor = [UIColor lightTextColor];
        [self addSubview:self.leftLine];
        
        self.rightLine = [[UIImageView alloc] init];
        self.rightLine.backgroundColor = [UIColor lightTextColor];
        [self addSubview:self.rightLine];
        
    }
    if (_style == HFTitleViewStyleLoadMore) {
        self.title.textAlignment = NSTextAlignmentLeft;
        
        self.pic = [[UIImageView alloc] init];
        [self addSubview:self.pic];
        
        self.loadMoreBtn = [[UIButton alloc] init];
        self.loadMoreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [self addSubview:self.loadMoreBtn];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];

    //是否重绘
    if (self.ifRedraw == YES) {
        //手动重绘
        if (self.delegate) {
            [self.delegate redrawTitleView];
        }
    }else{
        //正常绘制
        if (_style == HFTitleViewStyleDefault) {
            CGSize titleSize = [self sizeForString:self.title.text font:self.title.font limitSize:CGSizeMake(0, self.frameHeight)];
            self.title.frame = CGRectMake((self.frameWidth - titleSize.width)/2, 0, titleSize.width, titleSize.height);
            
            //线与边界距离
            CGFloat padding = 5 * HFixRatio6;
            //线与title距离
            CGFloat space = 8 * HFixRatio6;

            self.leftLine.frame = CGRectMake(padding, (self.frameHeight - 1)/2, self.title.frameX - padding - space, 1);
            self.rightLine.frame = CGRectMake(self.title.maxX + space, (self.frameHeight - 1)/2, self.frameWidth - (self.title.maxX + space) - padding, 1);
        }
        
        if (_style == HFTitleViewStyleLoadMore) {
            
            self.pic.frame = CGRectMake(8, (self.frameHeight - (self.frameHeight - 8 * 2))/2, 4, self.frameHeight - 8 * 2);
            
            CGSize titleSize = [self sizeForString:self.title.text font:self.title.font limitSize:CGSizeMake(0, self.pic.frameHeight)];
            self.title.frame = CGRectMake(8 + self.pic.maxX, (self.frameHeight - titleSize.height)/2, titleSize.width, titleSize.height);
            
            self.loadMoreBtn.frame = CGRectMake(self.title.maxX + 10,7,kScreenWidth - (self.title.maxX + 10) - 10,self.frameHeight - 7 * 2);
        }
        
        if (_style == HFTitleViewStyleNone) {
            CGSize titleSize = [self sizeForString:self.title.text font:self.title.font limitSize:CGSizeMake(0, self.frameHeight)];
            self.title.frame = CGRectMake((self.frameWidth - titleSize.width)/2, 0, titleSize.width, titleSize.height);
        }
    }
}

- (void)resetData{
    [self setNeedsLayout];
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
