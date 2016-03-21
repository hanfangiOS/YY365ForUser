//
//  MyCommentCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/3/14.
//  Copyright © 2016年 li na. All rights reserved.
//

#define upPadding 7
#define leftPadding 20
#define downPadding 26
#define rightPadding 10

#define paragraphLineSpacing 2

#import "MyCommentCell.h"
#import "StarRatingView.h"

@implementation MyCommentCell{
    
    StarRatingView      * _starView;
    UILabel             * _label1;//@“赠送XXX锦旗”
    UILabel             * _label2;//@“医生水平很高XXXXX”
    UILabel             * _label3;//@“2015-02XXXXX”
    UILabel             * _label4;//@“张仲景XXXX”
    UILabel             * _label5;//@“+20”
    
    NSInteger             _heightForLabel2;
    
    UIView              * _lineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
   
    if (self) {
//        self.data = [[Comment alloc] init];
        [self initSubViews];
        return self;
    }
    return nil;
}

- (void)initSubViews{
    
     self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, kScreenWidth, self.frameHeight);
    
    _starView = [[StarRatingView alloc] initWithFrame:CGRectMake(1 , 1, 70 , 20) type:StarTypeSmall starSpace:0];
//    _starView.backgroundColor = [UIColor redColor];
    
    _label1 = [[UILabel alloc] initWithFrame:CGRectMake(1,1 , 1, 1)];
    _label1.textColor = UIColorFromHex(0xfdbd06);
    _label1.font = [UIFont systemFontOfSize:12];
    _label1.textAlignment = NSTextAlignmentLeft;
    
    _label2 = [[UILabel alloc] initWithFrame:CGRectMake(1,1 , 1, 1)];
    _label2.font = [UIFont systemFontOfSize:15];
    _label2.textColor = UIColorFromHex(0x666666);
    _label2.numberOfLines = 0;
    
    _label3 = [[UILabel alloc] initWithFrame:CGRectMake(1,1 , 1, 1)];
    _label3.textAlignment = NSTextAlignmentLeft;
    _label3.textColor = UIColorFromHex(0x999999);
    _label3.font = [UIFont systemFontOfSize:11];
    
    _label4 = [[UILabel alloc] initWithFrame:CGRectMake(1,1 , 1, 1)];
    _label4.textAlignment = NSTextAlignmentLeft;
    _label4.textColor = UIColorFromHex(0x999999);
    _label4.font = [UIFont systemFontOfSize:11];
    
    _label5 = [[UILabel alloc] initWithFrame:CGRectMake(1,1 , 1, 1)];
    _label5.textAlignment = NSTextAlignmentRight;
    _label5.textColor = UIColorFromHex(0xfdbd06);
    
    _lineView = [[UILabel alloc] initWithFrame:CGRectMake(1,1 , 1, 1)];
    _lineView.backgroundColor = UIColorFromHex(0xcccccc);
    
    [self addSubview:_starView];
    [self addSubview:_label1];
    [self addSubview:_label2];
    [self addSubview:_label3];
    [self addSubview:_label4];
    [self addSubview:_label5];
    [self addSubview:_lineView];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    _starView.frame = CGRectMake(leftPadding, upPadding + 3, 72, 20);
    
    //@“赠送XXX锦旗”
    _label1.frame = CGRectMake(CGRectGetMaxX(_starView.frame) + 20, upPadding + 5, kScreenWidth - rightPadding - CGRectGetMaxX(_starView.frame) - 10, 15);
  
    //@“+20”
    _label5.frame = CGRectMake(self.frameWidth - 16 - 40, [self CellHeight]/2 - 15, 40, 30);
    
    //@“医生水平很高XXXXX”
    _label2.frame = CGRectMake(leftPadding, _starView.maxY - 1.5,  self.frameWidth - 16 * 2 - 40 - leftPadding, _heightForLabel2 - 2);

    
    //@“2015-02XXXXX”
    _label3.frame = CGRectMake(leftPadding, _label2.maxY - 0.5 , 100, 20);

    
    //@“张仲景XXXX”
    _label4.frame = CGRectMake(_label3.maxX + 5,  _label2.maxY - 0.5, kScreenWidth - _label3.frameWidth - 5 - rightPadding, 20);

    
    _lineView.frame = CGRectMake(0, [self CellHeight] - 0.5, kScreenWidth, 0.5);
    
}


- (void)setData:(RemarkListInfo *)data{
    _data = data;
    _starView.editable = NO;
    _starView.rate = self.data.numStar;
    
    if (self.data.flagName) {
    _label1.text = [NSString stringWithFormat:@"赠送“%@”锦旗",self.data.flagName];
    }
    
    _label2.text  = self.data.content;

    CGSize size = [self sizeWithString:_label2.text font:[UIFont systemFontOfSize:15] lableWith:self.frameWidth - 16 - 40 - leftPadding];
    _heightForLabel2 = size.height;
//    _heightForLabel2 = [self handleLabel:_label2 andFontSize:15 andLineSpacing:0 width:self.frameWidth - 16 * 2 - 40 - leftPadding];
    
    _label3.text = [[NSDate dateWithTimeIntervalSince1970:self.data.time] stringWithDateFormat:@"yyyy-MM-dd HH:mm"];
    
    _label4.text = [NSString stringWithFormat:@"%@%@",self.data.doctorName,self.data.doctorTitle];
    
    _label5.text = [NSString stringWithFormat:@"+%ld",(long)self.data.score];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

- (NSInteger)CellHeight{
    
    return (upPadding + _starView.frameHeight + _label2.frameHeight + _label3.frameHeight + 5);
}

#pragma mark handleWays

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font lableWith:(CGFloat)lableWith{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(lableWith, CGFLOAT_MAX)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}


- (CGFloat)handleLabel:(UILabel *)label andFontSize:(CGFloat)fontSize andLineSpacing:(CGFloat)space width:(CGFloat)width{
    label.numberOfLines = 0;
    if (fontSize != 0) {
        label.font = [UIFont systemFontOfSize:fontSize];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.firstLineHeadIndent = 0;
    
    if (space == 0) {
        paragraphStyle.lineSpacing = paragraphLineSpacing;
    }else{
        paragraphStyle.lineSpacing = space;
    }
    NSDictionary *attributes = @{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    label.attributedText = attributedString;
    CGRect frameSize = [label.text boundingRectWithSize:CGSizeMake(width,CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return frameSize.size.height;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
