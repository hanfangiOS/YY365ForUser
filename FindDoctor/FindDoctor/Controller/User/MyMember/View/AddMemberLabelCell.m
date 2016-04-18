//
//  AddMemberLabelCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/17.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "AddMemberLabelCell.h"

@implementation AddMemberLabelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        return self;
    }
    return nil;
}

- (void)initSubViews{
    NSString * str = @"添加新的成员，可以使用当前登录的优医365账号进行约诊／就诊，约诊人的病例在当前账户统一管理。";
    CGSize size = [self sizeForString:str font:[UIFont systemFontOfSize:13] limitSize:CGSizeMake(kScreenWidth - 24 * 2, 0)];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(24, 0,size.width, size.height)];
    self.label.font = [UIFont systemFontOfSize:13];
    self.label.numberOfLines = 0;
    
    [self addSubview:self.label];
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
