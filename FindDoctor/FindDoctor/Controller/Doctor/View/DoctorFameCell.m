//
//  DoctorFameCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/3/15.
//  Copyright © 2016年 li na. All rights reserved.
//

#define upPadding 13
#define leftPadding 25
#define downPadding 26
#define rightPadding 25

#define paragraphLineSpacing 0

#import "DoctorFameCell.h"

@implementation DoctorFameCell{
    
    UIImageView         * _imageView1;//头像
    UILabel             * _label1;//@“张＊＊”
    UILabel             * _label2;//@“张仲景医生德高望重XXXXX”
    UILabel             * _label3;//@“2015-02XXXXX”
    
    NSInteger             _heightForLabel2;
    
    UIView              * _lineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        return self;
    }
    return nil;
}

- (void)initSubViews{
    
    self.frame = CGRectMake(0, 0, kScreenWidth, 1);
    
    _imageView1 = [[UIImageView alloc] init];
    
    _label1 = [[UILabel alloc] init];
    _label1.textColor = UIColorFromHex(0xfdbd06);
    _label1.font = [UIFont systemFontOfSize:11];
    _label1.textAlignment = NSTextAlignmentCenter;
    
    _label2 = [[UILabel alloc] init];
    _label2.textAlignment = NSTextAlignmentLeft;
    _label2.font = [UIFont systemFontOfSize:14];
    _label2.numberOfLines = 0;
    
    _label3 = [[UILabel alloc] init];
    _label3.textAlignment = NSTextAlignmentLeft;
    _label3.font = [UIFont systemFontOfSize:11];
    _label3.textColor = UIColorFromHex(0x999999);
    
    
    _lineView = [[UILabel alloc] init];
    _lineView.backgroundColor = UIColorFromHex(0xcccccc);
    
    [self addSubview:_imageView1];
    [self addSubview:_label1];
    [self addSubview:_label2];
    [self addSubview:_label3];
    [self addSubview:_lineView];
    
}
- (void)layoutSubviews{

    
}

- (void)retView{
    //头像
    _imageView1.frame = CGRectMake(leftPadding, upPadding, 30, 30);
    _imageView1.layer.cornerRadius = _imageView1.frameWidth/2;
    _imageView1.clipsToBounds = YES;
    _imageView1.contentMode = UIViewContentModeScaleAspectFill;
    
    //@“张＊＊”
    _label1.frame = CGRectMake(leftPadding, _imageView1.maxY +2 , 48, 20);
    _label1.centerX = _imageView1.centerX;
    
    //@“张仲景医生德高望重XXXXX”
    _label2.frame = CGRectMake(_imageView1.maxX + 15, upPadding , self.frameWidth - _imageView1.maxX - 10 - rightPadding, _heightForLabel2);
    [_label2 sizeToFit];
    
    //@“2015-02XXXXX”
    _label3.frame = CGRectMake(_imageView1.maxX + 15, _label2.maxY +1,kScreenWidth - _imageView1.maxX + 15, 20);
    [_label3 sizeToFit];
    _label3.frameX = _imageView1.maxX + 15;
    
    _lineView.frame = CGRectMake(0, [self CellHeight] - 0.5, kScreenWidth, 0.5);
    
    [self setNeedsLayout];
}

- (void)setData:(RemarkListInfo *)data{
    
    _data = data;
    
    _imageView1.image = [UIImage imageNamed:@"button_myScore"];
    
    NSString * str = [_data.userName substringToIndex:1];
    _label1.text = [NSString stringWithFormat:@"%@**",str];
    
    _label2.text  = [NSString stringWithFormat:@"%@",self.data.content];
    
    CGSize size = [self sizeWithString:_label2.text font:[UIFont systemFontOfSize:15] lableWith:self.frameWidth - _imageView1.maxX - 10 - rightPadding];
    _heightForLabel2 = size.height;
    
//    _heightForLabel2 = [self handleLabel:_label2 andFontSize:14 andLineSpacing:0 width:self.frameWidth - _imageView1.maxX - 10 - rightPadding];
    
    _label3.text = [[NSDate dateWithTimeIntervalSince1970:self.data.time] stringWithDateFormat:@"yyyy-MM-dd HH:mm"];
    
    [self retView];
}

- (NSInteger)CellHeight{
    
    NSInteger h1 = _label2.frameHeight + _label3.frameHeight;
    NSInteger h2 = _imageView1.frameHeight + _label1.frameHeight;
    NSInteger height = ( h1 > h2 ? h1 : h2);
    if ( h1 < h2) {
        _label3.frame = CGRectMake(_imageView1.maxX + 15,_imageView1.maxY + 2 , 100, 20);
    }
    return (upPadding + height + 5);
    
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
//    paragraphStyle.firstLineHeadIndent = 0;
    
    if (space == 0) {
        paragraphStyle.lineSpacing = paragraphLineSpacing;
    }else{
        paragraphStyle.lineSpacing = space;
    }
    NSDictionary *attributes = @{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    label.attributedText = attributedString;
    CGRect frameSize = [label.text boundingRectWithSize:CGSizeMake(width,CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    label.baselineAdjustment = YES;
    return frameSize.size.height;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end

