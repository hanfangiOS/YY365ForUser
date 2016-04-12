//
//  EqualSpaceFlowLayout.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/8.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "EqualSpaceFlowLayout.h"

@interface EqualSpaceFlowLayout()
@property (nonatomic, strong) NSMutableArray *itemAttributes;
@end

@implementation EqualSpaceFlowLayout
- (id)init
{
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumInteritemSpacing = 5;
        self.minimumLineSpacing = 5;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.headerReferenceSize = CGSizeMake(kScreenWidth, 40);
    }
    
    return self;
}

#pragma mark - Methods to Override
- (void)prepareLayout
{
    [super prepareLayout];

    self.itemAttributes = [NSMutableArray new];
    
    CGFloat yOffset = self.sectionInset.top;
    
    for (int section = 0; section < self.collectionView.numberOfSections; section++) {
        NSInteger itemCount = [[self collectionView] numberOfItemsInSection:section];
        NSMutableArray *itemAttributesInSection = [NSMutableArray arrayWithCapacity:itemCount];
//        self.itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
        
        CGFloat xOffset = self.sectionInset.left;
        
        if (section != 0) {
            yOffset += self.sectionInset.bottom + 60;
        }
        CGFloat xNextOffset = self.sectionInset.left;
        for (NSInteger idx = 0; idx < itemCount; idx++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
            CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
            
            xNextOffset+=(self.minimumInteritemSpacing + itemSize.width);
            if (xNextOffset > [self collectionView].bounds.size.width - self.sectionInset.right) {
                xOffset = self.sectionInset.left;
                xNextOffset = (self.sectionInset.left + self.minimumInteritemSpacing + itemSize.width);
                yOffset += (itemSize.height + self.minimumLineSpacing);
            }
            else
            {
                xOffset = xNextOffset - (self.minimumInteritemSpacing + itemSize.width);
            }
            
            UICollectionViewLayoutAttributes *layoutAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            layoutAttributes.frame = CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height);
            [itemAttributesInSection addObject:layoutAttributes];

//            UICollectionViewLayoutAttributes *layoutAttributes2 =
//            [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"UICollectionElementKindSectionHeader" withIndexPath:indexPath];
//            layoutAttributes2.frame = CGRectMake(0, 0, kScreenWidth, 40);
//            [_itemAttributes addObject:layoutAttributes2];
        }
        [self.itemAttributes addObject:itemAttributesInSection];
    }
}

- (CGSize)collectionViewContentSize{
    CGSize size = CGSizeMake(kScreenWidth, self.collectionView.frameHeight * 2);
    return size;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.itemAttributes)[indexPath.section][indexPath.row];
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
}
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath{
    return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
}


//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    return [self.itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
//        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
//    }]];
//}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    for (int section = 0; section < self.collectionView.numberOfSections; section++) {
        
        NSPredicate * predicate = [NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
            return CGRectIntersectsRect(rect, [evaluatedObject frame]);
        }];
        
        NSArray * array1 = [self.itemAttributes[section] filteredArrayUsingPredicate:predicate];
        
        [layoutAttributes addObjectsFromArray:array1];
    }
    return layoutAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
@end
