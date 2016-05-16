//
//  SelectCityVC.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/5/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "SelectCityVC.h"
#import "EqualSpaceFlowLayout.h"
#import "SubObjectHeaderView.h"
#import "SelectCityCollectionViewCell.h"

@interface SelectCityVC ()<UICollectionViewDelegate,UICollectionViewDataSource,EqualSpaceFlowLayoutDelegate>
@property (strong, nonatomic) UICollectionView *contentCollectionView;
@property (strong, nonatomic) NSArray *dataArray;
@end

@implementation SelectCityVC

- (void)viewDidLoad {
    self.dataArray = [NSMutableArray arrayWithObject:@"成都市"];
    [super viewDidLoad];
}

- (void)loadContentView{
    self.contentView.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
    EqualSpaceFlowLayout *collectionLayout = [[EqualSpaceFlowLayout alloc] init];
    collectionLayout.delegate = self;
    
    CGRect collectionFrame = CGRectMake(0, 0, kScreenWidth, self.contentView.frameHeight - 60);
    
    UICollectionView *collectionview = [[UICollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:collectionLayout];
    collectionview.backgroundColor = [UIColor clearColor];
    collectionview.delegate = self;
    collectionview.dataSource = self;
    [self.contentView addSubview:collectionview];
    
    self.contentCollectionView = collectionview;
    
    NSString *collectionCellName = NSStringFromClass([SelectCityCollectionViewCell class]);
    [self.contentCollectionView registerClass:[SelectCityCollectionViewCell class] forCellWithReuseIdentifier:collectionCellName];
    
    NSString *collectionHeaderName = NSStringFromClass([SubObjectHeaderView class]);
    [self.contentCollectionView registerClass:[SubObjectHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionHeaderName];
}

#pragma mark --UICollectionViewDelegateFlowLayout
////定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CGSize size = [self sizeForString:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"] font:[UIFont systemFontOfSize:12] limitSize:CGSizeMake(0, 12)];
        return CGSizeMake(size.width+20, size.height+15);
    }
    CGSize size = [self sizeForString:(NSString *)[self.dataArray objectAtIndex:indexPath.row] font:[UIFont systemFontOfSize:12] limitSize:CGSizeMake(0, 12)];
    return CGSizeMake(size.width+20, size.height+15);
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *collectionCellName = NSStringFromClass([SelectCityCollectionViewCell class]);
    SelectCityCollectionViewCell *collectionCell = (SelectCityCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellName forIndexPath:indexPath];
    if (indexPath.section == 0) {
        collectionCell.string = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"];
        collectionCell.isValue = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"] isEqualToString:@"成都市"];
    }
    else{
        collectionCell.string = (NSString *)[self.dataArray objectAtIndex:indexPath.row];
    }
    collectionCell.backgroundColor = [UIColor clearColor];
    return collectionCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"] isEqualToString:@"成都市"]) {
            [self backAction];
        }
    }
    else{
        [self backAction];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSString *collectionHeaderName = NSStringFromClass([SubObjectHeaderView class]);
        SubObjectHeaderView *headerview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:collectionHeaderName forIndexPath:indexPath];
        NSArray *headers = [[NSArray alloc] initWithObjects:@"当前城市", @"支持城市", nil];
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
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
