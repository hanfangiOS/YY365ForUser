//
//  FamilyMemberListView.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/7.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "FamilyMemberListView.h"
#import "UIImageView+WebCache.h"

#define kFamilyMemberBaseTag        100
#define kFamilyMemberListViewHeight 126.0

#define kFamilyMemberItemViewWidth  56.0
#define kFamilyMemberItemViewHeight 80.0

@interface FamilyMemberItemView : UIView

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UIImageView *imageView;

@property (nonatomic, copy) CUCommomButtonAction deleteBlock;

@end

@implementation FamilyMemberItemView

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
    CGFloat imageOriginY = 7.0;
    CGFloat imageWidth = self.frameWidth;
    CGFloat imageHeight = imageWidth;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageOriginY, imageWidth, imageHeight)];
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageView];
    
    _imageView.layer.cornerRadius = imageWidth / 2;
    
    CGFloat labelHeight = 15.0;
    CGFloat labelWidth = self.frameWidth;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frameHeight - labelHeight, labelWidth, labelHeight)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.textColor = kBlackColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    CGFloat btnWidth = 18.0;
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(self.frameWidth - btnWidth, 0, btnWidth, btnWidth);
    [deleteButton setImage:[UIImage imageNamed:@"btn_delete_red_nor"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
}

- (void)deleteButtonPress
{
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

@end

@implementation FamilyMemberListView
{
    UIScrollView *contentView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = UIColorFromRGB(243, 251, 239);
        
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
    titleLabel.text = @"成员管理";
    [self addSubview:titleLabel];
    
    CGFloat addMemberWidth = 75.0;
    UILabel *addMemberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frameWidth - rightPadding - addMemberWidth, 0, addMemberWidth, headerHeight)];
    addMemberLabel.backgroundColor = self.backgroundColor;
    addMemberLabel.font = [UIFont systemFontOfSize:14];
    addMemberLabel.textColor = kBlackColor;
    addMemberLabel.text = @"添加新成员";
    addMemberLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:addMemberLabel];
    
    UIImageView *addMemeberImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(addMemberLabel.frame) - headerHeight, 0, headerHeight, headerHeight)];
    addMemeberImage.image = [UIImage imageNamed:@"menu_btn_add_nor"];
    [self addSubview:addMemeberImage];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(CGRectGetMinX(addMemeberImage.frame), 0, CGRectGetMaxX(addMemberLabel.frame) - CGRectGetMinX(addMemeberImage.frame), headerHeight);
    [addButton addTarget:self action:@selector(addButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addButton];
    
    contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, headerHeight + 5, self.frameWidth, kFamilyMemberItemViewHeight)];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.showsHorizontalScrollIndicator = NO;
    [self addSubview:contentView];
}

- (void)addButtonPress
{
    if (self.addMemberBlock) {
        self.addMemberBlock();
    }
}

+ (CGFloat)defaultHeight
{
    return kFamilyMemberListViewHeight;
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
    
    CGFloat padding = 24.0;
    CGFloat space = 16.0;
    CGFloat originX = padding;
    
    for (NSInteger i = 0; i < dataArray.count; i ++) {
        CGRect rect = CGRectMake(originX, 0, kFamilyMemberItemViewWidth, kFamilyMemberItemViewHeight);
        
        FamilyMemberItemView *itemView = [[FamilyMemberItemView alloc] initWithFrame:rect];
        itemView.tag = kFamilyMemberBaseTag + i;
        itemView.backgroundColor = [UIColor clearColor];
        [contentView addSubview:itemView];
        
        CUUser *user = [dataArray objectAtIndexSafely:i];
        itemView.titleLabel.text = user.name;
        [itemView.imageView setImageWithURL:[NSURL URLWithString:user.profile] placeholderImage:nil];
        
        originX += (kFamilyMemberItemViewWidth + space);
        
        __weak typeof(self) weakSelf = self;
        itemView.deleteBlock = ^{
            if (weakSelf.deleteMemberBlock) {
                weakSelf.deleteMemberBlock(i);
            }
        };
    }
    
    originX += padding;
    
    contentView.contentSize = CGSizeMake(originX, contentView.frameHeight);
}

@end
