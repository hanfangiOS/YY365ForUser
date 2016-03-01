//
//  AddressListView.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/17.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "AddressListView.h"
#import "UIImageView+WebCache.h"

#define kAddressBaseTag        100
#define kAddressListViewHeight 173.0

@interface AddressItemView : UIView

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UIImageView *imageView;

@property (nonatomic, copy) CUCommomButtonAction deleteBlock;

@end

@implementation AddressItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews
{
    CGFloat btnWidth = 18.0;
    CGFloat btnRPadding = 10.0;
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(self.frameWidth - btnWidth - btnRPadding, 3, btnWidth, btnWidth);
    [deleteButton setImage:[UIImage imageNamed:@"btn_delete_red_nor"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    
    CGFloat labelOriginX = 25.0;
    CGFloat labelOriginY = 5.0;
    CGFloat labelRPadding = btnWidth + btnRPadding * 2;
    CGFloat labelWidth = self.frameWidth - labelOriginX - labelRPadding;
    CGFloat labelHeight = self.frameHeight - labelOriginY * 2;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelOriginX, labelOriginY, labelWidth, labelHeight)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = kBlackColor;
    _titleLabel.numberOfLines = 2;
    [self addSubview:_titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frameHeight - kDefaultLineHeight, self.frameWidth, kDefaultLineHeight)];
    lineView.backgroundColor = kLightLineColor;
    [self addSubview:lineView];
}

- (void)deleteButtonPress
{
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

@end

@implementation AddressListView
{
    UIScrollView *contentView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews
{
    CGFloat headerHeight = 24.0;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, headerHeight / 2, self.frameWidth, kDefaultLineHeight)];
    lineView.backgroundColor = kLightLineColor;
    [self addSubview:lineView];
    
    CGFloat leftPadding = 65.0;
    CGFloat rightPadding = 42.0;
    
    CGFloat titleWidth = self.frameWidth - leftPadding - rightPadding;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, 0, titleWidth, headerHeight)];
    titleLabel.backgroundColor = self.backgroundColor;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = kGreenColor;
    titleLabel.text = @"快递地址管理";
    [self addSubview:titleLabel];
    
    CGFloat addMemberWidth = 75.0;
    UILabel *addMemberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frameWidth - rightPadding - addMemberWidth, 0, addMemberWidth, headerHeight)];
    addMemberLabel.backgroundColor = self.backgroundColor;
    addMemberLabel.font = [UIFont systemFontOfSize:14];
    addMemberLabel.textColor = kBlackColor;
    addMemberLabel.text = @"添加新地址";
    addMemberLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:addMemberLabel];
    
    UIImageView *addMemeberImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(addMemberLabel.frame) - headerHeight, 0, headerHeight, headerHeight)];
    addMemeberImage.image = [UIImage imageNamed:@"menu_btn_add_nor"];
    [self addSubview:addMemeberImage];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(CGRectGetMinX(addMemeberImage.frame), 0, CGRectGetMaxX(addMemberLabel.frame) - CGRectGetMinX(addMemeberImage.frame), headerHeight);
    [addButton addTarget:self action:@selector(addButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addButton];
    
    CGFloat contentOriginY = headerHeight + 5;
    contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, contentOriginY, self.frameWidth, kAddressListViewHeight - contentOriginY)];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.showsHorizontalScrollIndicator = NO;
    [self addSubview:contentView];
}

- (void)addButtonPress
{
    if (self.addBlock) {
        self.addBlock();
    }
}

+ (CGFloat)defaultHeight
{
    return kAddressListViewHeight;
}

- (void)reloadData:(NSArray *)dataArray
{
    [contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    
    if (dataArray.count == 0) {
        UIImageView *blankView = [[UIImageView alloc] initWithFrame:contentView.bounds];
        blankView.image = [UIImage imageNamed:@"uc_icon_noContent"];
        blankView.contentMode = UIViewContentModeCenter;
        [contentView addSubview:blankView];
        return;
    }
    
    CGFloat originY = 0;
    CGFloat itemHeight = 50.0;
    
    for (NSInteger i = 0; i < dataArray.count; i ++) {
        CGRect rect = CGRectMake(0, originY, contentView.frameWidth, itemHeight);
        
        AddressItemView *itemView = [[AddressItemView alloc] initWithFrame:rect];
        itemView.tag = kAddressBaseTag + i;
        itemView.backgroundColor = [UIColor clearColor];
        [contentView addSubview:itemView];
        
        Address *address = [dataArray objectAtIndexSafely:i];
        itemView.titleLabel.text = address.address;
        
        originY += itemHeight;
        
        __weak typeof(self) weakSelf = self;
        itemView.deleteBlock = ^{
            if (weakSelf.deleteBlock) {
                weakSelf.deleteBlock(i);
            }
        };
    }
    
    contentView.contentSize = CGSizeMake(contentView.frameWidth, originY);
}

@end

