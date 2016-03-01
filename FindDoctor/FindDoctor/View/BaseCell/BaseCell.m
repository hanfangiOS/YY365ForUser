//
//  BaseCell.m
//  TableTest
//
//  Created by baidu on 14-6-4.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BaseCell.h"

@interface BaseCell ()

@property (nonatomic, strong) CellDisplayInfo *displayInfo;

@end

@implementation BaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

+ (Class)contentViewClass
{
    return [CellContentView class];
}

+ (CellDisplayInfo *)displayInfoForData:(id)data
{
    return nil;
}

- (void)initContentView
{
    self.cellContentView = [[[self.class contentViewClass] alloc] initWithFrame:self.displayInfo.contentViewFrame];
    [self.contentView addSubview:self.cellContentView];
}

- (void)updateWithData:(id)data displayInfo:(CellDisplayInfo *)info
{
    self.displayInfo = info;
    if (self.cellContentView == nil) {
        [self initContentView];
    }
    
    self.cellContentView.data = data;
    self.cellContentView.displayInfo = info;
    self.cellContentView.frame = info.contentViewFrame;
    [self.cellContentView update];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (self.cellContentView.hilighted != highlighted) {
        self.cellContentView.hilighted = highlighted;
    }
}

@end
