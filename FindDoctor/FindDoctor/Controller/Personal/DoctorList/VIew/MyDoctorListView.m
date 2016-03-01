//
//  MyDoctorListView.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/19.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "MyDoctorListView.h"
#import "UIImageView+WebCache.h"

#define kMyDoctorBaseTag        100
#define kMyDoctorListViewHeight 126.0

#define kMyDoctorItemViewWidth  56.0
#define kMyDoctorItemViewHeight 80.0

@interface MyDoctorItemView : UIView

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UIImageView *imageView;

@property (nonatomic, copy) CUCommomButtonAction deleteBlock;

@end

@implementation MyDoctorItemView

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
    [deleteButton setImage:[UIImage imageNamed:@"uc_icon_zhen"] forState:UIControlStateNormal];
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

@implementation MyDoctorListView
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
    
    CGFloat titleWidth = 75.0;
    CGFloat leftPadding = (kScreenWidth - titleWidth) / 2;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, 0, titleWidth, headerHeight)];
    titleLabel.backgroundColor = self.backgroundColor;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = kGreenColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我的医生";
    [self addSubview:titleLabel];
    
    contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, headerHeight + 5, self.frameWidth, kMyDoctorItemViewHeight)];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.scrollEnabled = NO;
    [self addSubview:contentView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground)];
    tap.numberOfTapsRequired = 1;
    [contentView addGestureRecognizer:tap];
}

- (void)tapBackground
{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

+ (CGFloat)defaultHeight
{
    return kMyDoctorListViewHeight;
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
    
    NSInteger count = dataArray.count >= 4 ? 4 : dataArray.count;
    for (NSInteger i = 0; i < count; i ++) {
        CGRect rect = CGRectMake(originX, 0, kMyDoctorItemViewWidth, kMyDoctorItemViewHeight);
        
        MyDoctorItemView *itemView = [[MyDoctorItemView alloc] initWithFrame:rect];
        itemView.tag = kMyDoctorBaseTag + i;
        itemView.backgroundColor = [UIColor clearColor];
        [contentView addSubview:itemView];
        
        Doctor *doctor = [dataArray objectAtIndexSafely:i];
        itemView.titleLabel.text = doctor.name;
        [itemView.imageView setImageWithURL:[NSURL URLWithString:doctor.avatar] placeholderImage:nil];
        
        originX += (kMyDoctorItemViewWidth + space);
        
        __weak typeof(self) weakSelf = self;
        itemView.deleteBlock = ^{
            if (weakSelf.deleteBlock) {
                weakSelf.deleteBlock(i);
            }
        };
    }
    
    originX += padding;
    
    contentView.contentSize = CGSizeMake(originX, contentView.frameHeight);
}

@end

