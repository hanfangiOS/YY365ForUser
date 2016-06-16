//
//  GoodClinicViewController.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/8.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "GoodClinicViewController.h"
#import "Clinic.h"
#import "GoodClinicCell.h"
#import "ClinicAdverCell.h"
#import "HFTitleView.h"
#import "ClinicMainViewController.h"
#import "SearchResultViewController.h"

#import "SearchResultListModel.h"

#define sectionHeaderViewHeight 30

@interface GoodClinicViewController ()

@property (strong,nonatomic)UICollectionView * collectionView;

@end

static NSString * const reuseCellID = @"GoodClinicCell";
static NSString * const reuseAdverCellID = @"ClinicAdverCell";
static NSString * const reuseHeaderID = @"ReuseHeaderView";
static NSString * const reuseFooterID = @"ReuseFooterView";

@implementation GoodClinicViewController

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
    
    [self.collectionView registerClass:[GoodClinicCell class] forCellWithReuseIdentifier:reuseCellID];
    [self.collectionView registerClass:[ClinicAdverCell class] forCellWithReuseIdentifier:reuseAdverCellID];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderID];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseFooterID];
}

- (void)setData:(HomeModel *)data{
    _data = data;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //    return _data.count;
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.row == 0) {
//        ClinicAdverCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseAdverCellID forIndexPath:indexPath];
//        cell.data = self.data.promotionInfo;
//        cell.layer.borderColor = kblueLineColor.CGColor;
//        cell.layer.borderWidth = 1.0f;
//        return cell;
//    }else{
        GoodClinicCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseCellID forIndexPath:indexPath];
        cell.data = [self.data.goodClinicList objectAtIndexSafely:indexPath.row];
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor = kblueLineColor.CGColor;
        return cell;
//    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return CGSizeMake([ClinicAdverCell defaultWidth], [ClinicAdverCell defaultHeight]);
    }
    return CGSizeMake([GoodClinicCell defaultWidth],[GoodClinicCell defaultHeight]);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(16.5 ,10 ,16 ,10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClinicMainViewController * vc = [[ClinicMainViewController alloc] initWithPageName:@"ClinicMainViewController"];
    vc.clinic =  [self.data.goodClinicList objectAtIndexSafely:indexPath.row];
    if ([self.data.goodClinicList objectAtIndexSafely:indexPath.row]) {
            [self.fatherVC.slideNavigationController pushViewController:vc animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize size = CGSizeMake(kScreenWidth, 0.5);
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = CGSizeMake(kScreenWidth, sectionHeaderViewHeight);
    return size;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader){
        
        UICollectionReusableView * reuseHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderID forIndexPath:indexPath];
        
        for (UIView * view in reuseHeaderView.subviews) {
            if (view.tag == 4000 || view.tag == 4001 || view.tag == 4002) {
                [view removeFromSuperview];
            }
        }
        
        HFTitleView * titleView = [[HFTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, sectionHeaderViewHeight) titleText:@"好评诊所" Style:HFTitleViewStyleLoadMore];
        titleView.pic.backgroundColor = kBlueTextColor;
        titleView.title.font = [UIFont systemFontOfSize:14];
        [titleView.loadMoreBtn setTitle:@"更多诊所" forState:UIControlStateNormal];
        
        [titleView.loadMoreBtn setTitleColor:kGrayTextColor forState:UIControlStateNormal];
        titleView.loadMoreBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [titleView.loadMoreBtn addTarget:self action:@selector(loadMoreAction) forControlEvents:UIControlEventTouchUpInside];
        titleView.tag = 4000;
        [reuseHeaderView addSubview:titleView];
        
        UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        topLine.backgroundColor = kblueLineColor;
        topLine.tag = 4001;
        [reuseHeaderView addSubview:topLine];
        
        UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(10 , sectionHeaderViewHeight - 1, kScreenWidth - 10 * 2, 1)];
        bottomLine.backgroundColor = kblueLineColor;
        bottomLine.tag = 4002;
        [reuseHeaderView addSubview:bottomLine];
        return reuseHeaderView;
    }else{
        UICollectionReusableView * reuseFooterrView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseFooterID forIndexPath:indexPath];
        
        for (UIView * view in reuseFooterrView.subviews) {
            if (view.tag == 5000) {
                [view removeFromSuperview];
            }
        }
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        line.backgroundColor = kblueLineColor;
        line.tag = 5000;
        [reuseFooterrView addSubview:line];
        return reuseFooterrView;

    }
}

- (void)loadMoreAction{
    SearchResultListModel * listModel = [[SearchResultListModel alloc] initWithSortType:SearchSortTypeNone];
    listModel.filter.subject.name = @"-1";
    listModel.filter.subject.ID = -1;
    listModel.filter.searchListType = SearchListTypeClinic;
    SearchResultViewController *listVC = [[SearchResultViewController alloc] initWithPageName:_fatherVC.pageName listModel:listModel];
    [_fatherVC.slideNavigationController pushViewController:listVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
