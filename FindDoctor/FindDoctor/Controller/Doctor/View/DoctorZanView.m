//
//  DoctorZanView.m
//  FindDoctor
//
//  Created by chai on 15/8/31.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "DoctorZanView.h"
#import "DoctorZanCell.h"

@interface DoctorZanView () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_zanCollectionView;
    UILabel *_titleLabel;
}
@end

@implementation DoctorZanView

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
    float content_width = 100.f;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(237, 237, 237);
    [self addSubview:lineView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-content_width)/2.f, 0, content_width, 20.f)];
    _titleLabel.textColor = kGreenColor;
    _titleLabel.font = kCommonDescFont;
    _titleLabel.text = @"点赞";
    _titleLabel.backgroundColor = UIColorFromRGB(242, 242, 242);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    lineView.frame = CGRectMake(0, CGRectGetMidY(_titleLabel.frame), kScreenWidth, 1);
    
    float interval = (kScreenWidth-45*6)/6.f;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(45, 70);
    flowLayout.minimumLineSpacing = interval;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, interval, 0, interval);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    CGRect collectionFrame = self.bounds;
    collectionFrame.origin.y += CGRectGetMaxY(_titleLabel.frame);
    collectionFrame.size.height -= CGRectGetMaxY(_titleLabel.frame);
    
    _zanCollectionView = [[UICollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:flowLayout];
    _zanCollectionView.delegate = self;
    _zanCollectionView.dataSource = self;
    _zanCollectionView.backgroundColor = [UIColor clearColor];
    _zanCollectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_zanCollectionView];
    
    NSString *zanCellName = NSStringFromClass([DoctorZanCell class]);
    [_zanCollectionView registerClass:[DoctorZanCell class] forCellWithReuseIdentifier:zanCellName];
}

#pragma mark - uicollectionview delegate and datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *zanCellName = NSStringFromClass([DoctorZanCell class]);
    DoctorZanCell *zanCell = (DoctorZanCell *)[collectionView dequeueReusableCellWithReuseIdentifier:zanCellName forIndexPath:indexPath];
    return zanCell;
}

@end
