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
#import "DoctorDetailController.h"
#import "CUDoctorManager.h"
#import "SearchResultListModel.h"
#import "SearchResultViewController.h"

#define sectionHeaderViewHeight 30

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
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodDoctorCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseCellID forIndexPath:indexPath];
    
    for (UIView * view in cell.subviews) {
        if (view.tag == 1000 || view.tag == 1001 || view.tag == 1002) {
            [view removeFromSuperview];
        };
    }
    
    if (indexPath.row == 0) {
        UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(10, 85 - 1, kScreenWidth/2 - 0.5, 1)];
        bottomLine.backgroundColor = kblueLineColor;
        bottomLine.tag = 1000;
        [cell addSubview:bottomLine];
    }else if (indexPath.row == 1) {
        UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 85  - 1, kScreenWidth/2 - 10 , 1)];
        bottomLine.backgroundColor = kblueLineColor;
        bottomLine.tag = 1001;
        [cell addSubview:bottomLine];
    }else{
        UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 85 - 1, kScreenWidth/2, 1)];
        bottomLine.backgroundColor = kblueLineColor;
        bottomLine.tag = 1002;
        [cell addSubview:bottomLine];
    }
    
    cell.data = [_data objectAtIndexSafely:indexPath.row];
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
    DoctorDetailController * vc = [[DoctorDetailController alloc] initWithPageName:@"DoctorDetailController"];
    vc.doctor =  [self.data objectAtIndexSafely:indexPath.row];
    if ([self.data objectAtIndexSafely:indexPath.row]) {
        [self.fatherVC.slideNavigationController pushViewController:vc animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = CGSizeMake(kScreenWidth, sectionHeaderViewHeight);
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
        
        HFTitleView * titleView = [[HFTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, sectionHeaderViewHeight) titleText:@"好评医师" Style:HFTitleViewStyleLoadMore];
        titleView.title.font = [UIFont systemFontOfSize:14];
        titleView.pic.backgroundColor = kBlueTextColor;
        [titleView.loadMoreBtn setTitle:@"更多医师" forState:UIControlStateNormal];
        [titleView.loadMoreBtn setTitleColor:kGrayTextColor forState:UIControlStateNormal];
        titleView.loadMoreBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [titleView.loadMoreBtn addTarget:self action:@selector(loadMoreAction) forControlEvents:UIControlEventTouchUpInside];
        titleView.tag = 3000;
        [reuseHeaderView addSubview:titleView];
        
        UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        topLine.backgroundColor = kblueLineColor;
        topLine.tag = 3001;
        [reuseHeaderView addSubview:topLine];
        
        UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(10, sectionHeaderViewHeight - 1, kScreenWidth - 10 * 2, 1)];
        bottomLine.backgroundColor = kblueLineColor;
        bottomLine.tag = 3002;
        [reuseHeaderView addSubview:bottomLine];
    }
    reuseHeaderView.backgroundColor = [UIColor whiteColor];
    return reuseHeaderView;
    
}

#pragma mark Action

- (void)loadMoreAction{
    SearchResultListModel * listModel = [[SearchResultListModel alloc] initWithSortType:SearchSortTypeNone];
    SearchResultViewController * vc = [[SearchResultViewController alloc] initWithPageName:@"SearchResultViewController" listModel:listModel];
    [self.fatherVC.slideNavigationController pushViewController:vc animated:YES];

}

#pragma mark request

- (void)requestUpdateDoctorInfoWithDoctor:(Doctor *)doctor{
    DoctorDetailController * vc = [[DoctorDetailController alloc] initWithPageName:@"DoctorDetailController"];
    
    [[CUDoctorManager sharedInstance] updateDoctorInfo:doctor date:[[[NSDate date] dateAtStartOfDay] timeIntervalSince1970] resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                
                vc.doctor = doctor;
                [self.fatherVC.slideNavigationController pushViewController:vc animated:YES];
            }
        }
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
