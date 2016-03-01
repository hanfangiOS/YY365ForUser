//
//  DoctorFlagView.m
//  FindDoctor
//
//  Created by chai on 15/8/30.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "DoctorFlagView.h"
#import "DoctorFlagCell.h"

@interface DoctorFlagView () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_flagCollectionView;
    UILabel *_titleLabel;
    NSMutableArray *_selectIndexs;
}
@end

@implementation DoctorFlagView

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
    _selectIndexs = [NSMutableArray new];
    
    float content_width = 100;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(237, 237, 237);
    [self addSubview:lineView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-content_width)/2.f, 0, content_width, 20.f)];
    _titleLabel.textColor = kGreenColor;
    _titleLabel.font = kCommonDescFont;
    _titleLabel.text = @"锦旗";
    _titleLabel.backgroundColor = UIColorFromRGB(242, 251, 251);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    lineView.frame = CGRectMake(0, CGRectGetMidY(_titleLabel.frame), kScreenWidth, 1);

    float interval = (kScreenWidth-80*3)/4.f;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(80, 125);
    flowLayout.minimumLineSpacing = interval;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, interval, 0, interval);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    CGRect collectionFrame = self.bounds;
    collectionFrame.origin.y += CGRectGetMaxY(_titleLabel.frame);
    collectionFrame.size.height -= CGRectGetMaxY(_titleLabel.frame);
    
    _flagCollectionView = [[UICollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:flowLayout];
    _flagCollectionView.backgroundColor = [UIColor clearColor];
    _flagCollectionView.delegate = self;
    _flagCollectionView.dataSource = self;
    _flagCollectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_flagCollectionView];
    
    NSString *flagCellName = NSStringFromClass([DoctorFlagCell class]);
    [_flagCollectionView registerClass:[DoctorFlagCell class] forCellWithReuseIdentifier:flagCellName];
}

- (void)setEditable:(BOOL)editable
{
    _editable = editable;
    [_flagCollectionView reloadData];
}

- (void)contentViewReload
{
    [_flagCollectionView reloadData];
}

#pragma mark - collectionview delegate and datasource
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
    NSString *flagCellName = NSStringFromClass([DoctorFlagCell class]);
    DoctorFlagCell *flagCell = (DoctorFlagCell *)[collectionView dequeueReusableCellWithReuseIdentifier:flagCellName forIndexPath:indexPath];
    flagCell.editable = _editable;
    if ([_selectIndexs containsObject:[NSString stringWithFormat:@"%ld",indexPath.row]]) {
        flagCell.flagSelect = YES;
    }else{
        flagCell.flagSelect = NO;
    }
    return flagCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_editable) {
        DoctorFlagCell *cell = (DoctorFlagCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (cell.flagSelect) {
            cell.flagSelect = NO;
        }else{
            cell.flagSelect = YES;
            [_selectIndexs addObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
        }
    }
}

@end
