//
//  DoctorFameCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/3/15.
//  Copyright © 2016年 li na. All rights reserved.
//

#define upPadding 20
#define leftPadding 30
#define downPadding 26
#define rightPadding 30

#define paragraphLineSpacing 2

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
    
    _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(1 , 1, 1 , 1)];
    
    _label1 = [[UILabel alloc] initWithFrame:CGRectMake(1,1 , 1, 1)];
    _label1.textColor = UIColorFromHex(0xfdbd06);
    _label1.font = [UIFont systemFontOfSize:11];
    _label1.textAlignment = NSTextAlignmentCenter;
    
    _label2 = [[UILabel alloc] initWithFrame:CGRectMake(1,1 , 1, 1)];
    _label2.backgroundColor = [UIColor greenColor];
    _label2.numberOfLines = 0;
    
    _label3 = [[UILabel alloc] initWithFrame:CGRectMake(1,1 , 1, 1)];
    _label3.textAlignment = NSTextAlignmentLeft;
    _label3.font = [UIFont systemFontOfSize:11];
    
    _lineView = [[UILabel alloc] initWithFrame:CGRectMake(1,1 , 1, 1)];
    _lineView.backgroundColor = UIColorFromHex(0xcccccc);
    
}
- (void)layoutSubviews{
    //头像
    _imageView1.frame = CGRectMake(leftPadding, upPadding, 48, 48);
    _imageView1.layer.cornerRadius = 48/2;
    _imageView1.clipsToBounds = YES;
    _imageView1.contentMode = UIViewContentModeScaleAspectFill;
    
    //@“张＊＊”
    _label1.frame = CGRectMake(leftPadding, _imageView1.maxY , 48, 20);
    
    //@“张仲景医生德高望重XXXXX”
    _label2.frame = CGRectMake(_imageView1.maxX + 10, upPadding, self.frameWidth - _imageView1.maxX - 10 - rightPadding, _heightForLabel2);
    
    
    //@“2015-02XXXXX”
    _label3.frame = CGRectMake(_imageView1.maxX + 10, _label2.maxY , 100, 20);
    
    
    _lineView.frame = CGRectMake(0, [self CellHeight] - 0.5, kScreenWidth, 0.5);
    
}

- (void)setData:(RemarkListInfo *)data{
    
    _data = data;
    
    //头像url接口暂无
    NSString * imagePath = @"";
    _imageView1.image = [UIImage imageNamed:imagePath];
    
    //temp
    _imageView1.backgroundColor = [UIColor redColor];
    
    NSString * str = [_data.userName substringToIndex:1];
    _label1.text = [NSString stringWithFormat:@"%@＊＊",str];
    
    _label2.text  = self.data.content;
    
    [self setNeedsDisplay];
    [self layoutIfNeeded];
    
    _heightForLabel2 = [self handleLabel:_label2 andFontSize:15 andLineSpacing:0 width:self.frameWidth - _imageView1.maxX - 10 - rightPadding];
    
    _label3.text = [[NSDate dateWithTimeIntervalSince1970:self.data.time] stringWithDateFormat:@"yyyy-MM-dd HH:mm"];
    
    
    [self addSubview:_imageView1];
    [self addSubview:_label1];
    [self addSubview:_label2];
    [self addSubview:_label3];
    [self addSubview:_lineView];
    
    [self setNeedsDisplay];
}

- (NSInteger)CellHeight{
    
    [self setNeedsDisplay];
    [self layoutIfNeeded];
    NSInteger h1 = _label2.frameHeight + _label3.frameHeight;
    NSInteger h2 = _imageView1.frameHeight + _label1.frameHeight;
    NSInteger height = ( h1 > h2 ? h1 : h2);
    return (upPadding + height);
    
}

#pragma mark handleWays

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

