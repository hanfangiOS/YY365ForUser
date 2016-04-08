//
//  GoodDoctorViewController.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/8.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "GoodDoctorViewController.h"
#import "GoodDoctorCell.h"
#import "Doctor.h"
#import "HFTitleView.h"

#define sectionHeaderViewHeight 30 * VFixRatio6

@interface GoodDoctorViewController ()

@property (strong,nonatomic)UICollectionView * collectionView;

@end

@implementation GoodDoctorViewController

static NSString * const reuseCellID = @"GoodDoctorCell";
static NSString * const reuseHeaderID = @"ReuseHeaderView";

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView{
    self = [super init];
    if (self) {
        self.collectionView = collectionView;
        [self registerCell];
        return self;
    }
    return nil;
}

- (void)registerCell{

    [self.collectionView registerClass:[GoodDoctorCell class] forCellWithReuseIdentifier:reuseCellID];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderID];
}

- (void)setData:(NSMutableArray *)data{
    _data = data;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return _data.count;
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodDoctorCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseCellID forIndexPath:indexPath];
    cell.data = [_data objectAtIndexSafely:indexPath.row];
    
    if (indexPath.row == 0) {
        cell.bottomLine.frame = CGRectMake(10 * HFixRatio6, 85 * VFixRatio6 - 0.5 * VFixRatio6, kScreenWidth/2 - 0.5 * HFixRatio6, 0.5 * VFixRatio6);
    }else if (indexPath.row == 1) {
        cell.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 85 * VFixRatio6 - 0.5 * VFixRatio6, kScreenWidth/2 - 0.5 * HFixRatio6, 0.5 * VFixRatio6)];
    }else{
        cell.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 85 * VFixRatio6 - 0.5 * VFixRatio6, kScreenWidth/2, 0.5 * VFixRatio6)];
    }
    cell.bottomLine.backgroundColor = [UIColor blackColor];
    
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake([GoodDoctorCell defaultWidth],[GoodDoctorCell defaultHeight]);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = CGSizeMake(kScreenWidth, 30 * VFixRatio6);
    return size;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView * reuseHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderID forIndexPath:indexPath];
    
    for (UIView * view in reuseHeaderView.subviews) {
        if (view.tag == 3000 || view.tag == 3001 || view.tag == 3002) {
            [view removeFromSuperview];
        }
    }
    
    if (kind == UICollectionElementKindSectionHeader){
        
        HFTitleView * titleView = [[HFTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, sectionHeaderViewHeight) titleText:@"好评医生" Style:HFTitleViewStyleLoadMore];
        titleView.pic.backgroundColor = [UIColor blueColor];
        [titleView.loadMoreBtn setTitle:@"更多医生" forState:UIControlStateNormal];
        [titleView.loadMoreBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        titleView.loadMoreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [titleView.loadMoreBtn addTarget:self action:@selector(loadMoreAction) forControlEvents:UIControlEventTouchUpInside];
        titleView.loadMoreBtn.backgroundColor = [UIColor blackColor];
        titleView.tag = 3000;
        [reuseHeaderView addSubview:titleView];
        
        UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5 * VFixRatio6)];
        topLine.backgroundColor = [UIColor darkGrayColor];
        topLine.tag = 3001;
        [reuseHeaderView addSubview:topLine];
        
        UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(10 * HFixRatio6 , sectionHeaderViewHeight - 0.5 * VFixRatio6, kScreenWidth - 10 * 2 * HFixRatio6, 0.5 * VFixRatio6)];
        bottomLine.backgroundColor = [UIColor darkGrayColor];
        bottomLine.tag = 3002;
        [reuseHeaderView addSubview:bottomLine];
    }
    
    return reuseHeaderView;
    
}

- (void)loadMoreAction{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
