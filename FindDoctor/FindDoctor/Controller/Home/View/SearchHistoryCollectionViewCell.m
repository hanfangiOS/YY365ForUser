//
//  SearchHistoryCollectionViewCell.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/8.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "SearchHistoryCollectionViewCell.h"

@interface SearchHistoryCollectionViewCell(){
    UILabel *_label;
}
@end

@implementation SearchHistoryCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView
{
    _label = [[UILabel alloc]init];
    _label.layer.borderColor = UIColorFromHex(0x666666).CGColor;
    _label.textColor = UIColorFromHex(0x666666);
    _label.layer.borderWidth = 0.5f;
    _label.font = [UIFont systemFontOfSize:12];
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
}

- (void)setString:(NSString *)string{
    _string = string;
    _label.text = _string;
    [_label sizeToFit];
    _label.frame = CGRectMake(_label.frameX, _label.frameY, _label.frameWidth + 20, _label.frameHeight + 15);
    _label.layer.cornerRadius = _label.frameHeight/2.f;
}



@end
