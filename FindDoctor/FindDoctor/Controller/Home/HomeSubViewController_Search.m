 //
//  HomeSubViewController_Search.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/5.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "HomeSubViewController_Search.h"
#import "SearchHistoryCollectionViewCell.h"
#import "HotSearchDoctorCollectionViewCell.h"
#import "SearchHistoryHelper.h"
#import "EqualSpaceFlowLayout.h"
#import "SubObjectHeaderView.h"
#import "CUSearchManager.h"

@interface HomeSubViewController_Search ()<EqualSpaceFlowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *searchHistoryCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *hotSearchClinicArray;  //string
@property (nonatomic, strong) NSMutableArray *hotSearchSymptomArray; //string
@property (nonatomic, strong) NSMutableArray *hotSearchDoctorArray; // Doctor 对象
@property (nonatomic, strong) NSString *currSearchStr;

@end

@implementation HomeSubViewController_Search

- (id)initWithPageName:(NSString *)pageName
{
    self = [super initWithPageName:pageName];
    if (self) {
        _hasNavigationBar = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    __weak __block HomeSubViewController_Search *blockSelf = self;
    
    //热搜诊所
    [[CUSearchManager sharedInstance] gethotSearchClinicListWithResultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError) {
            blockSelf.hotSearchClinicArray = result.parsedModelObject;
            [self.searchHistoryCollectionView  reloadData];
        }
        else{
        
        }
    } pageName:self.pageName];
    
    //热搜病症
    [[CUSearchManager sharedInstance] gethotSearchSymptomListWithResultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError) {
            blockSelf.hotSearchSymptomArray = result.parsedModelObject;
            [self.searchHistoryCollectionView  reloadData];
        }
        else{
            
        }
    } pageName:self.pageName];
    
    [[CUSearchManager sharedInstance] gethotSearchDoctorListWithResultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError) {
            blockSelf.hotSearchDoctorArray = result.parsedModelObject;
            [self.searchHistoryCollectionView  reloadData];
        }
        else{
            
        }
    } pageName:self.pageName];
}

- (void)loadContentView{
    [self loadHistory];
    self.contentView.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
    EqualSpaceFlowLayout *collectionLayout = [[EqualSpaceFlowLayout alloc] init];
    collectionLayout.delegate = self;
    
    CGRect collectionFrame = CGRectMake(0, 0, kScreenWidth, self.contentView.frameHeight - 60 - 49);
    
    UICollectionView *collectionview = [[UICollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:collectionLayout];
    collectionview.backgroundColor = [UIColor clearColor];
    collectionview.delegate = self;
    collectionview.dataSource = self;
    [self.contentView addSubview:collectionview];
    
    self.searchHistoryCollectionView = collectionview;
    
    NSString *historyCollectionCellName = NSStringFromClass([SearchHistoryCollectionViewCell class]);
    [self.searchHistoryCollectionView registerClass:[SearchHistoryCollectionViewCell class] forCellWithReuseIdentifier:historyCollectionCellName];
    
    NSString *hotSearchDoctorcollectionCellName = NSStringFromClass([HotSearchDoctorCollectionViewCell class]);
    [self.searchHistoryCollectionView registerClass:[HotSearchDoctorCollectionViewCell class] forCellWithReuseIdentifier:hotSearchDoctorcollectionCellName];
    
    NSString *collectionHeaderName = NSStringFromClass([SubObjectHeaderView class]);
    [self.searchHistoryCollectionView registerClass:[SubObjectHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionHeaderName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

#pragma mark --UICollectionViewDelegateFlowLayout
////定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return CGSizeMake(kScreenWidth, [HotSearchDoctorCollectionViewCell defaultHeight]);
    }
    if (indexPath.section == 2) {
        CGSize size = [self sizeForString:(NSString *)[self.hotSearchSymptomArray objectAtIndex:indexPath.row] font:[UIFont systemFontOfSize:12] limitSize:CGSizeMake(0, 12)];
        return CGSizeMake(size.width+20, size.height+15);
    }
    if (indexPath.section == 3) {
        CGSize size = [self sizeForString:(NSString *)[self.hotSearchClinicArray objectAtIndex:indexPath.row] font:[UIFont systemFontOfSize:12] limitSize:CGSizeMake(0, 12)];
        return CGSizeMake(size.width+20, size.height+15);
    }
    CGSize size = [self sizeForString:(NSString *)[self.dataArray objectAtIndex:indexPath.row] font:[UIFont systemFontOfSize:12] limitSize:CGSizeMake(0, 12)];
    return CGSizeMake(size.width+20, size.height+15);
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.hotSearchDoctorArray.count;
    }
    if (section == 2){
        return self.hotSearchSymptomArray.count;
    }
    if (section == 3){
        return self.hotSearchClinicArray.count;
    }
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSString *collectionCellName = NSStringFromClass([HotSearchDoctorCollectionViewCell  class]);
        HotSearchDoctorCollectionViewCell *collectionCell = (HotSearchDoctorCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellName forIndexPath:indexPath];
        collectionCell.data = [self.hotSearchDoctorArray objectAtIndex:indexPath.row];
        if (indexPath.row == self.hotSearchDoctorArray.count - 1) {
            collectionCell.hasLine = NO;
        }
        else{
            collectionCell.hasLine = YES;
        }
        return collectionCell;
    }
    
    if (indexPath.section == 2){
        NSString *collectionCellName = NSStringFromClass([SearchHistoryCollectionViewCell class]);
        SearchHistoryCollectionViewCell *collectionCell = (SearchHistoryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellName forIndexPath:indexPath];
        collectionCell.string = (NSString *)[self.hotSearchSymptomArray objectAtIndex:indexPath.row];
        collectionCell.backgroundColor = [UIColor clearColor];
        return collectionCell;
    }
    
    if (indexPath.section == 3){
        NSString *collectionCellName = NSStringFromClass([SearchHistoryCollectionViewCell class]);
        SearchHistoryCollectionViewCell *collectionCell = (SearchHistoryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellName forIndexPath:indexPath];
        collectionCell.string = (NSString *)[self.hotSearchClinicArray objectAtIndex:indexPath.row];
        collectionCell.backgroundColor = [UIColor clearColor];
        return collectionCell;
    }

    NSString *collectionCellName = NSStringFromClass([SearchHistoryCollectionViewCell class]);
    SearchHistoryCollectionViewCell *collectionCell = (SearchHistoryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellName forIndexPath:indexPath];
    collectionCell.string = (NSString *)[self.dataArray objectAtIndex:indexPath.row];
    collectionCell.backgroundColor = [UIColor clearColor];

    return collectionCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if(section == 1){
        return 0;
    }
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if(section == 1){
        return 0;
    }
    return 5;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSString *collectionHeaderName = NSStringFromClass([SubObjectHeaderView class]);
        SubObjectHeaderView *headerview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:collectionHeaderName forIndexPath:indexPath];
        NSArray *headers = [[NSArray alloc] initWithObjects:@"搜索记录", @"热搜医师", @"热搜病症",@"热搜诊所", nil];
        headerview.headerTitle = [headers objectAtIndex:indexPath.section];
        return headerview;
    }
    else{
        
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth, 27);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if(section == 1){
        return UIEdgeInsetsMake(0,0,0,0);
    }
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark - scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.delegate HomeSubViewController_SearchEndEdit];
}

#pragma mark - Search History

- (void)loadHistory
{
//    NSArray *arr = @[@"历史记录",@"历史记录历史记录",@"历史记录",@"历史记录历史记录",@"历史记录",@"历史记录历史记录"];
    self.dataArray = [NSMutableArray arrayWithArray:[SearchHistoryHelper searchHistoryArray]];
    [self.searchHistoryCollectionView reloadData];
}

- (void)searchClickWithString:(NSString *)searchStr
{
    if (searchStr.length == 0) {
        return;
    }
    
    self.currSearchStr = searchStr;
    [SearchHistoryHelper saveSearchHistory:searchStr];
    
    [self loadHistory];
}

- (void)searchStringDidChange:(NSString *)searchStr
{
    if (searchStr.length == 0) {
        [self loadHistory];
    }
    else {
        self.currSearchStr = searchStr;
    }
}

- (CGSize)sizeForString:(NSString *)string font:(UIFont *)font limitSize:(CGSize)limitSize{
    
    CGFloat width = limitSize.width;
    CGFloat height = limitSize.height;
    if (!width) {
        width = CGFLOAT_MAX;
    }
    if (!height) {
        height = CGFLOAT_MAX;
    }
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, height)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    
    return rect.size;
}

@end
