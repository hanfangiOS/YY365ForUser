//
//  HomeSubViewController_Search.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/5.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "HomeSubViewController_Search.h"
#import "SearchHistoryCollectionViewCell.h"
#import "SearchHistoryHelper.h"

@interface HomeSubViewController_Search ()

@property (nonatomic, strong) UICollectionView *searchHistoryCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
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

- (void)loadContentView{
    float item_interval_x = 15*kScreenRatio;
    float margin = 30*kScreenRatio;
    float item_interval_y = 12*kScreenRatio;
    
    int line_number = 3;
    float item_width = (kScreenWidth-margin*2-item_interval_x*(line_number-1))/line_number;
    float item_height = 100*kScreenRatio;
    
    float header_height = 55.f;
    
    [self loadHistory];
    
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
    
    self.searchHistoryCollectionView = collectionview;
    
    NSString *collectionCellName = NSStringFromClass([SearchHistoryCollectionViewCell class]);
    [self.searchHistoryCollectionView registerClass:[SearchHistoryCollectionViewCell class] forCellWithReuseIdentifier:collectionCellName];
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
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [self sizeForString:(NSString *)[self.dataArray objectAtIndex:indexPath.row] font:[UIFont systemFontOfSize:12] limitSize:CGSizeMake(0, 12)];
    
    return CGSizeMake(size.width+10, size.height+10);
}
//定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return -5;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *collectionCellName = NSStringFromClass([SearchHistoryCollectionViewCell class]);
    SearchHistoryCollectionViewCell *collectionCell = (SearchHistoryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellName forIndexPath:indexPath];
    collectionCell.string = (NSString *)[self.dataArray objectAtIndex:indexPath.row];
    return collectionCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Search History

- (void)loadHistory
{
    NSArray *arr = @[@"历史记录",@"历史记录历史记录",@"历史记录",@"历史记录历史记录",@"历史记录",@"历史记录历史记录"];
    self.dataArray = [NSMutableArray arrayWithArray:arr];
    //    self.dataArray = [NSMutableArray arrayWithArray:[SearchHistoryHelper searchHistoryArray]];
    [self.searchHistoryCollectionView reloadData];
}

- (void)searchClickWithString:(NSString *)searchStr
{
    if (searchStr.length == 0) {
        return;
    }
    
    self.currSearchStr = searchStr;
    [SearchHistoryHelper saveSearchHistory:searchStr];
    
//    if (self.action) {
//        self.action(searchStr);
//    }
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
