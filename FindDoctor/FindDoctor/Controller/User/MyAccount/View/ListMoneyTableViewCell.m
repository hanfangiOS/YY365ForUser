//
//  ListMoneyTableViewCell.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/23.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "ListMoneyTableViewCell.h"
#import "NSDate+SNExtension.h"

@interface ListMoneyTableViewCell(){
    UILabel *massegeLabel;
    UILabel *timeLabel;
    UILabel *feeLabel;
}

@end

@implementation ListMoneyTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews{
    int feeLabelWidth = 20;
    
    massegeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 14)];
//    massegeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth - feeLabelWidth, 14)];
    massegeLabel.font = [UIFont systemFontOfSize:14];
    massegeLabel.numberOfLines = 0;
    massegeLabel.textColor =  UIColorFromHex(Color_Hex_Text_Normal);
    [self addSubview:massegeLabel];
    
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 18, kScreenWidth - feeLabelWidth, 14)];
    timeLabel.font = [UIFont systemFontOfSize:11];
    timeLabel.textColor =  UIColorFromHex(Color_Hex_Text_Readed);
    [self addSubview:timeLabel];
    
    feeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - feeLabelWidth, 18, feeLabelWidth - 30, 14)];
    feeLabel.font = [UIFont systemFontOfSize:14 weight:2];
    feeLabel.textColor =  UIColorFromHex(Color_Hex_Text_Highlighted);
    feeLabel.textAlignment = NSTextAlignmentRight;
    feeLabel.hidden = YES;
    [self addSubview:feeLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setMassage:(NSString *)massage{
    _massage = massage;
    massegeLabel.text = _massage;
    CGSize size = [self sizeWithString:_massage font:massegeLabel.font lableWith:kScreenWidth - 20];
    massegeLabel.frame = CGRectMake(massegeLabel.frameX, massegeLabel.frameY, size.width, size.height);
}

- (void)setTimestamp:(NSTimeInterval)timestamp{
    _timestamp = timestamp;
    timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:_timestamp] stringWithDateFormat:@"yyyy-MM-dd HH:mm"];
    timeLabel.frame = CGRectMake(timeLabel.frameX, CGRectGetMaxY(massegeLabel.frame)+10, timeLabel.frameWidth, 10);
}

- (void)setFee:(double)fee{
    _fee = fee;
    feeLabel.text = [NSString stringWithFormat:@"%@%.2lf",_mark,_fee];
    feeLabel.frame = CGRectMake(feeLabel.frameX,(massegeLabel.frameHeight+40)/2-7 , feeLabel.frameWidth, feeLabel.frameHeight);
}

- (NSInteger)CellHeight{
    CGSize size = [self sizeWithString:_massage font:massegeLabel.font lableWith:massegeLabel.frameWidth];
    massegeLabel.frame = CGRectMake(massegeLabel.frameX, massegeLabel.frameY, size.width, size.height);
    return size.height + 40;
}

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font lableWith:(CGFloat)lableWith{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(lableWith, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}
@end
