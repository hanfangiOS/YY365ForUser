//
//  HotSearchDoctorCollectionViewCell.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/14.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "HotSearchDoctorCollectionViewCell.h"

@implementation HotSearchDoctorCollectionViewCell

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
//    _label = [[UILabel alloc]init];
//    _label.layer.borderColor = UIColorFromHex(0x666666).CGColor;
//    _label.textColor = UIColorFromHex(0x666666);
//    _label.layer.borderWidth = 0.5f;
//    _label.font = [UIFont systemFontOfSize:12];
//    _label.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:_label];
    int value1 = arc4random() % 255;
    int value2 = arc4random() % 255;
    int value3 = arc4random() % 255;
    self.backgroundColor = [UIColor colorWithRed:value1/255.f green:value2/255 blue:value3/255 alpha:1];
    self.frame = CGRectMake(self.frameX, self.frameY, kScreenWidth, 50);
}

//- (void)setString:(NSString *)string{
//    _string = string;
//    _label.text = _string;
//    [_label sizeToFit];
//    _label.frame = CGRectMake(_label.frameX, _label.frameY, _label.frameWidth + 20, _label.frameHeight + 15);
//    _label.layer.cornerRadius = _label.frameHeight/2.f;
//}


@end
