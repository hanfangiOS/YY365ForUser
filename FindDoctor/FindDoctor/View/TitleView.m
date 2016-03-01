//
//  GXWHeaderView.m
//  FindDoctor
//
//  Created by Guo on 15/8/25.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "TitleView.h"

@implementation TitleView


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        _headerLabel = [[UILabel alloc]init];
        _headerLabel.text = title;
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        _headerLabel.font =[UIFont systemFontOfSize:14];
        _headerLabel.textColor = UIColorFromHex(Color_Hex_NavBackground);
        CGSize size =  [self sizeWithString:title font:[UIFont systemFontOfSize:14]];
        _headerLabel.frame = CGRectMake((kScreenWidth-size.width)/2,self.frameHeight/2 - size.height/2,size.width,size.height);
        [self addSubview:_headerLabel];
        
        UIImage *image1 = [UIImage imageNamed:@"titleLine1"];
        UIImage *image2 = [UIImage imageNamed:@"titleLine2"];
        UIImageView *headerlionView1 = [[UIImageView alloc]init];
        headerlionView1.image = image1;
        UIImageView *headerlionView2 = [[UIImageView alloc]init];
        headerlionView2.image = image2;
        
        float lineWith = image1.size.width/image1.size.height*3.5;
        float textWith = size.width + 15;
        headerlionView1.frame = CGRectMake(kScreenWidth/2 - textWith/2 - lineWith,(self.frameHeight-3.5)/2,lineWith,3.5);
        headerlionView1.contentMode = 0;
        headerlionView2.frame = CGRectMake(kScreenWidth/2 + textWith/2,(self.frameHeight-3.5)/2,lineWith,3.5);
        headerlionView2.contentMode = 0;
        
        [self addSubview:headerlionView1];
        [self addSubview:headerlionView2];
    }
    return self;
}


- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(320, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}
@end
