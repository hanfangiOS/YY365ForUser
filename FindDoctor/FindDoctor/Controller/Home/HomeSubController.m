//
//  HomeSubController.m
//  EShiJia
//
//  Created by zhouzhenhua on 15/8/4.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "HomeSubController.h"
#import "CUDoctorManager.h"
#import "CUDoctorParser.h"
#import "SubObjectCell.h"
#import "SubObjectHeaderView.h"
#import "DoctorListContainerController.h"

#import "DoctorListModel.h"
#import "DoctorListController.h"

#import "TipHandler.h"
#import "TipHandler+HUD.h"

@interface HomeSubController () <UICollectionViewDelegate,UICollectionViewDataSource>
{
    SNBaseListModel *_showObjectList;
}

@property (nonatomic, weak) UICollectionView *contentCollection;

@end

@implementation HomeSubController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找医生";
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

#pragma mark - load Data
- (void)loadData
{
    __weak HomeSubController *blockSelf = self;
    [self showProgressView];
    [[CUDoctorManager sharedInstance] getSubObjectListWithResultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
//        CUDoctorParser *parser = [[CUDoctorParser alloc] init];
        [blockSelf hideProgressView];
        if (result.hasError) {
            // 提示错误
            [TipHandler showHUDText:[result.error.userInfo objectForKey:NSLocalizedDescriptionKey] inView:blockSelf.contentView];
        }
        _showObjectList = result.parsedModelObject;
        [blockSelf.contentCollection reloadData];
    }];
}

#pragma mark - load content view
- (void)loadContentView
{
    [self createCollectionView];
    [self loadData];
}

- (void)createCollectionView
{
    float item_interval_x = 15*kScreenRatio;
    float margin = 30*kScreenRatio;
    float item_interval_y = 6*kScreenRatio;
    
    int line_number = 4;
    
    float item_width = (kScreenWidth-margin*2-item_interval_x*(line_number-1))/line_number;
    float item_height = 80*kScreenRatio;
    
    float header_height = 55.f;
    
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionLayout.itemSize = CGSizeMake(item_width, item_height);
    collectionLayout.minimumInteritemSpacing = item_interval_x;
    collectionLayout.minimumLineSpacing = item_interval_y;
    collectionLayout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    collectionLayout.headerReferenceSize = CGSizeMake(kScreenWidth, header_height);
    
    CGRect collectionFrame = self.contentView.bounds;
    
    UICollectionView *collectionview = [[UICollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:collectionLayout];
    collectionview.backgroundColor = [UIColor clearColor];
    collectionview.delegate = self;
    collectionview.dataSource = self;
    [self.contentView addSubview:collectionview];
    
    self.contentCollection = collectionview;
    
    NSString *collectionCellName = NSStringFromClass([SubObjectCell class]);
    [self.contentCollection registerClass:[SubObjectCell class] forCellWithReuseIdentifier:collectionCellName];
    
    NSString *collectionHeaderName = NSStringFromClass([SubObjectHeaderView class]);
    [self.contentCollection registerClass:[SubObjectHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionHeaderName];
}

#pragma mark - collection view delegate and datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
#if !LOCAL
    return [[_showObjectList.items objectAtIndex:section] count];
#else
    return [_showObjectList.items count];
#endif
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *collectionCellName = NSStringFromClass([SubObjectCell class]);
    SubObjectCell *collectionCell = (SubObjectCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellName forIndexPath:indexPath];
#if !LOCAL
    collectionCell.subobject = [[_showObjectList.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
#else
    collectionCell.subobject = [_showObjectList.items objectAtIndex:indexPath.row];
#endif
    return collectionCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSString *collectionHeaderName = NSStringFromClass([SubObjectHeaderView class]);
        SubObjectHeaderView *headerview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:collectionHeaderName forIndexPath:indexPath];
        NSArray *headers = [[NSArray alloc] initWithObjects:@"科室", @"症状", @"常见疾病", nil];
        headerview.headerTitle = [headers objectAtIndex:indexPath.section];
        return headerview;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    DoctorListContainerController *topTabVC = [[DoctorListContainerController alloc] initWithHeight:kTopTabBarHeight];
//    topTabVC.subobject = _showObjectList.items[indexPath.row];
//    [self.slideNavigationController pushViewController:topTabVC animated:YES];
    
    DoctorListModel *listModel = [[DoctorListModel alloc] initWithSortType:DoctorSortTypeNone];
#if !LOCAL
    listModel.filter.keyword = [[[_showObjectList.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] name];
    listModel.filter.typeId = [[[_showObjectList.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] type_id];
#else
    listModel.filter.typeId = [[[_showObjectList.items objectAtIndex:indexPath.row] type_id] integerValue];
#endif
    DoctorListController *listVC = [[DoctorListController alloc] initWithPageName:@"DoctorListController" listModel:listModel];
    [self.slideNavigationController pushViewController:listVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
