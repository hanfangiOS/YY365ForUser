//
//  DoctorFlagCell.m
//  FindDoctor
//
//  Created by chai on 15/8/30.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "DoctorFlagCell.h"

@interface DoctorFlagCell ()
{
    UILabel *_flagNumberLabel;
    UIImageView *_flagImageView;
    UIImageView *_selectView;
}
@end

@implementation DoctorFlagCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    UIImage *image = [UIImage imageNamed:@"praise_flag_pic.png"];
    
    float repair_interval = 5;
    
    _flagImageView = [[UIImageView alloc] init];
    _flagImageView.frame = (CGRect){0, repair_interval, image.size};
    [self.contentView addSubview:_flagImageView];
    
    float number_width = 20.f;
    
    _flagNumberLabel = [[UILabel alloc] init];
    _flagNumberLabel.textColor = [UIColor whiteColor];
    _flagNumberLabel.font = kAnnotationFont;
    _flagNumberLabel.textAlignment = NSTextAlignmentCenter;
    _flagNumberLabel.frame = CGRectMake(self.bounds.size.width-number_width, 0, number_width, number_width);
    _flagNumberLabel.backgroundColor = kYellowColor;
    _flagNumberLabel.layer.cornerRadius = number_width/2.f;
    _flagNumberLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_flagNumberLabel];
    
    _selectView = [[UIImageView alloc] init];
    _selectView.frame = CGRectMake(0, 0, 30, 30);
    _selectView.center = CGPointMake(self.frame.size.width/2.f, self.frame.size.height/2.f);
    _selectView.hidden = YES;
    _selectView.backgroundColor = _flagSelect?[UIColor redColor]:[UIColor yellowColor];
    [self.contentView addSubview:_selectView];
    
    [self setContentView];
}

- (void)setEditable:(BOOL)editable
{
    _editable = editable;
    if (_editable) {
        _flagNumberLabel.hidden = YES;
        _selectView.hidden = NO;
    }else{
        _flagNumberLabel.hidden = NO;
        _selectView.hidden = YES;
    }
}

- (void)setFlagSelect:(BOOL)flagSelect
{
    _flagSelect = flagSelect;
    if (_flagSelect) {
        _selectView.backgroundColor = [UIColor redColor];
    }else{
        _selectView.backgroundColor = [UIColor yellowColor];
    }
}

- (void)setContentView
{
    _flagImageView.image = [UIImage imageNamed:@"praise_flag_pic.png"];
    _flagNumberLabel.text = @"12";
}

@end
