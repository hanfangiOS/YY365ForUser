//
//  EqualSpaceFlowLayout.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/8.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "EqualSpaceFlowLayout.h"

#define collectionContentTopIntervalY 10
#define collectionContentBottomIntervalY 10

@interface HFWV : UICollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame;
@end

@implementation HFWV

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end

@interface EqualSpaceFlowLayout()
@property (nonatomic, strong) NSMutableArray *itemAttributes;
@end

@implementation EqualSpaceFlowLayout
- (id)init
{
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumInteritemSpacing = 10;
        self.minimumLineSpacing = 10;
//        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.headerReferenceSize = CGSizeMake(kScreenWidth, 40);
        self.sectionHeadersPinToVisibleBounds = NO;
    }
    return self;
}

#pragma mark - Methods to Override
- (void)prepareLayout
{
    [super prepareLayout];
    [self registerClass:[HFWV class] forDecorationViewOfKind:@"HFWV"];//注册Decoration View
    
    self.itemAttributes = [NSMutableArray new];
    
    
    CGFloat yOffset = collectionContentTopIntervalY;
    CGFloat yOffSetDecoration = 0;
    
    for (int section = 0; section < self.collectionView.numberOfSections; section++) {
        UIEdgeInsets tempSectionInset = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];// 此代理必须执行
        NSInteger itemCount = [[self collectionView] numberOfItemsInSection:section];
        NSMutableArray *itemAttributesInSection = [NSMutableArray arrayWithCapacity:itemCount];

        CGFloat xOffset = tempSectionInset.left;
        CGFloat xNextOffset = tempSectionInset.left;
        CGSize headerSize = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section]; // 此代理必须执行

        UICollectionViewLayoutAttributes *layoutAttributes2 = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:itemCount inSection:section]];
        layoutAttributes2.frame = CGRectMake(0, yOffset, headerSize.width,headerSize.height);
        [itemAttributesInSection addObject:layoutAttributes2];
        
        yOffset += headerSize.height;
        yOffSetDecoration = yOffset;
        
        UICollectionViewLayoutAttributes *layoutAttributes3 = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"HFWV" withIndexPath:[NSIndexPath indexPathForItem:itemCount inSection:section]];
//        layoutAttributes3.frame = CGRectMake(0, yOffSetDecoration, self.collectionView.frameWidth,0);
        layoutAttributes3.zIndex = -1;
        
        CGFloat tempMinimumInteritemSpacing = [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];// 此代理必须执行
        CGFloat tempMinimumLineSpacing = [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];// 此代理必须执行

        yOffset += tempMinimumLineSpacing;
        
        for (NSInteger idx = 0; idx < itemCount; idx++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
            CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath]; // 此代理必须执行
            xNextOffset += (tempMinimumInteritemSpacing + itemSize.width);

            if (xNextOffset > [self collectionView].bounds.size.width - tempSectionInset.right) {
                xOffset = tempSectionInset.left;
                xNextOffset = (tempSectionInset.left + tempMinimumInteritemSpacing + itemSize.width);
                yOffset += (itemSize.height + tempMinimumLineSpacing);
            }
            else
            {
                xOffset = xNextOffset - (tempMinimumInteritemSpacing + itemSize.width);
            }

            UICollectionViewLayoutAttributes *layoutAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            layoutAttributes.frame = CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height);
            [itemAttributesInSection addObject:layoutAttributes];
            
            if(idx == itemCount-1){
                yOffset += (itemSize.height + self.minimumLineSpacing + tempMinimumLineSpacing);
            }
        }
        layoutAttributes3.frame = CGRectMake(0, yOffSetDecoration, self.collectionView.frameWidth,yOffset-yOffSetDecoration-self.minimumLineSpacing);
        [itemAttributesInSection addObject:layoutAttributes3];
        [self.itemAttributes addObject:itemAttributesInSection];
    }
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.itemAttributes)[indexPath.section][indexPath.row];
}

- (CGSize)collectionViewContentSize{
    CGFloat hight = 0;
    for (NSArray *arr in self.itemAttributes) {
        for (UICollectionViewLayoutAttributes *item in arr) {
            if (CGRectGetMaxY(item.frame) > hight) {
                hight = CGRectGetMaxY(item.frame);
            }
        }
    }
    return CGSizeMake(self.collectionView.frame.size.width, hight + collectionContentBottomIntervalY);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    for (int section = 0; section < self.collectionView.numberOfSections; section++) {
        NSArray *arr = self.itemAttributes[section];
        for (int row = 0; row < arr.count; row++) {
            if (CGRectIntersectsRect(rect, [arr[row] frame])) {
                [layoutAttributes addObject:arr[row]];
            }
        }
    }
    return layoutAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
@end
