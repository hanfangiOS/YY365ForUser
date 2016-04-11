//
//  ClinicAdverCell.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/8.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "ClinicAdverCell.h"
#import "UIImageView+WebCache.h"

#define CelldefaultHeight 105
#define CelldefaultWidth ((kScreenWidth - 30)/2)

@implementation ClinicAdverCell{
    UIImageView * icon;
}

+ (float)defaultHeight{
    return CelldefaultHeight;
}

+ (float)defaultWidth{
    return CelldefaultWidth;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{

    icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CelldefaultWidth, CelldefaultHeight)];
    [self addSubview:icon];
}

- (void)setData:(NSString *)data{
    _data = data;
    [icon setImageWithURL:[NSURL URLWithString:_data]];
}

@end
